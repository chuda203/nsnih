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

## 5. Alur Bagaimana Jaringannya Berjalan (*Flow* Simulasi)
Secara keseluruhan, urutan kronologis penderitaan berjalannya jaringan eksperimen ekstrem pada **Script 7** dapat dijelaskan sebagai berikut:
1. **Titik Mula Peledakan:** Aplikasi CBR di Stasiun utama Pengirim (Node `n0` / *S*) dihidupkan untuk **membombardir** agen transportasi UDP miliknya dengan tembakan paket data secara sangat beringas, memproduksi *traffic* selevel 100 bongkahan data per detik!
2. **Perintisan Jembatan Sangat Panjang (Routing AODV):** Otak cerdas perute-an *(AODV Routing Protocol)* terpaksa harus bersusah payah merakit jalur jembatan estafet gelombang sinyal nirkabel sangat jauh melewatin rantai lempengan 6 stasiun perantara aktif berjejer merentang (mulai stasiun R1 hingga R6) karena jarak destinasi targetnya (`n7` / *D*) memelar membentang diujung sejauh 700 meteran.
3. **Penyumbatan Jalur / Kemacetan Fatal (*Bottleneck Threshold*):** Rombongan aliran data berjumlah ekstrem masif dari hulu `n0` dipaksakan memasuki lorong titik Router estafet terdepan (contohnya `n1` dan `n2`). Masalah timbul karena kapasitas mangkuk "Antrean Tunggu" *(Queue)* tiap Router tersebut sangat sempit / kecil (hanya berukuran `-ifqLen 50` porsi paket). Permintaan yang membludak berbenturan dengan celah jalan yang sempit; Kemacetan Total lalu lintas pun tak terhindarkan dan antrean tumpah meluap ke luar *(Buffer Overflow)*.
4. **Terbuang dan Hancur (*Massive Packet Drop*):** Disinilah mesin aturan keselamatan antrean jalan *DropTail* menunjukan kejamnya; ketika ada paket gelombang sinyal yang telat tiba posisinya di ekor antrean di tiang Router sementara memorinya sudah *Overload* kepenuhan kapasitas, paket malang tersebut tidak akan dibukakan jalan masuk kompromi melainkan otomatis langsung **Dibuang / Ditendang hancur berjatuhan** (*Packet Loss* besar-besaran).
5. **Keterlambatan dan Gejolak Kocar-Kacir:** Paket-paket gelombang beruntung kasta awal yang lolos berhasil masuk menyelinap berjalan tertatih menapaki satu per satu Router sisanya dipastikan harus tersengal mengalami ganjalan waktu antre penundaan yang teramat lambat dan penyendatan (*Delay* melonjak tinggi) sebelum menembak lagi dan ditangkap ke titik *Null* penerima di `n7` dengan irama waktu jeda tibanya yang sangat kacau balau tidak teratur *(Jitter Parah/Fluktuatif ekstrem)*. 

## 6. Contoh Penerapan dalam Kehidupan Nyata
Skenario Script 7 ini merupakan gambaran simulatif potret kehancuran kualitas pada kondisi **"Kemacetan Padat Ekstrim" (*Congestion/Overloaded Network Topology*)** karena serbuan skala muatan kapasitas laju pengiriman jauh melampaui kemampuan daya serap infrastrukturnya pada jangkauan jarak yang panjang bermulti-hop.

**Contoh nyata aplikasinya pada kejadian di sekeliling kehidupan:**
- **Jebloknya Sinyal Seluler / Koneksi di Acara Konser Akbar atau di Tribun Stadion:** Bayangkan puluhan hingga ratusribuan massa membludak padat di ruang terbatas secara bersamaan berusaha melakukan tindakan *Live Streaming* / Meng-unggah *Video* terus-menerus ke Instagram / WhatsApp (*Mirip skema Bombardir Data Konstan/CBR Interval sangat Mepet*). Ribuan aliran tebal menukik secara gerombolan menyerbu BTS atau *Access Point* seluler nirkabel disekitarnya yang notabene memori batas proses antreannya dirancang sempit *(Capacity / ifQ len tipis)*.
  *Hasilnya meniru simulasi ini:* Memori pemroses di tower BTS kewalahan, tumpah, sehingga video *Live* anda di tribun patah-patah parah *(High Delay)*, layar HP *buffering/loading* putaran bengong tiada henti, resolusi gambar turun jadi pecah pixel berkatikal, dan terkadang centang jam *icon* pesan yang dikirim gagal lalu silang ter-Drop/ditendang koneksinya mati hilang sinyal *(Packet Loss Tinggi)*.
- **Simulasi Benturan Banjir *DDoS Attack* tipe *UDP Flood*:** Ini ibarat model tiruan bagaimana jika *Hacker/Attacker* (dimainkan stasiun `n0`) memborbardir menembak ribuan gelombang sampah muatan UDP secara konstan beruntun untuk membanjiri celah target *Router* server korban. Efeknya, memori pipa jalur *interface* server mampet kewalahan tercekik dan mematikan layanan antrean (membuang/drop koneksi asli).
