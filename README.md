# 🌐 Simulasi Jaringan Wireless (NS2)

Halo! Proyek ini adalah simulasi sederhana untuk mempelajari bagaimana data (internet/paket) dikirim melalui jaringan nirkabel (wireless).

## 🧐 Apa ini?
Ini adalah proyek **Simulasi Jaringan**. Bayangkan Anda memiliki beberapa perangkat (node) yang ingin berkomunikasi satu sama lain tanpa kabel. Kami menggunakan alat bernama **NS2 (Network Simulator 2)** untuk meniru perilaku jaringan nyata di komputer.

## 🎯 Apa Tujuannya?
Tujuannya adalah untuk **membandingkan performa** jaringan ketika jumlah perangkatnya bertambah. Sebagai contoh, di sini kami menguji 3 skenario:
1.  **Skenario 1:** 4 perangkat (Sangat sederhana, ada pergerakan perangkat).
2.  **Skenario 2:** 6 perangkat.
3.  **Skenario 3:** 8 perangkat.

> [!TIP]
> Jumlah skenario tidak harus selalu 3. Anda bisa menambah atau mengurangi jumlah skenario, serta mengubah desain simulasinya (seperti posisi node, jumlah node, atau pergerakan) sesuai dengan skema penelitian yang ingin Anda jalankan.

Kami ingin melihat apakah jaringan tetap stabil (data sampai dengan selamat) saat makin banyak perangkat yang tersambung.

## 🛠️ Kenapa Pakai Tools Ini?
1.  **NS2:** Standar dunia akademik untuk riset jaringan. Gratis dan sangat detail.
2.  **NAM (Network Animator):** Untuk **melihat visualisasi**. Anda bisa menonton paket data (kotak kecil) terbang antar perangkat secara nyata.
3.  **AWK:** Bahasa pemrograman kecil untuk "membaca" laporan teks hasil simulasi dan mengubahnya menjadi angka statistik (seperti kalkulator otomatis).

## 🚀 Cara Menjalankan
Cukup jalankan satu perintah di terminal:
```bash
./run_all.sh
```
Perintah ini akan otomatis menjalankan ketiga simulasi dan merangkum hasilnya untuk Anda.

## 📂 Struktur Folder & File
Agar tidak bingung, berikut adalah "peta" dari proyek ini:

| Folder | Isi & Fungsi | Ekstensi Utama |
| :--- | :--- | :--- |
| **`scenarios/`** | Berisi skenario simulasi (logika jaringan). | `.tcl` (Script simulasi) |
| **`tools/`** | Alat untuk menganalisis hasil simulasi. | `.awk` (Script analisis) |
| **`results/`** | Laporan akhir dalam bentuk tabel statistik. | `.csv` (Tabel Excel) |
| **`logs/`** | Catatan super detail setiap kejadian di jaringan. | `.tr` (Trace/Log) |
| **`visuals/`** | File rekaman untuk melihat animasi. | `.nam` (Animasi) |

### Apa isi file-file itu?
-   **`.tcl` (Tcl Script):** Seperti "buku resep". Isinya instruksi ke komputer: "Taruh node di sini, gerakkan ke sana, kirim data jam sekian."
-   **`.awk` (Awk Script):** Seperti "filter kopi". Dia membaca ribuan baris di file `.tr` dan hanya mengambil angka yang kita butuhkan.
-   **`.tr` (Trace File):** File ini **sangat besar** dan sulit dibaca manusia. Isinya rekaman setiap detik: "Paket A dikirim", "Paket B diterima", "Paket C tabrakan".
-   **`.nam` (NAM File):** File khusus yang hanya bisa dibuka aplikasi NAM untuk melihat animasi pergerakan paket.
-   **`.csv` (Comma Separated Values):** Ringkasan hasil akhir yang bisa Anda buka di Excel atau Google Sheets.

## 🏁 Tujuan Akhir (Hasil)
Setelah simulasi selesai, Anda akan mendapatkan file **`results/hasil.csv`** (ringkas) dan **`results/hasil_detail.csv`** (detail perhitungan).

### Ringkasan (hasil.csv)
Berisi 4 metrik QoS:
- **Delay (ms)**: rata-rata waktu tempuh paket end-to-end.
- **Throughput (Kbps)**: laju bit yang berhasil diterima.
- **PacketLoss (%)**: persentase paket yang hilang.
- **Jitter (ms)**: variasi delay antar paket.

### Detail per skenario (hasil_detail.csv)
Selain 4 metrik di atas, file ini menambahkan kolom sumber perhitungannya per skenario:
- `Sent`, `Received` (jumlah paket data)
- `BytesReceived` (total byte yang diterima di tujuan)
- `StartTime(s)`, `EndTime(s)`, `Duration(s)`
- `TotalDelay(s)`, `TotalJitter(s)`

Rumus yang dipakai:
- `avg_delay_ms = (TotalDelay(s) / Received) * 1000`
- `throughput_kbps = (BytesReceived * 8) / (Duration(s) * 1000)`
- `packet_loss_pct = ((Sent - Received) / Sent) * 100`
- `avg_jitter_ms = (TotalJitter(s) / Received) * 1000`

Dengan dua file ini, Anda bisa melihat ringkasan cepat sekaligus “bukti” bagaimana nilai 4 faktor dihitung per skenario.
