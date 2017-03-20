<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class WeatherForecast extends Controller
{
    public function pengumpulandata(){

    		$query=DB::table('datapos')->select('idpos','xramalan','yramalan','namapos')->get();
    		// dd($query);

		  	$tahun=date('Y');
    		$bulan= strtoupper(date('M'));
    		$hari=date('d')-1;
    		$harisaatini=date('d');    		
    		$haha=date('m');
    		$tanggal=$tahun.$haha;
    		$tanggal2=$tahun.$haha.$hari;
    		$number=3;
    		for ($i=0; $i < 9; $i++) { 
    		if($number==24){
    			$number=0;
    		}
    		$jam = sprintf("%02.2d", $number);
			$gambar=imagecreatefromgif('http://diseminasi.meteo.bmkg.go.id/wrf/indo_'.$tanggal.'/'.$tanggal2.'1200/jawa/HUJAN.03-JAM.'.$tanggal2.'1200/prec03-'.$tahun.''.$bulan.''.$harisaatini.''.$jam.'.gif');
		    foreach ($query as $key => $value) {

		    	if ($value->xramalan!=null) {
		    		

		    		$rgb=imagecolorat($gambar, $value->xramalan, $value->yramalan);
					$cols = imagecolorsforindex($gambar, $rgb);
					$r = dechex($cols['red']);
					$g = dechex($cols['green']);
					$b = dechex($cols['blue']);
					$warna="#".$r.$g.$b;
					// echo "<br>";
					echo $value->namapos;
					echo "<br>";	
					if ($warna =='#b4faaa'||$warna=='#96f58c'||$warna=='#78f573'||$warna=='#50f050'||$warna=='#37d23c') {
						echo "Berawan/Hujan Sangat Ringan";
					}
					elseif ($warna=='#0fa00f'||$warna=='#fa0f') {
						echo "Hujan Ringan";
					}
					elseif ($warna=='#e6dc32') {
						echo "Hujan Sedang";
					}
					elseif ($warna=='#f08228') {
						echo "Hujan deras";
					}
					elseif ($warna=='#fa3c3c') {
						echo "Hujan sangat deras";
					}
					elseif($warna=='#ffffff'){
						echo "Cerah";
					}
					echo "<br>";
					echo $warna;
					echo "<br>";
					echo "<br>";
					


		    	}
				   

		    }
		    $number+=3;
    	}
    	
		    
    }
}
