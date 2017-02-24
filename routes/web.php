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
route::get('cobajson','HomeController@kondisicuaca');
route::get('cobaxml','HomeController@cobaxml');