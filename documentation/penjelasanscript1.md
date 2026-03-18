# Penjelasan Detail Per Baris dan Komponen Script 1 (`script1.tcl`)

Script 1 merupakan simulasi jaringan nirkabel *Ad-hoc* (Mobile Ad-Hoc Network/MANET) menggunakan Network Simulator 2 (NS2). Pada skenario ini, kita menyimulasikan komunikasi antara 4 titik (node) yang tersusun lurus berurutan. Berikut adalah penjelasan sangat mendetail untuk **setiap baris kode beserta bagian-bagian perintahnya (command)**:

## 1. Inisialisasi Simulator
```tcl
set ns [new Simulator]
```
- `set` : Perintah bawaan TCL untuk membuat atau menyimpan nilai ke dalam variabel.
- `ns` : Nama variabel yang menyimpan memori referensi objek simulasi.
- `[ ... ]` : Tanda kurung siku di TCL berfungsi untuk mengeksekusi (evaluate) perintah yang ada di dalamnya terlebih dahulu.
- `new Simulator` : Memanggil *constructor* dari *class* dasar `Simulator` pada inti C++ NS2.
- **Fungsi Keseluruhan:** Membuat *instance* objek utama. Variabel `ns` ini akan menjadi "Tuhan" di script kita yang menaungi seluruh peristiwa jaringan ke depannya.

## 2. Pembuatan File Log (Trace & NAM)
```tcl
set tracefile [open logs/s1.tr w]
$ns trace-all $tracefile
```
- `set tracefile` : Membuat variabel bernama `tracefile`.
- `[open logs/s1.tr w]` : Perintah TCL membuka (`open`) file `s1.tr` di dalam direktori `logs` dalam mode *write* (`w`). Jika file tidak ada, file tersebut dibuat.
- `$ns` : Mengambil nilai dari variabel `ns` (memanggil fungsi dari objek simulator).
- `trace-all` : Metode (fungsi) dari `Simulator` untuk memulai perekaman seluruh aktivitas yang terjadi di jaringan.
- `$tracefile` : Merujuk pada file keluaran di mana jejak (trace) aktivitas dicatat.
- **Fungsi Keseluruhan:** Menginstruksikan NS2 untuk merekam setiap aktivitas jaringan (seperti waktu paket terkirim `s`, diterima `r`, jatuh `d`, dsb.) agar kita bisa menghitung *Throughput*, *Delay*, dsb.

```tcl
set namfile [open visuals/s1.nam w]
$ns namtrace-all-wireless $namfile 800 800
```
- `set namfile` : Membuat variabel `namfile`.
- `[open visuals/s1.nam w]` : Membuka file `s1.nam` dalam folder `visuals` untuk mode penulisan.
- `$ns namtrace-all-wireless` : Command spesifik nirkabel untuk mencatat format pergerakan dan posisi *node* (X,Y) agar terbaca di program *Network Animator* (NAM) versi *Wireless*.
- `800 800` : Parameter ukuran luas topologi/kanvas jaringan (800x800 meter).
- **Fungsi Keseluruhan:** NS2 diinstruksikan untuk menghasilkan file catatan khusus untuk pergerakan grafis yang dapat diputar secara visual di *software* NAM.

## 3. Parameter Saluran dan Topologi
```tcl
set chan [new Channel/WirelessChannel]
```
- `new Channel/WirelessChannel` : Kelas objek transmisi. NS2 menyediakan jenis *WirelessChannel* untuk mengatur sifat perambatan medium tak hampa dan tak berwujud seperti sinyal radio udara terbuka.
- **Fungsi Keseluruhan:** Mendefinisikan medium gelombang udara untuk menyalurkan *traffic*.

```tcl
set val(nn) 4
set god_ [create-god $val(nn)]
```
- `set val(nn) 4` : Variabel bentuk *array* di mana elemen *key* `nn` (number of nodes) diberikan nilai angka `4`.
- `create-god` : Membuat objek sentral G.O.D. (*General Operations Director*).
- `$val(nn)` : Mem-*passing* angka `4` kepada GOD.
- **Fungsi Keseluruhan:** GOD dalam simulasi nirkabel sangat vital. Ia bertugas memegang posisi absolut seluruh node sehingga bisa menjadi kalkulator apakah sinyal radio masih jangkau atau terputus antar satelit node yang bergeser tersebut.

```tcl
set topo [new Topography]
$topo load_flatgrid 800 800
```
- `new Topography` : Membuat *class* pengontrol elevasi dan kontur peta simulasi.
- `$topo load_flatgrid` : Memanggil fungsi agar objek topologi membentuk lahan rata tanpa berbukit (flat-grid) 2 Dimensi.
- `800 800` : Batasan panjang X dan Y = 800m x 800m.

## 4. Konfigurasi Standar Protokol (Node Config)
```tcl
$ns node-config \
 -adhocRouting AODV \
 -llType LL \
 -macType Mac/802_11 \
 -ifqType Queue/DropTail/PriQueue \
 -ifqLen 50 \
 -antType Antenna/OmniAntenna \
 -propType Propagation/TwoRayGround \
 -phyType Phy/WirelessPhy \
 -channel $chan \
 -topoInstance $topo \
 -agentTrace ON \
 -routerTrace ON \
 -macTrace ON \
 -namtrace ON
```
- `node-config` : Modul yang me-reset/menimpa sifat default radio menjadi standar *Adhoc Wireless* untuk node yang di-_generate_ setelah baris ini.
- `-adhocRouting AODV` : Menunjuk standar algoritma *routing protocol* AODV (Ad-hoc On-demand Distance Vector). Ini otak cerdas pencari jalan rute *hop*.
- `-llType LL` : Modus lapisan *Logical Link Control*, standar OSI layer Data Link. 
- `-macType Mac/802_11` : Konfigurasi lapis MAC yakni CSMA/CA WiFi biasa (IEEE 802.11).
- `-ifqType Queue/DropTail/PriQueue` : Mekanisme memori penampungan sementara (*Buffer*). Metode antre membuang paket terbelakang ketika penampungan meluap (*DropTail*).
- `-ifqLen 50` : Besaran maksimal sel antrean per *node* adalah 50 batas unit paket.
- `-antType Antenna/OmniAntenna` : Jenis antena pemancar omni-direksional yang radius lingkar sinyalnya memancar 360 derajat ke segala arah secara datar.
- `-propType Propagation/TwoRayGround` : Rumus pelemahan sinyal matematis redaman pantulan sinar (*Two-Ray Ground*). Memperhitungkan efek pantul pantulan bumi/sinyal tanah.
- `-phyType Phy/WirelessPhy` : Konfigurasi transiver sinyal lapisan Fisik radio nirkabel biasa.
- `-channel $chan` : Menancapkan variabel channel medium udara yang tadi sudah kita buat di atas.
- `-topoInstance $topo` : Menyatukan sistem radio tersebut ke dalam topologi grid.
- `-*Trace ON` : Menghidupkan mode pelaporan log dari tiap lapisan OSInya (*routing*, `MAC`, perangkat agen pengirim, dan animasinya).

## 5. Pewarnaan Animasi NAM
```tcl
$ns color 1 Blue
$ns color 2 Red
$ns color 3 Green
$ns color 4 Yellow
```
- `color 1 Blue` : Menginstruksikan NS2, bahwa apabila nanti ada kemasan *flow paket/traffic* yang diberikan penanda ID **`1`**, berikan warna efek grafis **Blue (Biru)** pada aplikasi NAM. Sisanya digunakan jika ada multi-*flow*.

## 6. Pembuatan dan Peletakan Node
```tcl
set n0 [$ns node]
```
- `$ns node` : Metode utama mencetak/memproduksi satelit satu unit radio. Menggunakan basis aturan yang telah di set dalam `node-config`. Kita simpan unit pertama ini sebagai _variable_ `n0`. *(Diulang sebanyak 4 kali berdasar script asli n0 sampai n3)*.

```tcl
$n0 set X_ 50; $n0 set Y_ 200; $n0 set Z_ 0.0; $n0 label "SRC"
$n1 set X_ 150; $n1 set Y_ 200; $n1 set Z_ 0.0; $n1 label "R1"
```
- `$n0 set X_ 50` : Memasukkan atribut letak koordinat sumbu melintang (**X**) pada 50 meter.
- `set Z_ 0.0` : Ketinggian vertikal udara/z selalu `0` meter karena *TwoRayGround* mensyaratkan perangkat menapak tanah di NS2.
- `$n0 label "SRC"` : Command penyematan teks stiker *"SRC"* (Source/Sumber) mengambang tepat di bawah ikon buletan Node pada pemutar grafis NAM. *R1 (Router 1) dst.*
- **Jarak Relatif:** Semua sejajar lurus mendatar karena Y-nya konstan `200`. Dan sumbu X bergeser kelipatan 100 Meter.

```tcl
foreach n {n0 n1 n2 n3} {
    $ns initial_node_pos [set $n] 30
}
```
- `foreach n { ... }` : Fitur *Looping* TCL. Mengeksekusi variabel blok skrip sebanyak iterasi himpunan kurung kurawal.
- `initial_node_pos ... 30` : Memberikan arahan rendering ukuran fisik lingkaran geometri *node* itu selebar 30 piksel diameter.

## 7. Transport Layer & Payload Pembangkit Traffic
```tcl
set udp0 [new Agent/UDP]
$udp0 set fid_ 1
$ns attach-agent $n0 $udp0
```
- `new Agent/UDP` : Node masih menjadi raga "kaku" dan belum bisa menembak transfer file. Kita perlu bikin *Aplikasi Lapis Transport UDP* dan disimpan di objek `udp0`.
- `$udp0 set fid_ 1` : *Flow ID = 1*. (Kode paket yang keluar dari jalur transmisi ini akan ditempeli cap warna Biru dari atas).
- `attach-agent` : Modul "Pemasang Aplikasi" ke dalam *Device*. UDP ini ditancapkan murni ke pangkuan stasiun awalan node sumber `n0`.

```tcl
set null0 [new Agent/Null]
$ns attach-agent $n3 $null0
```
- `Agent/Null` : Karakteristik *Connectionless* dari UDP butuh muara yang tidak pedulian. *Null Sink* adalah stasiun penampungan tanpa konfirmasi balas (lubang hitam penangkap).
- Agen ini difikirkan untuk node stasiun ujung ketibaan, yakni stasiun _Destination_ `n3`.

```tcl
$ns connect $udp0 $null0
```
- `connect` : Sistem NS2 akan menarik benang senar sambungan maya (virtual port linkage) antara pangkal agen `udp0` di `n0` dan merajutnya ke tangkapan `null0` si tujuan `n3`.

```tcl
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 512
$cbr0 set interval_ 0.05
$cbr0 attach-agent $udp0
```
- `Application/Traffic/CBR` : Membangkitkan "Payload" (Isi Barang Kemasan Data). *CBR* = *Constant Bit Rate* = aliran generator keran data statis yang menderas tiada henti mengucur.
- `packetSize_ 512` : Mematok setiap biji pecahan pengiriman datanya dipotong-potong selebar 512 *Bytes*.
- `interval_ 0.05` : Timer jeda injeksi. 1 per 0.05 = Jadi 20 paket setiap detik akan di pompa paksa membludak masuk ke sambungan UDP.
- `attach-agent $udp0` : Keran pompa di atas dilas erat ke sistem antarmuka mesin `udp0`.

```tcl
$ns at 1.0 "$cbr0 start"
$ns at 9.0 "$cbr0 stop"
```
- `$ns at [waktu]` : Ini adalah metode *Scheduler* waktu, jam tangan internal.
- `at 1.0 "$cbr0 start"` : Memerintahkan sistem: "Pada saat tepat jarum jam hitungan virtual menunjukan detik KE-1.0 , tolong jalankan saklar nyala metode `start` yang dimiliki mesin pamompa `cbr0`."
- `at 9.0 ... stop` : Dan saat di detik simulasi ke 9, potong mati total suplainya.

## 8. Presedur Terminasi
```tcl
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam visuals/s1.nam &
    exit 0
}
```
- `proc finish {} { ... }` : Kata kunci pendeklarasian suatu sub-program *Function/Method* prosedur yang diberi nama kustom `finish`.
- `global` : Menarik pemanggilan variabel diluar scope prosedur ke dalam blok kurung agar bisa di modifikiasi dari dalam.
- `flush-trace` : Menyapu dan membilas bersih isi tampungan memori OS sementara supaya ditumpahkan kering ke disik file Hardisk (Memaksa agar .tr file kelar tertulis tak ada yang tertunda/corrupt).
- `close` : Fungsi penutupan sesi izin akses perizinan File pada Sistem Operasi.
- `exec nam visuals/s1.nam &` : Memancing sistem shell OS (Linux System Call) untuk mengetik *command `nam`*. Tanda `&` merujuk supaya jalankan _nam app_ di *Background Process* sistem operasi.
- `exit 0` : Keluar dari terminal tcl simulasi dengan sinyal aman (0).

```tcl
$ns at 10.0 "finish"
```
- NS2 *Scheduler* lagi. Memerintahkan NS untuk *"Panggil fungsi mati `finish` pada jam 10.0 !!"* *(Ingat, jeda 1 detik sejak pompa mati di detik 9, sengaja dibiarkan untuk membiarkan paket yang terakhir memancar agar sempat sampai tujuan di antre udara)*.

```tcl
$ns run
```
- `run` : Semua aturan deklarasi, persiapan properti dan peng-jadwalan tatanan diatas sudah di inisialisasi tuntas. Fungsi `run` ini bagaikan me-menyet menekan tombol "PLAY" pada sebuah kaset. Menyalakan simulasi untuk mulai berjalan nyata berdasarkan semua skenario *Events* yang sudah terjadwal rapi tadi.

## 9. Alur Bagaimana Jaringannya Berjalan (*Flow* Simulasi)
Secara keseluruhan, urutan atau tata cara kerja jaringan dari **Script 1** bisa diringkas menjadi alur berikut:
1. **Mulai:** Aplikasi pencipta paket lalu lintas data (CBR) yang melekat pada stasiun sumber (Node `n0` - *SRC*) mulai memompa muatan data berukuran 512 bytes setiap jeda 0.05 detik dimulai tepat pada detik simulasi ke-1.0. 
2. **Pengemasan (Transport UDP):** Muatan data CBR tersebut diserahkan ke agen UDP pada perangkat Node `n0`. UDP bertugas membungkus data menjadi paket-paket ringkas tanpa ada pengecekan garansi ketibaan pengiriman.
3. **Pencarian Jalan Estafet (Routing AODV):** Sebelum ditembakkan ke udara, protokol *routing* AODV "berpikir" mencari rute terbaik dari ujung `n0` menuju target `n3`. Dikarenakan jarak ujung ke ujungnya sepanjang 300 meter dimana itu melampaui kemampuan pancar optimal antena (sekitar 250 meter), Node `n0` akan mencari bantuan menggunakan perangkat tetangganya (`n1` atau `n2`) untuk dijadikan *Router* pantulan estafet transmisi.
4. **Perambatan Medium Udara:** Pancaran sinyal dilontarkan melalui media Topologi 2 Dimensi.
5. **Melompat dan Meneruskan (*Hop Relaying*):** Paket data melompat dari `n0`, mendarat dan ditangkap oleh router estafet `n1`/`n2`, lalu dilempar diteruskan berantai menyambung udara sampai mendarat di pangkalan akhir `n3`.
6. **Titik Penerimaan:** Di titik `n3`, agen penangkap `Null` menerima limpahan kedatangan paket-paket gelombang sebagai "lubang hitam", yakni disetor, diterima, tanpa dibalasi konfirmasi.
7. **Akhir Simulasi:** Menginjak detik hitungan ke-9.0, keran pompa semprotan CBR dari pusat dimatikan. Memberi jeda 1 detik agar sisa antrean gelombang sisa merambat sampai di tujuan. Lalu di detik 10.0 tombol mati *finish* ditekan membungkus seluruh catatan rekam jejaknya ke memori.

## 10. Contoh Penerapan dalam Kehidupan Nyata
Skenario Script 1 ini pada hakikatnya sedang mensimulasikan topologi lingkungan komunikasi peranti nirkabel berjarak relatif dekat - menengah yang saling melempar paket pertukaran secara stabil, ringan, beralur konstan tanpa sumbatan jenuh. 

**Contoh nyata aplikasinya di lapangan:**
- **Sistem Radio Komunikasi Internal (Walkie-Talkie/HT) Konvoi:** Anggap Node itu adalah beberapa armada mobil Patroli Keamanan yang berbaris memanjang konvoi dan memakai Handy-Talkie radio. Staf kendaraan terdepan (*Source*) memberi pelaporan audio langsung (*streaming konstan CBR tanpa peduli hilang/UDP*) ke pimpinan di mobil barisan buncit (*Destination*). Karena mobilnya baris panjang menjauh, sinyal suara dari mobil terdepan direlai dan dipancarkan ulang estafet secara otomatis oleh radio HT di mobil-mobil tengah (*Router 1 & 2*). Karena jalurnya lapang dan obrolannya standar, lintasannya mulus tak ada hambatan kemacetan.
- **Sensor Internet of Things (IoT) Barisan Pertanian:** Sederet pilar stasiun sensor alat pembaca suhu kelembapan cuaca mini yang diletakan menyebar tiap 100 meter memanjang di areal kebun pertanian (*Adhoc/Tanpa kabel*). Sensor pangkal mengirimkan *update* berkala data cuaca secara rutinan (konstan) yang memantul di tiang sensor lain agar laporannya bisa masuk tiba ke pangkalan pusat gubuk server ujung pengumpul. Jaringannya bersifat ringan, awet, dan laju paket teratur santai.
