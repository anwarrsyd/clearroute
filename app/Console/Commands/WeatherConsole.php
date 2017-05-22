<?php

namespace App\Console\Commands;
use SimpleXMLElement;

use Illuminate\Console\Command;
use DB;
class WeatherConsole extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'weather:console';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'This command will update weather status';

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

        $xml=file_get_contents("http://ridhoperdana.net/TA_FIX/test.xml");
        $date=date("h:i:sa");
        
        $data=new SimpleXMLElement($xml);
        foreach ($data->rekaman as $key ) {
        	if($key->kategori >=1 && $key->kategori <=2){
        		DB::table('datapos')->where('idpos',$key->idpos)->update(['kategori'=>1]); //berawan
        	}

        	if($key->kategori >=3 && $key->kategori <=8){
        		DB::table('datapos')->where('idpos',$key->idpos)->update(['kategori'=>2]);//hujan ringan
        	}

        	if($key->kategori >=9 && $key->kategori <=11){
        		DB::table('datapos')->where('idpos',$key->idpos)->update(['kategori'=>3]); //hujan sedang
        	}
        	if($key->kategori >=12 && $key->kategori <=13){
        		DB::table('datapos')->where('idpos',$key->idpos)->update(['kategori'=>4]); //deras
        	}
        	if($key->kategori >13 ){
        		DB::table('datapos')->where('idpos',$key->idpos)->update(['kategori'=>5]); //sangat deras
        	}
        	if($key->kategori ==1){
        		DB::table('datapos')->where('idpos',$key->idpos)->update(['kategori'=>0]); //cerah
        	}
   		

        }

    }
}
