<?php
namespace App\Http\Controllers;

use DB;
use SimpleXMLElement;

use Illuminate\Http\Request;

class HomeController extends Controller
{
    public function coba(){

    		$koordinat=DB::table('datapos')->select('xdesimal','ydesimal','idpos')->get();
    		// dd($koordinat);
    		foreach ($koordinat as $key ) {
    		$coba = DB::table("datapos")->select(DB::raw("ST_GeomFromText('POINT(".$key->xdesimal."  ".$key->ydesimal.")',4326)"))->first();
    		 // dd($coba);
    		 
    		DB::table('datapos')
            ->where('idpos', $key->idpos)
            ->update(['the_geom' => $coba->st_geomfromtext]);	
    		}
    }

    public function lokasi($lat,$long){

        $lokasi=DB::select(" Select *, ST_Distance(
            ST_Transform(ST_GeomFromText('POINT(".$long." ".$lat.")',4326),2163),
            ST_Transform(datapos.the_geom,2163)
        ) as jarak from datapos ORDER BY ST_Transform(datapos.the_geom,2163) <->
         ST_Transform(ST_GeomFromText('POINT(".$long." ".$lat.")',4326),2163) LIMIT 5");
        dd($lokasi);
    }

    public function getRoute($x1, $y1, $x3, $y3)
    {
        // $array[0] = DB::SELECT("SELECT * FROM pgr_normalroute('ways', ".$x3.",".$y3.",".$x1.",".$y1.")");
        $array[0] = DB::SELECT("SELECT jsonb_build_object(
                                'type',       'Feature',
                                'properties', '{}',
                                'geometry',   ST_AsGeoJSON(geom)::jsonb
                            ) AS json FROM (SELECT * FROM pgr_normalroute('backup_ways', ".$x3.",".$y3.",".$x1.",".$y1.")) AS row");

        for($i=1; $i<=2; $i++)
        {
            $x2 = $this->finalLongitude($x3, $x1);
            $y2 = $this->finalLatitude($y3, $y1);
            $array[$i] = DB::SELECT("SELECT jsonb_build_object(
                'type',       'Feature',
                'properties', '{}',
                'geometry',   ST_AsGeoJSON(geom)::jsonb
            ) AS json FROM (SELECT * FROM pgr_aStarFromAtoBviaC_line('backup_ways', ".$x3.",".$y3.",".$x2.",".$y2.",".$x1.",".$y1.")) AS row WHERE row.gid IS NOT NULL");
        }

        return $array;
    }

    function randomFloat($min = 0, $max = 1) {
        return $min + mt_rand() / mt_getrandmax() * ($max - $min);
    }

    function randomLatitude($latitude)
    {
        $number_asli = $latitude;
        $number = $number_asli*-1;
        $int_number = floor($number);
        $decimal = $number - $int_number;
        if(mt_rand(1,10)>5)
        {
          $decimal_batas_baru = $decimal*1.1;
          $batas_baru = ($int_number+$decimal_batas_baru)*-1;
        }
        else
        {
          $decimal_batas_baru = $decimal*1.1;
          $decimal_batas_baru = $decimal_batas_baru - $decimal;
          $batas_baru = ($int_number+($decimal-$decimal_batas_baru))*-1;
        }

        return $batas_baru;
    }

    function finalLatitude($latitude_awal, $latitude_akhir)
    {
        return $this->randomFloat($latitude_awal, $this->randomLatitude($latitude_akhir));
    }

    function finalLongitude($longitude_awal, $longitude_akhir)
    {
        return $this->randomFloat($longitude_awal, $this->randomLongitude($longitude_akhir));
    }  

    function randomLongitude($longitude)
    {
        $number_asli = $longitude;
        $number = $number_asli;
        $int_number = floor($number);
        $decimal = $number - $int_number;
        if(mt_rand(1,10)>5)
        {
          $decimal_batas_baru = $decimal*1.005;
          $batas_baru = ($int_number+$decimal_batas_baru);
        }
        else
        {
          $decimal_batas_baru = $decimal*1.005;
          $decimal_batas_baru = $decimal_batas_baru - $decimal;
          $batas_baru = ($int_number+($decimal-$decimal_batas_baru));
        }

        return $batas_baru;
    }

    public function kondisicuaca($x1,$y1,$x2,$y2){
        $str=$this->getRoute($x1,$y1,$y2,$x2);
        $coba=json_decode($str);

         // rute 1
        for ($a=0; $a <3 ; $a++) { 
               $count=0;
               $i=0;
               foreach ($coba[$a] as $key => $value) {
               $x=$value->x;
               $y=$value->y;
                   
                if($x!==null){
                       $query=DB::select("SELECT * FROM datapos  ORDER BY the_geom <-> ST_GeometryFromText('POINT(".$x."  ".$y.")',4326)  LIMIT 1 ");
                        //     $query=DB::select("select *, sqrt(power( (6371*cos(datapos.ydesimal)*cos(datapos.xdesimal))- (6371*cos(".$y.")*cos(".$x.")),2)+
                        // power( (6371*cos(datapos.ydesimal)*sin(datapos.xdesimal))-(6371*cos(".$y.")*sin(".$x.")),2)) as jarak from datapos 
                        // order by jarak limit 1");
                       
                       foreach ($query as $key => $hasil) {
                        $kategoricuaca=DB::table('rekaman')->select('kategori')->where('idpos','=',$hasil->idpos)->get();
                       
                        foreach ($kategoricuaca as $key => $mantap) {
                                            $i+=$mantap->kategori;
                                            $coba[$a][$count]->kategori=$mantap->kategori;
                                            $count++;
                                        }                                               
                    }              
                }
                }
           }

         return json_encode($coba);  
    }

    public function cobaxml(){
        $xml=file_get_contents("http://110.139.67.15/sby/rekaman_tenminute.xml");
        $data=new SimpleXMLElement($xml);
        foreach ($data->rekaman as $key ) {
            DB::table('rekaman')->insert(
                    ['idrekaman'=>$key->idrekaman,
                     'idpos'=>$key->idpos,
                     'tipe'=>$key->tipe,
                     'curah'=>$key->curah,
                     'kategori'=>$key->kategori
                    ]
                );
        }

    }
}
 