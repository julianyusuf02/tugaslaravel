<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreBarangRequest;
use App\Models\BarangModel;
use Illuminate\Http\Request;
use Yajra\DataTables\DataTables;
use Yajra\DataTables\Facades\DataTables as FacadesDataTables;
use Validator;

class barangcontroller extends Controller
{
    //
    protected $id_barang;
    protected $kode_barang;
    protected $nama_barang;
    protected $harga;
    protected $barangModel;
    public $timestamps= false;

    public function __construct()
    {
        $this->barangModel = new BarangModel(); 
    }
    public function index(){
        /**
         * menanmpilkan data barang dari db menggunakan datatable serverside
         * end point untuk api adalaha pada function atau method
         * dataBarang()
         */
    
    return view('barang.index');
    
}
    //menampilkan form tambah barang
    public function tambah(){
        return view('barang.tambah');

    }
    //method untuk aksi simpan barang dri form data dikkirim oleh method tambah
    public function simpan(StoreBarangRequest $request){
        $data = $request->validated();
        if($data):
            if(isset($request->id_barang)):
                //* proses update
                $perintah = BarangModel::where('id_barang', $request->id_barang)->update($data);
                if($perintah):
                    $pesan = [
                        'status' => 'success',
                        'pesan' => 'Data Berhasil Diupdate'
                    ];
                else:
                    $pesan = [
                        'status' => 'error',
                        'pesan' => 'Data Gagal Diupdate'
                    ];
                endif;
            else:
                // *proses tambah data baru
                $dataBaru = BarangModel::create($data);
                if($dataBaru):
                    $pesan = [
                        'status' => 'success',
                        'pesan' => 'Data Barang Baru Berhasil Ditambahkan ke Database'
                    ];
                else:
                    $pesan = [
                        'status' => 'error',
                        'pesan' => 'Data Gagal Ditambahkan ke Database'
                    ];
                endif;
            endif;
        else:
            $pesan = [
                'status' => 'error',
                'pesan' => 'Proses Validasi gagal'
            ];
        endif;

        return response()->json($pesan);


    



    }
    //method akan menamppilakn form update data yang kana dikirm ke method simpan
    public function update(Request $request){
        $data =[
            'BarangDetil' => BarangModel::where('id_barang',$request->id_barang)->first()

        ];
        return view('barang.edit',$data);

        //method hapus data yg dikirm form ajax yg sudah di konfirm
    }
    public function delete(Request $request){
        //method endpoint api data table serverside
    }
    
    public function dataBarang(Request $request){

        if($request->ajax()):
            $data = $this->barangModel->with('stok')->get();
            return DataTables::of($data)->toJson();
        endif;
    }
}

