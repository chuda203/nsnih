# Apa itu NS2 (Network Simulator 2)?

Bayangkan Anda adalah seorang perencana tata kota. Anda ingin membangun jalan raya baru yang menghubungkan dua kota, tetapi Anda tidak yakin apakah jalan tersebut akan macet atau tidak saat jam sibuk. Daripada langsung membangun jalan aslinya (yang memakan biaya miliaran) dan pada akhirnya menyesal karena ternyata tetap macet, Anda menggunakan **program simulasi di komputer** untuk mengetesnya terlebih dahulu. Anda bisa memasukkan jumlah mobil, mengatur lampu lalu lintas, dan melihat di mana titik kemacetannya.

Nah, **NS2 (Network Simulator 2)** itu fungsinya persis seperti program tata kota tersebut, tetapi **khusus untuk jaringan komputer/internet**.

Secara sederhana, **NS2 adalah aplikasi komputer yang digunakan untuk meniru atau mensimulasikan bagaimana sebuah jaringan komputer bekerja**, sebelum kita benar-benar membangun atau memasang alat aslinya (seperti router, kabel, antena jaringa, dll) di dunia nyata.

---

## Kenapa Kita Sangat Butuh NS2?

Dalam dunia nyata, membangun jaringan komputer (misalnya untuk sebuah kampus, gedung perkantoran, atau jaringan antar provinsi) itu sangat mahal, rumit, dan butuh waktu lama. Kita perlu membeli komputer, menarik kabel yang panjang, dan mengatur pemancar sinyal WiFi. 

Dengan NS2, kita bisa "bermain pura-pura" atau membuat *kandang percobaan*. Kita bisa membuat jaringan palsu di dalam layar laptop kita. Kita jadi bisa mengetes:
- "Apa yang terjadi kalau ada 1000 orang di kampus tiba-tiba men-download film ukuran besar bersamaan?" (Uji Beban/Kapasitas)
- "Apakah kalau kabel utama putus karena digigit tikus, data internet masih bisa lewat jalur cadangan?" (Uji Keandalan)
- "Seberapa cepat pesan WhatsApp dari Anto di Jakarta bisa sampai ke Budi di Papua?" (Uji Kecepatan/Delay)

Semua rute dan masalah itu bisa dites secara virtual di NS2 tanpa kita harus membeli satu paku atau kabel tambahan! Jika ternyata hasil simulasinya "lemot/lagging", kita tinggal ubah pengaturannya di komputer sampai hasilnya bagus, baru setelah itu kita benar-benar membangun fisik aslinya.

---

## Contoh Analogi dalam Kehidupan Sehari-hari

Supaya lebih mudah dipahami oleh orang awam, bayangkan cara kerja NS2 itu memodelkan **Sistem Pengiriman Paket Ekspedisi (seperti JNE, J&T, atau Pos)**:

1. **Jalan Raya (Link):** 
   Dalam internet, ini sama dengan kabel internet atau gelombang WiFi. Di simulasi NS2, kita bisa atur apakah jalan ini adalah "jalan tol 4 lajur" (koneksi cepat dan lebar seperti *fiber optic*) atau "jalan tanah pedesaan yang sempit" (koneksi lambat).

2. **Kantor Cabang / Gudang Transit (Node/Router):** 
   Ini tempat paket ditumpuk, disortir, lalu dipindahkan ke truk yang menuju ke kota tujuan berikutnya. Di NS2, "paket data internet" akan singgah di berbagai "node" ini sebelum sampai ke HP kita.

3. **Isi Barang / Truk Pengirim (Packet):** 
   Ini adalah "data" (misalnya foto di Instagram, video YouTube, atau pesan teks) yang dikirim dari satu orang ke orang lain. Kalau jalanannya penuh (kelebihan muatan di jalan yang sempit), truknya bisa macet. Di dunia nyata internet, ini yang kita rasakan sebagai *"buffering"* atau nge-lag.

4. **Petugas Pengatur Rute (Routing Protocol):** 
   Ini adalah aplikasi "Google Maps" atau aturan yang menentukan si truk ini harus lewat jalur mana supaya paketnya paling cepat sampai hindari kemacetan atau jembatan putus.

---

## Apa Saja yang Diukur atau Diteliti di NS2?

Layaknya bos perusahaan ekspedisi yang mengevaluasi kinerja layanan pengirimannya setiap bulan, di NS2 kita mengevaluasi *"apakah jaringan yang kita buat ini bagus atau tidak?"*. Beberapa parameter utama yang sering diukur adalah:

- **Delay (Keterlambatan Waktu):** 
  Berapa lama waktu yang dibutuhkan paket berjalan dari pengirim sampai ke tangan penerima. (Contoh analogi: Apakah butuh 2 hari cepat sampai, atau molor sampai 1 minggu?).
  
- **Throughput (Pita Lebar / Kelancaran Target):** 
  Berapa banyak data yang benar-benar sukses dikirim dalam waktu satu detik. (Contoh analogi: Berapa jumlah kotak paket rata-rata yang bisa dikirimkan dan tiba dengan selamat di tujuan setiap harinya?).

- **Packet Loss (Paket Hilang atau Tercecer):** 
  Berapa banyak data yang gagal sampai ke tujuan karena jalanan macet parah (sehingga dibuang sistem) atau terjadi gangguan koneksi kabel. (Contoh analogi: Dari 100 paket vas bunga yang dikirim menggunakan truk ekspedisi, ternyata ada 5 paket yang jatuh ke sungai atau salah kirim alamat. Berarti ada 5% Packet Loss).

- **Jitter (Variasi Keterlambatan):**
  Perbedaan waktu kedatangan paket. (Contoh analogi: Paket hari Senin datangnya pagi, paket hari Selasa datangnya malam, paket Rabu datang siang. Kedatangannya tidak stabil, hal ini sangat mengganggu saat kita sedang melakukan telepon suara/Video Call).
  
---

## Kesimpulan Singkat

Intinya, NS2 hanyalah **"Laboratorium Virtual"** bagi mekanik, ilmuwan, atau teknisi jaringan untuk **eksperimen atau mencoba-coba racikan** membuat jalur internet yang paling cepat, murah, dan anti-macet, tepat sebelum mereka benar-benar bekerja membangunnya di lapangan.
