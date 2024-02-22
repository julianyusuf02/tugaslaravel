@extends('template/template')

@section('title', 'Data Barang eToko')

@section('content')
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                Daftar Barang
            </div>
            <div class="card-body">
                <table class="table DataTable table-hovered table-bordered">
                    <thead>
                        <tr>
                            <th>Kode Barang</th>
                            <th>Nama Barang</th>
                            <th>Stok</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>

                    </tbody>
                </table>
            </div>
            <div class="card-footer">
            <btn
                    class="btn btn-success btnTambahBarang"
                    data-bs-target='#modalForm'
                    data-bs-toggle='modal'
                    attr-href="{{route('barang.tambah')}}"><i class="bi bi-plus-square"></i> Tambah</btn> 

            </div>
            <!--  bagian modal -->
            <div class="modal fade" id="modalForm" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="staticBackdropLabel"></h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="close"></button>

                        </div>
                        
                        <div class="modal-body">
                            
                        
                            
                        </div>
                        
                        <div class="modal-footer">
                            <button type="button" class="btn btn-success btnSimpanBarang"><i classs=bi bi-save-fill></i>simpan</button>
                            <button type="button" class="btn btn-primary" id="btn-simpan">batal</button>
                       
                        </div>
                        
                            

                        </div>

                    </div>

                </div>
                
            </div>
        </div>
    </div>
@endsection

@section('footer')
    <script type="module">
        const modalInstance =document.querySelector('#modalForm')
        const modal = bootstrap.Modal.getOrCreateInstance(modalInstance)
        
        let table = $('.DataTable').DataTable({
            processing : true,
            serverSide : true,
            ajax : "{!!route('barang.data')!!}",
            columns : [
                {
                    name: 'kode_barang',
                    data: 'kode',
                },
                {
                    name: 'nama_barang',
                    data: 'nama_barang'
                },
                {   name :'stok',
                    render: function(data,type,row){
                        return row.stok.jumlah;
                    }
                },
                {   name :'aksi',
                    render: function(data,type,row){
                        return "<btn class='btn btn-primary btnEdit' data-bs-toggle='modal' data-bs-target='#modalForm' attr-href='{!!url('/barang/edit/"+row.id_barang+"')!!}'><i class='bi bi-pencil'></i>Edit</btn> <btn class='btn btn-danger' btnEdit ><i class='bi bi-trash'></i>Hapus</btn>";
                    }
                },
            ]

        });

        // edit callback
        $('.DataTable tbody').on('click','.btnEdit',function(event){
        
        let modalForm = document.getElementById('modalForm')
        modalForm.addEventListener('shown.bs.modal',function(event){
            event.preventDefault()
            event.stopImmediatePropagation()
            let link = event.relatedTarget.getAttribute('attr-href')
            axios.get(link).then(response => {
                $('#modalForm .modal-body').html(response.data)
                $('.modal-title').html('edit');
            });
        });
    });


        

        $('.btnTambahBarang').on('click',function(a){
        a.preventDefault();
        //changeHTML('#modalForm','modal-title','Tambah Data Barang',$data);

            var modalForm = document.getElementById('modalForm')
            modalForm.addEventListener('shown.bs.modal',function(event){
                event.preventDefault()
                event.stopImmediatePropagation()
                //const link =$('.Datatable tbody').closest('.tambahkuk.).attr('attr-href')
                var link = event.relatedTarget.getAttribute('attr-href')
                //const link= $this.attr('attr-href');
                
                var modalData = document.querySelector('#modalForm .modal-body')
                $(' .modal-title').html('tambah barang')

                

                 axios.get(link).then(response=>{
                     $('#modalForm .modal-body').html(response.data);
                
                 });
                
                
                 //  event click simpan barang
         $('.btnSimpanBarang').on('click',function(simpanEvent){
            // modal.hide();
            simpanEvent.preventDefault();
            simpanEvent.stopImmediatePropagation();
            let data = {
                'kode': $('#kodeBarang').val(),
                'nama_barang': $('#namaBarang').val(),
                'harga':$('#hargaBarang').val(),
                'token':'{{csrf_token()}}'
            };
            
            
            if(data.kode !== "" && data.nama_barang !== "" && data.harga !== ""){
                

                method:'post'
                axios.post("{{route('barang.simpan')}}",data,).then(response=>{
                    if(response.data.status == 'success'){
                        Swal.fire({
                            'title':'berhasil',
                            'text':response.data.pesan,
                            'icon':'success',
                        }).then( ()=>{
                            modal.hide()
                            table.ajax.reload()
                    })
                    }else{
                        Swal.fire({
                            'title' : 'data gagal ditambahin',
                            'text':response.data.pesan,
                            'icon':'error',
                        })
                    }
                    
                });
                
            }else{
                Swal.fire({
                    'title': 'yahaha kamu gagal',
                    'icon' :'error',
                    'text':'isi dulu semua bang gaboleh kosong',
                });
            }
         

            


         });

            
        
        });
    });
    </script>
@endsection