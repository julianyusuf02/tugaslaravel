<?php

use App\Http\Controllers\barangcontroller;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Route::prefix('/barang')->group(function(){
    Route::get('/',[barangcontroller::class,'index'])->name('barang.index');
    Route::get('/data',[barangcontroller::class,'dataBarang'])->name('barang.data');
    Route::get('/tambah',[barangcontroller::class,'tambah'])->name('barang.tambah');
    Route::get('/edit/{id_barang}',[barangcontroller::class,'update'])->name('barang.edit');
   Route::post('/simpan',[barangcontroller::class,'simpan'])->name('barang.simpan');
});