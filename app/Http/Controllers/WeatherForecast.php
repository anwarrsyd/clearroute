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
    		$number=0;
    		$gambar=imagecreatefromgif('http://diseminasi.meteo.bmkg.go.id/wrf/indo_'.$tanggal.'/'.$tanggal2.'1200/jawa/HUJAN.03-JAM.'.$tanggal2.'1200/prec03-'.$tahun.''.$bulan.''.$hari.''.'21'.'.gif');
		    foreach ($query as $key => $value) {
		    	$xx=4;
		    	$jam1 = sprintf("%02.2d", $xx);
		    	if ($value->xramalan!=null) {
		    		// $jam = sprintf("%02.2d", $number);
		    		$valid=date('Y-m-d');
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
						echo "Berawan";
						DB::table('rekaman')->insert([
							'idrekaman'=>$tahun.$bulan.$harisaatini.$jam1,
							'idpos'=>$value->idpos,
							'kategori'=>1,
							'validtime'=>'04:00:00',
							'validdate'=>$valid,
							]);
					}
					elseif ($warna=='#0fa00f'||$warna=='#fa0f') {
						echo "Hujan Ringan";
							DB::table('rekaman')->insert([
							'idrekaman'=>$tahun.$bulan.$harisaatini.$jam1,
							'idpos'=>$value->idpos,
							'kategori'=>2,
							'validtime'=>'04:00:00',
							'validdate'=>$valid,
							]);
					}
					elseif ($warna=='#e6dc32') {
						echo "Hujan Sedang";
							DB::table('rekaman')->insert([
							'idrekaman'=>$tahun.$bulan.$harisaatini.$jam1,
							'idpos'=>$value->idpos,
							'kategori'=>3,
							'validtime'=>'04:00:00',
							'validdate'=>$valid,
							]);
					}
					elseif ($warna=='#f08228') {
						echo "Hujan deras";
							DB::table('rekaman')->insert([
							'idrekaman'=>$tahun.$bulan.$harisaatini.$jam1,
							'idpos'=>$value->idpos,
							'kategori'=>4,
							'validtime'=>'04:00:00',
							'validdate'=>$valid,
							]);
					}
					elseif ($warna=='#fa3c3c') {
						echo "Hujan sangat deras";
							DB::table('rekaman')->insert([
							'idrekaman'=>$tahun.$bulan.$harisaatini.$jam1,
							'idpos'=>$value->idpos,
							'kategori'=>5,
							'validtime'=>'04:00:00',
							'validdate'=>$valid,
							]);
					}
					elseif($warna=='#ffffff'){
							DB::table('rekaman')->insert([
							'idrekaman'=>$tahun.$bulan.$harisaatini.$jam1,
							'idpos'=>$value->idpos,
							'kategori'=>0,
							'validtime'=>'04:00:00',
							'validdate'=>$valid,
							]);
						echo "Cerah";
					}
					else{
							DB::table('rekaman')->insert([
							'idrekaman'=>$tahun.$bulan.$harisaatini.$jam1,
							'idpos'=>$value->idpos,
							'kategori'=>6,
							'validtime'=>'04:00:00',
							'validdate'=>$valid,
							]);
					}
					echo "<br>";
					echo $warna;
					echo "<br>";
					echo "<br>";
		
		    	}
		    }

    		for ($i=0; $i < 7; $i++) { 
       		$jam = sprintf("%02.2d", $number);
       		$w=$jam+7;
       		if($w==25){
         		$w='01';
       		}
       		$wib=$w.':00:00';
       		$flag=date('Y-m-d ');
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
						echo "Berawan";
						DB::table('rekaman')->insert([
							'idrekaman'=>$tahun.$bulan.$harisaatini.$jam,
							'idpos'=>$value->idpos,
							'kategori'=>1,
							'validtime'=>$wib,
							'validdate'=>$flag,
							]);
					}
					elseif ($warna=='#0fa00f'||$warna=='#fa0f') {
						echo "Hujan Ringan";
							DB::table('rekaman')->insert([
							'idrekaman'=>$tahun.$bulan.$harisaatini.$jam,
							'idpos'=>$value->idpos,
							'kategori'=>2,
							'validtime'=>$wib,
							'validdate'=>$flag,
							]);
					}
					elseif ($warna=='#e6dc32') {
						echo "Hujan Sedang";
							DB::table('rekaman')->insert([
							'idrekaman'=>$tahun.$bulan.$harisaatini.$jam,
							'idpos'=>$value->idpos,
							'kategori'=>3,
							'validtime'=>$wib,
							'validdate'=>$flag,
							]);
					}
					elseif ($warna=='#f08228') {
						echo "Hujan deras";
							DB::table('rekaman')->insert([
							'idrekaman'=>$tahun.$bulan.$harisaatini.$jam,
							'idpos'=>$value->idpos,
							'kategori'=>4,
							'validtime'=>$wib,
							'validdate'=>$flag,
							]);
					}
					elseif ($warna=='#fa3c3c') {
						echo "Hujan sangat deras";
							DB::table('rekaman')->insert([
							'idrekaman'=>$tahun.$bulan.$harisaatini.$jam,
							'idpos'=>$value->idpos,
							'kategori'=>5,
							'validtime'=>$wib,
							'validdate'=>$flag,
							]);
					}
					elseif($warna=='#ffffff'){
							DB::table('rekaman')->insert([
							'idrekaman'=>$tahun.$bulan.$harisaatini.$jam,
							'idpos'=>$value->idpos,
							'kategori'=>0,
							'validtime'=>$wib,
							'validdate'=>$flag,
							]);
						echo "Cerah";
					}
					else{
							DB::table('rekaman')->insert([
							'idrekaman'=>$tahun.$bulan.$harisaatini.$jam,
							'idpos'=>$value->idpos,
							'kategori'=>6,
							'validtime'=>$wib,
							'validdate'=>$flag,
							]);
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

    public function cobajam(){
    	date_default_timezone_set("Asia/Jakarta");

    	$date=date('h:i:a');
	    dd($date);

    }
}
