<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use DB;

class UpdateForecast extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'update:forecast';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'This Command will update weather forecast at 08:00 am ';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {
        
            $query=DB::table('datapos')->select('idpos','xramalan','yramalan','namapos')->get();
            // dd($query);
            $hari= sprintf("%02.2d", date('d')-1);
            $harisaatini=sprintf("%02.2d",date('d'));    
            $tahun=date('Y');
            $bulan= strtoupper(date('M'));
            
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
                        DB::table('rekaman')->
                        
                            where('idrekaman',$tahun.$bulan.$harisaatini.$jam1)->update(['kategoriramalan'=>1]);
                            
                    }
                    elseif ($warna=='#0fa00f'||$warna=='#fa0f') {
                        echo "Hujan Ringan";
                            DB::table('rekaman')->
                        
                            where('idrekaman',$tahun.$bulan.$harisaatini.$jam1)->update(['kategoriramalan'=>2]);
                    }
                    elseif ($warna=='#e6dc32') {
                        echo "Hujan Sedang";
                        
                            DB::table('rekaman')->  
                            where('idrekaman',$tahun.$bulan.$harisaatini.$jam1)->update(['kategoriramalan'=>3]);
                    }
                    elseif ($warna=='#f08228') {
                        echo "Hujan deras";
                            DB::table('rekaman')->
                        
                            where('idrekaman',$tahun.$bulan.$harisaatini.$jam1)->update(['kategoriramalan'=>4]);
                    }
                    elseif ($warna=='#fa3c3c') {
                        echo "Hujan sangat deras";
                            DB::table('rekaman')->
                        
                            where('idrekaman',$tahun.$bulan.$harisaatini.$jam1)->update(['kategoriramalan'=>5]);
                    }
                    elseif($warna=='#ffffff'){
                            DB::table('rekaman')->
                        
                            where('idrekaman',$tahun.$bulan.$harisaatini.$jam1)->update(['kategoriramalan'=>0]);
                        echo "Cerah";
                    }
                    else{
                            DB::table('rekaman')->
                        
                            where('idrekaman',$tahun.$bulan.$harisaatini.$jam1)->update(['kategoriramalan'=>6]);
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
                $w='00';
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
                        DB::table('rekaman')->
                        
                            where('idrekaman',$tahun.$bulan.$harisaatini.$jam1)->update(['kategoriramalan'=>1]);
                            
                    }
                    elseif ($warna=='#0fa00f'||$warna=='#fa0f') {
                        echo "Hujan Ringan";
                            DB::table('rekaman')->
                        
                            where('idrekaman',$tahun.$bulan.$harisaatini.$jam1)->update(['kategoriramalan'=>2]);
                    }
                    elseif ($warna=='#e6dc32') {
                        echo "Hujan Sedang";
                            
                            DB::table('rekaman')->
                        
                            where('idrekaman',$tahun.$bulan.$harisaatini.$jam1)->update(['kategoriramalan'=>3]);
                    }
                    elseif ($warna=='#f08228') {
                        echo "Hujan deras";
                            DB::table('rekaman')->
                        
                            where('idrekaman',$tahun.$bulan.$harisaatini.$jam1)->update(['kategoriramalan'=>4]);
                    }
                    elseif ($warna=='#fa3c3c') {
                        echo "Hujan sangat deras";
                            DB::table('rekaman')->
                        
                            where('idrekaman',$tahun.$bulan.$harisaatini.$jam1)->update(['kategoriramalan'=>5]);
                    }
                    elseif($warna=='#ffffff'){
                            DB::table('rekaman')->
                            where('idrekaman',$tahun.$bulan.$harisaatini.$jam1)->update(['kategoriramalan'=>0]);
                        echo "Cerah";
                    }
                    else{
                            DB::table('rekaman')->
                        
                            where('idrekaman',$tahun.$bulan.$harisaatini.$jam1)->update(['kategoriramalan'=>6]);
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
