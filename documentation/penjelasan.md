# Penjelasan Kinerja Jaringan, Gelombang, dan Parameter QoS Jaringan pada Simulasi NS

Dalam memodelkan jaringan komputer dan nirkabel *(wireless)* via Network Simulator 2 (NS2), pengamatan dari efektivitas kinerja *(Quality of Service - QoS)* sebuah lalu lintas diukur dengan mengevaluasi log (trace-file) dari apa yang berhasil dan gagak melewati rute transmisi tersebut.
Berikut ini pembahasan mendetail mengenai berbagai hambatan serta rumus kalkulasi kinerjanya.

---

## 1. Analisis Mengenai Hambatan dan Fungsi Jaringan Nirkabel
Keandalan jaringan tidaklah mutlak. Ada sebuah konsep *Bottle-neck* (kemacetan atau leher botol) atau kendala struktural yang dianalogikan sebagai penyempitan sehingga lalu lintas tidak lancar. Pada transmisi nirkabel maupun kabel, hambatan dapat berupa:

### A. Hambatan Fisis Jaringan Berbasis Medium Gelombang Elektromagnetik
Transmisi data di simulasi Wireless ad-hoc melibatkan penembakan modulasi bit-bit kedalam medium udara secara omnidireksional dengan rambatan radio. Hambatan berbasis perambatan gelombang meliputi:
- **Atenuasi Jarak (Attenuation):** Semakin sebuah gelombang listrik merambat jauh, maka melemahnya kekuatan (*signal power*) akan memudar dan terus membuyar oleh karena faktor medium alam maupun hamburan refleksi *TwoRayGround* ke permukaan tanah. Bila jauh antar *node* melebihi limit *coverage* dari standar transmisinya, sinyal tak bisa di-*decode* alias korup menjadi *Noise*.
- **Interferensi / Tabrakan (Collision):** Karena medium udara sifatnya dibagikan bersama *(shared space)*, ketika beberapa dua arah berlawanan melakukan pemancaran radio di rentang jarak bentur/berdekatan di frekuensi yg persis sama tanpa sadar CSMA/CA *(Hidden node)* maka paket memancarkan secara serentak sehingga merusak perambatan gelombang satu sama lain dan menyebabkan tabrakan MAC *CollisionDrop*. Semua gelombang gagal disatukan kembali hingga akhirnya paket gugur (*dropped*).

### B. Hambatan Kapasitas Node (Konsep Bottle-Neck Antrean)
Hambatan beban di internal perangkat Router *(Processing Node)*:
- **Antrean Penuh / Buffer Overflow (Queue Drop):** Antarmuka setiap node (*Interface queue / IfQ*) memuat memori sesaat bernama *Buffer Queue* yang menampung paket ketika sibuk. Jika batas maksimum *ifqLen* antrean jaringan hanyalah 50 dan jumlah pengiriman trafik terlalu brutal (seperti contoh trafik 100 paket konstan dalam sedetik layaknya Script 7), buffer antrean tak punya tenaga transmisi tersisa per detiknya dan akan "menumpahkan" atau membuang paket yang datang tak diundang *(DropTail)*. Drop yang muncul memotong persentase koneksi kesuksesan data.
- **Routing Overhead Constraint:** Protokol seperti AODV tidak lantas diam. Kalau laju putus tengah jalan karena *Attenuation*, node melapor "Route Error" dan berhenti mendadak untuk menyebarkan (broadcast) gelombang RREQ ke semua orang, melambatkan laju proses data lain yang antri menumpang *Delay processing*.

---

## 2. Kualitas Kinerja Parameter Evaluasi (QoS) Berdasarkan NS Trace

Sebuah arsitektur performa ditinjau membuahkan angka rumus standar yang sudah diajarkan menggunakan 4 *Golden Metrics* berikut:

### 1. Throughput Aktual (Kinerja Pengiriman Kapasitas Sukses)
Merupakan kemampuan real kemampuan jumlah bit (ukuran aliran aktual) yang disedot dan *BERHASIL* sampai mendarat diterima pada sisi *Node tujuan (Dest)* secara keseluruhan pada suatu jeda satuan masa total. 
- **Satuan Metriks Utama:** Kbps, ataupun Mbps (*Megabits per second*). Umumnya nilai semakin tinggi *(Maximized)* semakin optimal dan bagus kinerjanya.
- **Dampak Simulasi:** Karena kepadatan trafik, hambatan atau antrean, angka ini tak mungkin melampaui kemampuan Bitrate asli asal (*Bandwidth capacity*).
- **Logika Rumusnya Secara Deskriptif:** Diperoleh seluruh jumlah lalu lintas ukuran byte paket UDP yang "Sukses Diterima (Receive - r)" yang lantas dikali 8 untuk pergeseran Bit, dibagikan merata ke sekian sekat pembatasan durasi "waktu finish transfer dikurang batas waktu detik transmisi mulai pertama kali". (Total Bit Data Sukses Diterima / Lama Waktu Perjalanan).

### 2. End-to-End Delay (Kelambatan Relatif)
Kelambatan yang terjadi berupa representasi waktu merata dari awal sebuah unit serpihan paket keluar melintang melalui banyak router untuk berlayar menuju simpul tujuan hingga diterimanya (*Destination Receive*).
- **Satuan Metriks Dasar:** milisecond (ms) atau sekon (s). Harus diminimasi (*Minimum*).
- **Analogi Komponen Penyumbangnya:** Dipengaruhi rumit oleh *Processing Delay* (melakukan cek algoritma route lapis jaringan), *Queuing Delay* (memakai waktu santai parkir bergiliran menunggu dalam antrean Mac/IfQ yang lambat memproses padat trafik), serta *Transmission* dan *Propagation delay* laju udara fisis.
- **Rumus Delay Average NS2:** (Waktu Mendarat di Rerata Tujuan paket Tuntasan - Waktu Berangkatnya Paket dari Source) dan di akumulasikan semua paket tersebut dari rentetan trafik CBR lantas dibagikan ke total paket utuh sukses tersebut.

### 3. Packet Loss Ratio (Kehilangan/Tingkat Serpihan Hilang)
Nilai persentase paket yang hilang melambangkan integritas atau kerusakan seberapa rapuh struktur konektivitas lalu lintas nirkabel. Kehilangan di NS2 berupa kejadian ditandai abjad (*"D" / Drop / Discard*) di trace file log karena hambatan gelombang tabrakan di perlintasan atau sekedar dihapus antrean penuh limit.
- **Satuan:** Rasio proporsional persen (%). Tentunya semakin rendah tingkat persentase akan meminimalkan *packet error*. Layanan *Real-time Gaming/Streaming* sensitif akan angka ini.
- **Keterkaitan pada Hambatan Gelombang:** Adanya hambatan node berlebih memunculkan antrean Drop (dibuang mentah mentah). Ada juga tabrakan pada perulangan pengiriman (MAC retry exceeded / MAC Coll).
- **Konsep Rumusan di NS:** (Total Jumlah Unit Paket Sent(Kirim) yang Dilepaskan oleh titik Source) - (Total Riil Paket Awal Tadi yang Selesai di Receiver). Selisih kehilangan sisa rongsokan ini dibagikan kembali ke total asup Sent nya untuk diubah ke persentase kali seratus.

### 4. Jitter (Variasi Gangguan Kelambatan Delay Sesaat)
Jitter dapat dianalogikan sebagai seberapa acak dan fluktuatif (variansi perubahan mendadak) tingkat kesenjangan nilai kelambatan (*Delay*) antara sebuah paket dari paket tetangganya per satuan perjalanan jeda yang menyusulnya. Singkatnya: ia bertugas mengukur ketidakstabilan Delay (Pergolakan antrean paket yang sesak maju-mundur secara tidak beraturan / berfluktuasi naik dan turun mendadak terus).
- **Satuan Indeks:** mili-sekon (ms). Keberadaan jitter besar mutlak tidak ideal dan menyebabkan tayangan buffer putus-putus.
- **Penyebab Logikal dari NS:** Terjadi saat antrean MAC yang membesar dan seketika langsung mengeras terkosong, atau perpindahan rute baru secara spontan karena Node rute utama tertekan tabrakan interferensi gelombang tetangga, menyebabkan sekapan gelombang acak durasinya diudara. Paket bisa datang lebih cepat dan selanjutnya terlambat lambat.
- **Rumus Hitungannya:** Rata-rata yang diwakili perbedaan interval Delta, Absolut (Nilai Tiba Delay dari paket urutan selanjutnya yang datang [ Paket ke-`i` ] dikurangi Total Nilai Tiba Delay dari rentang sebelumnya [ Paket ke-`i-1` ]). Absolut variansi tersebut digabung seiring seluruhnya pergerakan.
