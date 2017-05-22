<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

route::get('coba','HomeController@coba');
route::get('lokasi/{lat}/{long}','HomeController@lokasi');
route::get('getroute/{long1}/{lat1}/{long3}/{lat3}','HomeController@getRoute');
route::get('getroutecuaca/{long1}/{lat1}/{long3}/{lat3}','HomeController@getRouteCuaca');
route::get('getroutecuaca1/{long1}/{lat1}/{long3}/{lat3}','HomeController@getRouteCuaca1');
route::get('kondisicuaca/{long1}/{lat1}/{long3}/{lat3}','HomeController@kondisicuaca');
route::get('cobaxml','HomeController@cobaxml');
route::get('cobajson/{long1}/{lat1}/{long3}/{lat3}','HomeController@cobajsonlagi');
route::get('xmlbmkg','HomeController@xmlbmkg');
route::get('cuaca/{waktu}/{long1}/{lat1}/{long3}/{lat3}','HomeController@cuaca');
route::get('knn','HomeController@knn');
route::get('ramalan','WeatherForecast@pengumpulandata');
route::get('jam','WeatherForecast@cobajam');
route::get('isidir','HomeController@isidir');
route::get('cuacalokal/{x}/{y}','HomeController@localweather');
route::get('cuaca24jam/{x}/{y}','HomeController@cuaca24jam');
route::get('graph/{x}/{y}/{date}','HomeController@graph');
route::get('get1rute/{long1}/{lat1}/{long3}/{lat3}','HomeController@get1rute');
route::get('get1rutealternatif/{long1}/{lat1}/{long3}/{lat3}','HomeController@get1rutealternatif');



