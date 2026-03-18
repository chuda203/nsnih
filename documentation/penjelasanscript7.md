# Penjelasan Detail Per Baris dan Komponen Script 7 (`script7.tcl`)

Script 7 merupakan skenario simulasi **Eksperimen Beban Ekstrem (Massive Burden)** melalui perluasan dari dasar pondasi kode pada Script 1. Tujuannya adalah mensimulasikan apa yang terjadi bilamana rute komunikasi jarak (*End-to-end*) dibuat menjadi teramat panjang dengan laju kepadatan trafik injeksi data yang membombardir keras (*Bottleneck/Congestion*). 

Berikut adalah elaborasi secara baris-per-baris bagian-bagian kode yang membedakan **Skrip 7** dengan Skrip dasar, beserta fungsi sintaksisnya (*command*):

## 1. Ekspansi Parameter Jumlah dan Beban Area (Topologi)
```tcl
set val(nn) 8
set god_ [create-god $val(nn)]
```
- `set val(nn) 8` : Mengganti modifikasi komponen nilai array *Number of Nodes* menjadi bernilai `8`.
- `create-god` : Berhubung jumlah batas perangkatnya sekarang dikondisikan ke level kapasitas `8` (stasiun S, D, ditambah 6 stasiun estafet Router), *Director God* NS2 akan mengurus manajemen kalkulasi radio terhadap 8 perangkat aktif virtual sekalian.

```tcl
$ns namtrace-all-wireless $namfile 1000 800
...
$topo load_flatgrid 1000 800
```
- `1000 800` : Parameter *command line* untuk fungsi rekaman animator (`namtrace-all-wireless`) dan ukuran peta denah (`load_flatgrid`) disesuaikan dimensi sumbu horizontal (*X-Axis*) ditambahkan kepanjangan kanvas batas menjadi `1000` satuan Meter. 
- **Mengapa diubah?**: Karena rentetan node 8 titik stasiun yang dibariskan pada langkah berikutnya menuntut ruas garis rentang horizontal minimal sejauh ukuran 750 meter!

## 2. Parameter Lapis Standar Kartu Jaringan Dipertahankan
Blok perintah inti `$ns node-config ...` **dibiarkan persis dan sama presisi isinya seperti Script 1**. 
Hal ini dilakukan karena sebagai simulasi *variabel terikat*, jika kita hendak membandingkan performa tabrakan antara topologi jaringan Script 7 tehadap Script 1, hal mendasar semacam standar Protokol routingnya (*AODV*), ukuran daya tamping *Buffer Antrian Interface Queue* (`ifqLen 50`) dan mekanisme antre pembuangan sampahnya (*DropTail*) diwajibkan setara.

## 3. Topologi Ber-Estafet Jauh Linear *(Multi-Hop Route)*
```tcl
set n0 [$ns node]
...
set n7 [$ns node]
```
- `set nX [$ns node]` : Skrip dipanjangkan pemanggilan konstruktor pencetakan satelit pernagkat radionya (`[$ns node]`) hingga ber-ulang secara masif memanggil dan mencetak stasiun sebanyak ke-8 titik (`n0` menuju stasiun `n7`).

```tcl
$n0 set X_ 50;  $n0 set Y_ 200; $n0 set Z_ 0.0; $n0 label "S"
$n1 set X_ 150; $n1 set Y_ 200; $n1 set Z_ 0.0; $n1 label "R1"
$n2 set X_ 250; $n2 set Y_ 200; $n2 set Z_ 0.0; $n2 label "R2"
$n3 set X_ 350; $n3 set Y_ 200; $n3 set Z_ 0.0; $n3 label "R3"
$n4 set X_ 450; $n4 set Y_ 200; $n4 set Z_ 0.0; $n4 label "R4"
$n5 set X_ 550; $n5 set Y_ 200; $n5 set Z_ 0.0; $n5 label "R5"
$n6 set X_ 650; $n6 set Y_ 200; $n6 set Z_ 0.0; $n6 label "R6"
$n7 set X_ 750; $n7 set Y_ 200; $n7 set Z_ 0.0; $n7 label "D"
```
- `set X_ 750` : Modifikasi masif koordinat penetapan sumbu absis x, disusun satu jalur horizontal mengular panjang. Perhatikan titik kordinat stasiun peluncur data paling akhir yang dibubuhkan tag stiker `$n7 label "D" (Destination)`. Berada sejauh kordinat 750.
- **Fungsi Keseluruhan Efek Perjalanan (*Propagation Multi-Hop*) & Protokol AODV**: Karena rumus pembatas sinyal `TwoRayGround` dan batasan jenis pemancar `OmniAntenna` bawaan pada file `.tr` hanya dapat mentransfer daya sekitar sekilas pandang radius 250 meter dalam NS, stasiun ujung diujung (*S*) tidak akan pernah punya rute sambungan sinyal langsung ke hilir pangkal (*D*). Kode ini memaksa modul kecerdasan otak algoritma perute-an (*routing*) AODV akan merintis jembatan rute perlekatan loncat *forward*, paket dipantul-pantulkan melewati jembatan hidup: stasiun `n0 -> n1 -> n2 -> n3 -> n4 -> n5 -> n6 -> n7` untuk sampai dengan utuh! Estafet panjang antrean pemroses inilah yang mendorong besarnya delay perlambatan performa dan percampuran tumbukan antrean gelombang yang rumit.

## 4. Intensitas Agen Generator Brutal Ekstrem (Perubahan Beban / Packet Injection Limit)
```tcl
set null0 [new Agent/Null]
$ns attach-agent $n7 $null0
```
- `$ns attach-agent $n7` : Sasaran penangkapan terminal stasiun titik-Buta sink akhir (`Null`) yang pada Script 1 hanya di terminal stasiun `n3`, sekarang digeser menempel di stasiun paling pojok akhir `n7`.

```tcl
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 512
$cbr0 set interval_ 0.01
```
- `set interval_ 0.01` : **Ini adalah perintah inti paling penting dari Skrip ini (*The Experimental Main Load Factor*)**. Method `interval_` pada modul Generator Pompa Lalu Lintas (`CBR`) dipertipis jeda tembaknya ke limit ekstrim kecepatan konstan padat `0.01` detik.
- **Dampak Sintaks ini secara teknis**: Angka `0.01` bermakna simulator diinstruksikan supaya stasiun pengirim (`udp0` dalam sumbu `n0`) memproduksi beban muntahan tembakan siklus lalu lintas konstan sebanyak pecahan *(1 detik dibagi 0.01)* **= 100 paket tembakan brutal murni per detiknya konstan!** (Berkecepatan 5 X lipat lebih padat dari aliran tenang air di Script 1). 

**KESIMPULAN EKSPLOSIF TERHADAP BEBAN *(Queue Bottleneck Simulation)*:** \
Dampak di setelnya `interval_ 0.01` ini berbenturan pada instruksi *MAC* dan param config:  kapasitas cadangan tampung antrian radio interface *(IfQueue)* disetiap Router node perantara di NS2 dipatok mentok batasan sempit yaitu `-ifqLen 50`. \
Ketika selang arus stasiun awalan mengebor memaksakan muntahan kencang volume 100 potong paket data yang berombongan merayap maju menjejali Router, maka ruang memori penampungan tabung di Router *peralihan* akan amat dangkal dan meluap (*Buffer Overflow*). \
Paket paket keping data data yang diposisikan ngantre dibelakang saat meluap akan otomatis seketika *di-Drop (Tendang/Buang/Hapus)* dari memori seiring instruksi pengatur antrean *DropTail Protocol*. Hasil dari modding rentetan dua baris tersebut me-roketkan perolehan *Output* parameter tingginya performa kegagalan kecacatan **Packet Loss Rasio** pada Trace file dan menyebabkan fluktuasi *Delay* interval penerimaan yang kocar-kacir membengkak *(High Jittering).*
