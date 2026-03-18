# Ringkasan Skenario Simulasi NS2 (Script 1 - 20)
Dokumentasi ini merangkum 20 variasi skenario simulasi jaringan (*Mobile Ad-Hoc Network*) yang di-*generate* secara massal melalui *Python script builder*.

## A. Penjabaran Detail dari 20 Skenario Script
Berdasarkan parameter rancangan konfigurasi, berikut adalah penjabaran yang lebih mendalam mengenai detail teknis dan efek performa dari setiap skenario:

1. **Script 1 - Kondisi Sangat Bagus (Trafik Ringan Ideal)**
   - **Parameter**: 4 Node, Panjang antrean (`ifq_len`) = 50, Ukuran paket = 512 bytes, Interval = 0.05s (20 paket/detik).
   - **Efek/Karakteristik**: Jaringan berjalan di bawah kapasitas maksimal. Router memiliki waktu yang sangat cukup untuk memproses dan meneruskan paket tanpa penumpukan. Hasil simulasi akan menunjukan **Packet Loss = 0%**, **Jitter hampir 0**, **Delay sangat rendah**, dan **Throughput maksimal** sesuai laju transfer.

2. **Script 2 - Throughput Bagus, Delay Sedang (Mulai Padat)**
   - **Parameter**: 4 Node, `ifq_len` = 50, Ukuran paket = 1024 bytes, Interval = 0.01s (100 paket/detik).
   - **Efek/Karakteristik**: Volume dan frekuensi injeksi data dinaikkan drastis (5x lebih cepat dari Script 1 dan paket 2x lebih besar). Hal ini menyebabkan barisan data mulai mengantre di Router (MAC terbebani). Hasilnya, **Throughput** membengkak besar (sukses terkirim banyak), namun terjadi kemacetan kecil yang menyebabkan **Delay bertambah (Sedang)**.

3. **Script 3 - Penyempitan Antrean Ekstrem (Packet Loss Buruk)**
   - **Parameter**: 4 Node, `ifq_len` = 5 (Sangat kecil), Interval tembakan = 0.005s (200 paket/detik).
   - **Efek/Karakteristik**: Mensimulasikan Router berkapasitas sangat sempit. Temabakan "brutal" langsung memenuhi 5 slot memori antrean dalam sekejap. Sisanya yang baru datang secara otomatis langsung dibuang/di-*drop*. **Delay menjadi sangat bagus** (karena tidak ada yang ngantre lama, lolos ya lolos), tapi **Packet Loss memburuk ke tingkat ekstrem**.

4. **Script 4 - Penampungan Raksasa (Delay Sangat Buruk)**
   - **Parameter**: 4 Node, `ifq_len` = 200 (Sangat besar), Interval tembakan = 0.002s (500 paket/detik).
   - **Efek/Karakteristik**: Kebalikan dari script 3. Memori router mampu menyelamatkan seluruh paket ekstrem yang dilontarkan pengirim sehingga tidak ada yang dibuang (**Packet Loss Bagus**). Namun karena antreannya raksasa hingga ratusan baris, paket di urutan belakang akan diproses sangat lama. Menghasilkan fenomena **Delay waktu kedatangan yang sangat usang/buruk**.

5. **Script 5 - Mobilitas & Patahnya Koneksi (*Link Break*)**
   - **Parameter**: `ifq_len` = 50, Interval = 0.05s, Terdapat fitur pergerakan *Waypoint* (`mobility`).
   - **Efek/Karakteristik**: Stasiun perantara (Router 1) tiba-tiba diprogram mensimulasikan gerak berjalan menjauhi pangkalan stasiun pengirim kecepatan tertentu hingga melampaui radus transmisi. Jalur putus di tangah jalan (Link Break). Menyebabkan performa anjlok drastis (Throughput terputus, Loss melonjak hebat saat putus). 

6. **Script 6 - Tabrakan Silang (*Cross Traffic* / Jitter Buruk)**
   - **Parameter**: 5 Node (2 Pengirim: S1 & S2, 1 Penerima di ujung).
   - **Efek/Karakteristik**: Terdapat adu rebutan jalan *traffic* CBR. Sumber 1 dan Sumber 2 menembak bersama-sama masuk ke satu antrean stasiun *Router R1*. Perebutan giliran proses ini merusak irama stabil kedatangan paket. Menghasilkan **Jitter amat fluktuatif (Sangat Buruk)**.

7. **Script 7 - Jembatan Multi-hop Jauh / Kenaikan Delay Normal**
   - **Parameter**: 8 Node estafet berjejer rentang jarak total sejauh 1 kilometer (1000 meter).
   - **Efek/Karakteristik**: Paket dipaksa merakit lompatan berangkai estafet hop-demi-hop melewati 6 *Router*. Setiap Router memerlukan waktu proses untuk menyerap sinyal lalu memancarkannya kembali. Rentetan proses singgah ini memicu kalkulasi akumulasi keterlambatan murni. **Delay rata-rata (*Average E2E Delay*) akan Sedang ke Buruk**.

8. **Script 8 - Resiko Jarak Pinggir Tepian (*Fringe Range*)**
   - **Parameter**: Stasiun terpisahkan dalam lompatan jarak sangat jauh (*230 meter antar Node*).
   - **Efek/Karakteristik**: Mendekati batas limit penangkapan pudar alat radio TwoRayGround NS2 (limit ~250m). Tingkat kesuksesan konfirmasi dan hantaran data gelombang antar udara menjadi sangat rawan tidak terdengar penuh, menghasilkan kualitas **Packet Loss Sedang**. 

9. **Script 9 - Relaksasi/Trafik Santai (Kondisi Sangat Sempurna)**
   - **Parameter**: Ukuran hanya 256 bytes, Interval sangat lambat (0.5s = 2 Paket/Detik).
   - **Efek/Karakteristik**: Jaringan nyaris kosong melompong. Parameter Loss, Jitter, dan Delay semua berada dalam angka grafis **titik ternyaman (Paling Bagus)**. Jaringan beroperasi seperti layaknya jalan tol sepi kendaraan.

10. **Script 10 - Beban Muatan Raksasa (*Heavy Payload Cycle*)**
    - **Parameter**: Paket 1500 bytes (Mendekati ukuran MTU batas pecah keping frame Ethernet), Interval rapat 0.005s.
    - **Efek/Karakteristik**: Beban cerna algoritma di Router sangat tertekan. Mengoyak/mentransmisikan bongkahan besar ukuran 1500 bytes memakan durasi yang menguasai jatah waktu antrean (*Interface transmission delay* memanjang). Menghasilkan **Delay yang Sedang menuju Buruk**.

11. **Script 11 - Kekacauan Udara Murni (*High Air Collision*)**
    - **Parameter**: 6 Node membetuk 3 Pasang jaringan Komunikasi Independen.
    - **Efek/Karakteristik**: Menguji tumpang-tindih batas frekuensi. Walau tidak saling intervensi router (S1 meroute ke D1, S2->D2, S3->D3), gelombang radio udara mereka saling tabrak interferensi. Menimbulkan hilangnya keping gelombang sebelum menempel antena penerima. Terjadi **Kenaikan Loss Sedang dan Jitter memburuk**.

12. **Script 12 - Simpang Kritis (*Mesh Cross Intersections*)**
    - **Parameter**: Node berbaris silang sumbu X dan Y. Perpotongannya dikendalikan oleh **1 Router Tunggal Pangkalan Menyilang (R1)**.
    - **Efek/Karakteristik**: Router tangah ini ibarat perempatan lampu merah. Jalur data utara-selatan dan timur-barat bertarung di R1. Mengakibatkan ketidakstabilan rute (Routing AODV bingung mengurus dua antrean independen). **Delay dan Jitter menjadi menengah/Sedang**.

13. **Script 13 - Putus-Nyambung (*Temporary Link Break*)**
    - **Parameter**: Terdapat program _Mobility_ dimana Node berjalan keluar jangkauan sinyal sebentar, lalu berjalan mendekat kembali ke titik awal.
    - **Efek/Karakteristik**: Mensimulasikan diskoneksi sesaat lalu reconect. Grafik *throughput* akan berhenti menghasilkan 0 di tengah waktu simulasi, lalu naik lagi menjelang akhir tempoh. **Fluktuasi Jitter akan sangat tinggi (Buruk)**.

14. **Script 14 - Serbuan Dadakan (*Sudden Traffic Burst*)**
    - **Parameter**: Laju tenang dari 1.0 hingga 9.0. Tapi ada sisipan serangan paket 1024 bytes super rapat (0.001) ditengah simulasi (Detik 4.0 hingga 5.0).
    - **Efek/Karakteristik**: Terjadi ledakan mendadak (*Spike*) tajam di pertengahan waktu. Di menit awal bebas meluncur, di detik 4 antrean tiba-tiba lumpuh macet parah (serbuan DDos/Flash sale). Saat detik 5 lewat, sisa paket yang telat (*Delay*) akan berusaha perlahan surut untuk diteruuskan ulang.

15. **Script 15 - Penyumbatan Total (*Extreme Bottleneck Congestion*)**
    - **Parameter**: Antrean antariksa `ifq_len` = 500, Interval tembakan 0.001 (1000 Paket/detik!), ukuran paket max 1500 bytes.
    - **Efek/Karakteristik**: Gabungan *Stress-Test* terberat bagi mesin NS2. Router seperti dibanjiri selang air pemadam kebakaran bertekanan gigantik tapi hanya disalurkan pipa pembuang sekecil sedotan. Jauh di atas ambang batas wajar. **Keterlambatan usang (Delay) hancur berantakan sangat buruk**.

16. **Script 16 - Penyumbatan Ringan-Merata (*Moderate Congestion*)**
    - **Parameter**: Antrean antariksa dibuat pendek (`ifq_len` 10), ukuran tanggung 1024 bytes, jeda sedang santai (0.005s).
    - **Efek/Karakteristik**: Kemacetannya bisa diatasi oleh peladen dengan memangkas *(Drop)* paket urutan buntut secara berkala sedikit-sedikit. Arus antrean lancar karena tak ada masa tunggu yang lama (Delay Bagus), hanya nilai kecacatan utuhnya meningkat (**Loss Sedang**).

17. **Script 17 - Leher Botol di Sasaran Akhir (*Destination Bottleneck*)**
    - **Parameter**: 2 sumber penembak dan dua jalur *Router* berbeda yang melaju kerucut mengerucut masuk ke terminal Node Tujuan (D) secara bersamaan.
    - **Efek/Karakteristik**: Penerima (Node D) kewalahan menyortir data silangan (*Multiplexing* trafik dua aliran masuk). Aliran kedatangan tumpang tindih menjadikan spasi ketibaan menjadi kacau tak menentu (**Fluktuasi Jitter Buruk**).

18. **Script 18 - Rotasi Jarak Melingkar (*Circular Mobility*)**
    - **Parameter**: Node pemancar bergerak bagai satelit melingkari router (radius maju-mundur dari target) sepanjang waktu simulasi.
    - **Efek/Karakteristik**: Kekuatan transmisi radionya melemah-kuat seiring jarak. Kalkulasi propogasi radio membuat paket kadang butuh waktu lebih (karena terpantul memudar) disaat titik jauh, dan seketika langsung tabrak merapat ke server saat titik jarak paling dekat. (*Jitter/variasinya menjadi tak menentu*).

19. **Script 19 - Tabrakan Arus Muka Ganda (*Reverse Traffic / Full Duplex Collision*)**
    - **Parameter**: N0 menembakkan air keras CBR menuju N4. Bersamaan dengan itu, Node sasaran N4 diatur membombardir berlawanan arah menembakkan CBR secara keras ke N0!.
    - **Efek/Karakteristik**: Seperti rel kereta api satu arah dilalui berlawanan. Terjadi pertarungan parah benturan antar pengirim yang berusaha mencaplok/merampok kanal rute jalan sebaliknya. Tabrakan murni dan penolakan ini menyebabkan laju tertahan mundur memicu **Delay dan Jitter yang Hancur Luluh Lantak (Buruk)**.

20. **Script 20 - Skrip Kekacauan Campur Aduk (*The Pure Chaos*)**
    - **Parameter**: Digabung semuanya: Arus lalu lintas silang, sebagian titik bergerak dengan kecepatan ngaco, Interval sangat Brutal (0.005s) paket raksasa, *Queue* nanggung (30), dan Node 6 buah.
    - **Efek/Karakteristik**: Skenario terburuk di mana seluruh malapetaka stabilitas jaringan bersatu padu mensimulasikan kegagalan ekstrem di seluruh titik uji parameter matrik *Quality of Service*. **Nilai Loss, Troughput yang gagal, Delay, dan Jitter sangatlah buruk/rendah**.

---

## B. Penjelasan tentang `configs.append`
Pada bahasa pemrograman tingkat tinggi (Python), kode `configs = []` menyiapkan suatu lemari memori (tipe list/array kosong).

Perintah **`configs.append({ ... })`** digunakan berulang-ulang dari skenario 1 s/d 20. Fungsinya ibarat membuka "Laci Baru" di blok ingatan list untuk menyisipkan sekumpulan parameter (*dictionary*) unik milik skenario tersebut. Di dalam data yg di *append* ("ditambahkan") inilah dideklarasikan cetak biru untuk:
- `nn` (Jumlah Router), 
- `ifq_len` (Batas memori antrean tabung router),
- Daftar Kordinat Posisi Node `nodes_pos`,
- Jalur Lalu Lintas Komunikasi UDP `connections`, dan Parameter Pergerakan `mobility`.

Aksi ajaib *coding* ini membuat Anda tidak perlu mengetik ratusan skrip secara manual *hardcode* dan letih *copy-paste*, karena parameter cetak biru (`configs.append`) yang terkumpul ini akan dilahap secara merayap urut menggunakan algoritma **looping `for`** di susunan blok akhir kode Python-nya, untuk di-*Generate* menjadi teks file-file TCL yang solid!

---

## C. Alur (Flow) Berjalan Hingga Mendapatkan Hasil
Berikut detail perjalanan urutan eksekusi simulasi mulai dari _script_ ini hingga memproduksi piala perolehan grafik metrik NS2 otomatis:

1. **Pembuatan Cetak Biru (Memory Storing):** Skrip *Python* merancang struktur data kosong dan mengisi jejeran cetak biru parameter dengan `configs.append(...)` untuk spesifikasi Skenario 1 s/d 20.
2. **Looping Perakit Syntax (Building/Assembly Process):** Pada baris kode terbawah `for i in range(1, 21):`, program Python mencerna satu-per-satu laci konfigurasi dari rak memori tadi dan menyulapnya masuk pada *template* string komposit perintah dasar NS2 Tcl script.
3. **Mencipatakan/Melahirkan File `.tcl`:** *Python* mem-*print/write* `f.write` secara otomatis menyimpan (*Save*) skrip rakitan tersebut yang sudah menetes secara utuh menjadi pecahan 20 file seperti `script1.tcl`, `script2.tcl`, dsb., yang diletakan pas di direktori folder `/root/nsnih/scenarios`. Pesan *'Done writing scripts'* menandakan kompilator rampung.
4. **Fungsi Simulator Menelan Script (Eksekusi NS2):** Giliran *User* turun tangan. Anda memacu simulator *Kernel C++ NS2* di terminal dan memanggil skrip *Generate*-an Python tersebut (Misal: mengebom `$ ns scenarios/script1.tcl`).
5. **Topografi Jaringan Hidup (*Event-Driven Simulation*):** NS2 mulai "hidup", membuat tumpuan menara node di kanvas maya, menghubungkan sambungan agen port pengiriman komunikasi dan mulai menembakkan hujan sinyal CBR yang beradu, macet, tabrakan, antre sesuai skenario jam tayang scheduler.
6. **Melahirkan Data Log Mentah (Trace File):** Aktivitas peluru-peluru paket disorot dan dicetak status rentetannya (*drop/received/sent/forwarded*) membentuk jutaan teks log raksasa kedalam file jejak berekstensi `.tr` (Misal: `s1.tr`).
7. **Penyaringan Awk Terakhir (Metrik Kalkulasi Final):** Ratusan ribu hingga jutaan baris pergerakan rekaman dari file `*.tr` raksasa ini kemudian dilemparkan saring ke mesin pembedah teks (bahasa AWK atau Python Parser lain). Di tahap AWK lah dilakukan matematika "pembagian paket jatuh dibagi paket kirim", "pengurangan jam terima kurang jam hantar" yang kemudian akhirnya menghasilkan metrik ringkasan teladan yakni *Troughput, End-to-End Delay, P-Loss,* dan *Jitter*.

---

## D. Contoh Penerapan Skenario Ini dalam Kehidupan Nyata
Berbagai parameter skenario yang diciptakan melalui sintaks `builder.py` sebenarnya merepresentasikan tantangan miniatur *Wireless Network Topology* di dunia riil sehari-hari. Contoh kasarnya:

1. **Jebolnya Daya Antrean / DropTail (Skala Skrip 3):** Pengaturan antrean (*Queue/ifqLen*) di *router* disetel sedemikian minim. Ibarat sebuah klinik dengan kapasitas 5 kursi ruang tunggu, namun per detiknya dipadati oleh 100 kedatangan Pasien Baru. Tentu pasien ke-6 dan seterusnya terpaksa ditolak di pintu terbuang (*DropTailed* / *Packet Loss*). Efeknya video Streaming YouTube sering memunculkan bulatan *Loading Failed* atau menolak muat secara terputus.
2. **Jasad Hidup Keras Kepala Menunggu Tol (Peristiwa Skrip 4):** Titik antrean penampung *Queue* diset raksasa (`200`). Tidak ada yang ditendang keluar oleh rumah tunggu (*No Packet Loss*), namun koneksi Internet menderita penyendatan telat yang sangat panjang bagaikan antrean di Pintu Keluar Loket Tol ketika Arus Mudik Lebaran. Koneksi Anda "Hidup", tidak DC (Disconnect), tapi harus kesal menunggu bengong 30-detik hanya agar foto IG termuat dari server (Dampak *Heavy Delay*).
3. **Koneksi Melaju Cepat Sambil Diseret (Kasus Mobility Skrip 5 & 13):**  Mewakili sensasi kala terhubung pada Hotspot namun dibawa melaju kencang kereta bawah tanah lalu keluar masuk sinyal terowongan. Jaringannya harus mencopot ikatan secara fisik BTS sel dan menaut ulang tiang jaringan radio baru ketika keluar tebing, menyebabkan indikator ping Merah menclok sesaat 999+ ms alias Jitter (*Keterlambatan interval cacat melompat melingkar*).
4. **Perpotongan Simpang (Efek Collision Mesh di Skrip 12):** Pengibaratan di perpustakaan/stasiun padat di mana ada kelompok baris utara nge-Game dan silang barat yang *Download File Torrent*. Mereka menggunakan antena gelombang rentang radio yang sama. Tabrakan (bentrok frekuensi gelombang/Collision Interferensi) membumbung menaikkan perlambatan paket merayap ke target utamanya masing-masing (*Traffic Light Intersections Congestion*).
5. **Serbuan Banjir War Tiket Konser (Sudden Burst Skrip 14):** Layaknya trafik lengang sebuah web *Ticketing* mendadak di-Bom berjuta-juta klik HTTP permintaan dari penjuru provinsi pas jarum jam tepat jam 12 Siang. Lonjakan data ledakan trafik sepersekian detik mendadak (Brutal Burst) mencekik pipa jalan router peladen utama hingga gagal merespons, melampaui kemampuan laju cerna *server*.
