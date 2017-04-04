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
        $xml=file_get_contents("http://110.139.67.15/sby/rekaman_tenminute.xml");
       // $data->loadHTML($xml);

        $data=new SimpleXMLElement($xml);
        foreach ($data->rekaman as $key ) {
           DB::table('datapos')->where('idpos',$key->idpos)->update(['kategori'=>$key->kategori]);

        }

    }
}
