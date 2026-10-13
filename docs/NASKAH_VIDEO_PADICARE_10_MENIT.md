# Naskah Video Laporan PadiCare (±10 Menit)

**Cara pakai:** Teks dalam tanda kutip dibacakan. Teks dalam kurung siku adalah petunjuk rekaman atau data yang harus diisi sesuai hasil akhir. Bacakan dengan tempo wajar, sekitar 120–135 kata per menit. Bagian demo memiliki dua pilihan; pilih **A** jika deteksi TFLite sudah benar-benar berjalan di Android, atau **B** jika saat rekaman aplikasi masih berupa prototipe antarmuka. Jangan membacakan kedua pilihan.

**Isi sebelum merekam:** [nama dan NIM], [sumber dataset dan izin penggunaan], [jumlah citra dan kelas final], [hasil evaluasi model yang benar-benar tersedia], [perangkat uji], serta [hasil uji nyata]. Jika datanya belum ada, gunakan naskah pilihan B dan jangan menyebut angka atau hasil prediksi.

## 0:00–0:45 — Pembuka

[Tampilkan judul proyek, nama, NIM, dan beranda PadiCare.]

> “Halo, saya [nama], NIM [NIM]. Pada video ini saya akan menjelaskan proses perancangan dan pengembangan PadiCare, aplikasi mobile untuk membantu pemeriksaan awal gejala penyakit pada daun padi melalui foto. Proyek ini dibuat untuk mata kuliah Mobile Programming. Saya akan membahas masalah yang ingin diselesaikan, rancangan sistem dan antarmuka, implementasi Flutter, serta hasil pengujian yang sudah benar-benar dilakukan.”

## 0:45–1:45 — Latar Belakang, Masalah, dan Tujuan

[Tampilkan ringkasan PRD atau slide masalah dan solusi.]

> “Perubahan visual pada daun padi dapat menjadi tanda awal gangguan tanaman. Di lapangan, pengguna mungkin melihat bercak atau perubahan warna, tetapi belum tentu dapat membedakan gejalanya secara cepat. Pemeriksaan manual tetap penting, namun aplikasi di ponsel dapat membantu pengguna mencatat dan memahami dugaan awal dari satu foto daun.
>
> Permasalahan utama yang saya angkat adalah bagaimana menyediakan alur pemeriksaan awal yang sederhana, mudah dibaca, dan dapat digunakan langsung melalui ponsel. Tujuan PadiCare adalah menerima foto satu daun padi, menampilkan pratinjau, lalu—ketika model sudah terintegrasi—memberikan dugaan kelas dari hasil klasifikasi gambar. Hasil aplikasi bukan diagnosis pasti dan tetap perlu dikonfirmasi melalui pengamatan lapangan atau petugas penyuluh.”

## 1:45–2:35 — Pengguna, Kebutuhan, dan Ruang Lingkup

[Tampilkan bagian pengguna, kebutuhan fungsional, dan batas MVP dari PRD.]

> “Sasaran utama aplikasi ini adalah petani atau pengguna yang melakukan pengamatan tanaman di lapangan. Karena digunakan pada kondisi lapangan, tampilan harus jelas, tombol mudah disentuh, dan langkah penggunaan tidak berbelit. Kebutuhan fungsional utamanya meliputi pemilihan foto dari kamera atau galeri, pratinjau gambar, proses analisis, tampilan hasil dan penjelasan singkat, panduan foto, informasi penyakit, serta penanganan kendala seperti izin kamera ditolak atau gambar tidak terbaca.
>
> Ruang lingkup awal sengaja dibatasi pada satu foto daun untuk satu pemeriksaan. Fitur akun, penyimpanan riwayat, dan layanan cloud tidak menjadi fokus versi ini. Fokusnya adalah satu alur yang dapat didemonstrasikan dengan jelas.”

## 2:35–3:45 — Tahap 2: Perancangan Sistem dan Antarmuka

[Tampilkan diagram alur, use case, struktur navigasi, lalu beberapa rancangan Stitch.]

> “Sebelum membuat kode, saya menyusun rancangan sistem dan antarmuka. Alur utamanya dimulai dari beranda. Pengguna menekan tombol ‘Mulai Deteksi Daun’, memilih kamera atau galeri, memeriksa pratinjau foto, lalu melanjutkan ke proses analisis. Sesudah itu aplikasi menampilkan hasil atau pesan kendala yang sesuai. Dari beranda, pengguna juga dapat membuka Panduan Foto, Informasi Penyakit, dan halaman Tentang PadiCare.
>
> Use case utamanya adalah pengguna memilih foto dan meminta pemeriksaan awal. Skenario alternatifnya mencakup pengguna membatalkan pemilihan, izin kamera ditolak, foto tidak terbaca, serta model gagal dimuat. Untuk rancangan data, saya memisahkan informasi gambar masukan, status proses, label hasil, skor keluaran model, dan jenis kesalahan. Saya tidak membutuhkan basis data pengguna pada cakupan awal ini.
>
> Antarmuka dirancang melalui wireframe dan purwarupa di Google Stitch. Ada dua belas rancangan layar atau status, termasuk beranda, pilihan sumber foto, pratinjau, proses analisis, beberapa variasi hasil, dan pesan kesalahan. Warna hijau, teks yang kontras, dan tombol besar dipilih agar aplikasi mudah digunakan serta tampil konsisten.”

## 3:45–4:50 — Implementasi dan Alur Teknis

[Tampilkan struktur folder Flutter dan diagram singkat: foto → praproses → model → hasil.]

> “Implementasi aplikasi memakai Flutter. Kode dipisahkan menjadi layar, komponen antarmuka, model data, tema, dan layanan pemilihan gambar serta klasifikasi. Saat pengguna memilih foto, aplikasi memeriksa apakah gambar dapat dibaca dan menampilkannya untuk dikonfirmasi. Pada rancangan akhir, gambar kemudian diproses sesuai spesifikasi input model, misalnya ukuran dan normalisasi yang sama dengan tahap pelatihan. Model MobileNetV3 yang telah dikonversi ke TensorFlow Lite akan menghasilkan skor untuk setiap kelas. Aplikasi memetakan skor itu ke label yang benar, kemudian menampilkan dugaan hasil dan penjelasan batasannya.
>
> Kelas penyakit final tidak saya tentukan hanya dari rancangan UI. Kelas harus mengikuti dataset yang benar-benar tersedia, telah diperiksa labelnya, dan dipakai untuk melatih serta menguji model. Karena itu, contoh tampilan hasil pada desain tidak diperlakukan sebagai prediksi nyata.”

## 4:50–7:25 — Demo A: Jika Klasifikasi TFLite Sudah Berjalan di Android

**Gunakan bagian ini hanya setelah model `.tflite`, label, praproses, serta prediksi nyata terbukti bekerja pada perangkat Android.**

[Tampilkan aplikasi di Android. Rekam layar saat membuka beranda, memilih foto, melihat pratinjau, menjalankan analisis, membuka hasil, lalu mengulangi dengan foto lain. Jika uji mode pesawat berhasil, tampilkan indikator mode pesawat sebelum analisis.]

> “Sekarang saya mendemonstrasikan aplikasi PadiCare. Pada beranda terdapat tombol utama untuk memulai pemeriksaan, serta menu Panduan Foto, Informasi Penyakit, dan Tentang PadiCare. Panduan Foto menjelaskan bahwa satu daun perlu terlihat jelas, dengan cahaya yang cukup dan latar yang tidak terlalu ramai.
>
> Saya menekan ‘Mulai Deteksi Daun’, kemudian memilih [kamera/galeri] dan mengambil satu foto daun padi. Sebelum dianalisis, foto ditampilkan pada halaman pratinjau. Jika hasil foto buram atau salah pilih, saya dapat mengganti foto. Saya lanjutkan dengan menekan tombol analisis.
>
> Hasil yang muncul adalah [kelas hasil dari aplikasi], dengan skor model [skor yang benar-benar tampil]. Angka ini adalah skor keluaran model untuk foto tersebut, bukan kepastian diagnosis dan bukan ukuran akurasi keseluruhan aplikasi. Halaman hasil juga memberikan keterangan singkat serta tombol untuk mencoba foto lain. Berikut saya tunjukkan satu contoh lain [tampilkan foto kedua atau kondisi hasil belum meyakinkan jika benar-benar terjadi].
>
> Pada pengujian ini, perangkat yang dipakai adalah [perangkat dan versi Android]. [Jika sudah diuji: Saat mode pesawat aktif, analisis tetap berjalan karena model tersedia secara lokal.] [Jika belum diuji: Pengujian mode pesawat belum saya selesaikan, jadi kemampuan offline penuh belum saya klaim.]”

## 4:50–7:25 — Demo B: Jika Model Belum Terintegrasi

**Gunakan bagian ini bila saat merekam model belum bisa memberi prediksi nyata.**

[Tampilkan beranda, modal sumber foto, panduan, informasi penyakit, tentang, lalu pratinjau jika pemilihan foto berjalan pada platform yang digunakan. Jangan menampilkan mockup hasil sebagai hasil analisis langsung.]

> “Sekarang saya mendemonstrasikan bagian aplikasi yang sudah berjalan. Pada beranda, pengguna dapat melihat tujuan PadiCare dan membuka beberapa menu utama. Saya mulai dari Panduan Foto. Halaman ini menjelaskan cara mengambil gambar satu daun yang jelas agar masukan lebih baik. Berikutnya ada Informasi Penyakit, yang menampilkan informasi umum tentang gejala dan langkah pengamatan. Pada halaman Tentang, aplikasi menjelaskan tujuan dan batas hasilnya.
>
> Saya kemudian menekan ‘Mulai Deteksi Daun’. Aplikasi menampilkan pilihan kamera atau galeri. [Jika benar-benar berhasil di perangkat yang direkam: Saya memilih foto dan melihat pratinjaunya; dari sini pengguna dapat mengganti foto sebelum analisis.] [Jika belum berhasil: Alur pengambilan dan pratinjau foto masih dalam perbaikan pada platform yang saya gunakan, jadi bagian tersebut belum saya nyatakan selesai.]
>
> Pada tahap rekaman ini, PadiCare masih berupa prototipe antarmuka. Dataset sedang diaudit dan model MobileNetV3 belum selesai diintegrasikan sebagai TensorFlow Lite. Karena itu saya tidak menampilkan angka skor atau dugaan penyakit seolah-olah berasal dari model. Ketika pengguna meminta analisis sebelum model tersedia, aplikasi perlu menampilkan pesan kendala yang jujur. Langkah berikutnya adalah menyelesaikan dataset, melatih dan mengevaluasi model, lalu menguji hasil klasifikasi pada Android.”

## 7:25–8:25 — Pengujian dan Hasil yang Dapat Dibuktikan

[Tampilkan terminal `flutter analyze`, `flutter test`, APK, atau tabel uji yang relevan. Sesuaikan dengan pengujian terbaru.]

> “Untuk memeriksa kualitas implementasi, saya menjalankan analisis kode Flutter dan tes yang tersedia. Pada pemeriksaan terakhir, `flutter analyze` tidak menemukan masalah dan enam tes antarmuka serta model data lulus. APK debug Android juga sudah berhasil dibuat. Tes tersebut memastikan beberapa elemen beranda, navigasi, dan konsistensi status data, tetapi belum membuktikan ketepatan klasifikasi penyakit.
>
> Untuk model AI, bukti yang perlu disiapkan adalah sumber dan izin data, jumlah gambar per kelas, pemisahan data latih dan uji, metrik evaluasi, serta contoh prediksi yang benar dan yang salah. [Jika sudah ada hasil nyata: Dari pengujian akhir, saya memperoleh [sebut metrik dan jumlah data uji yang dapat dibuktikan].] [Jika belum ada: Evaluasi model dan pengujian foto lapangan masih menjadi pekerjaan berikutnya.]”

## 8:25–9:15 — Penggunaan AI dalam Pengerjaan

[Tampilkan contoh ringkas prompt dan hasil koreksi; hindari menayangkan data pribadi atau token.]

> “Mata kuliah ini mewajibkan penggunaan AI dalam proses pengerjaan. Saya menggunakan ChatGPT untuk membantu menyusun dan meninjau PRD, roadmap, rancangan tahap dua, serta memeriksa konsistensi klaim dan kebutuhan pengujian. Saya menggunakan Google Stitch sebagai bantuan merancang antarmuka, lalu Antigravity untuk membantu menulis dan menguji kode Flutter.
>
> Hasil dari AI tidak langsung saya anggap benar. Saya memeriksa apakah fitur sesuai PRD, apakah kode dapat dianalisis dan diuji, serta apakah hasil yang ditampilkan benar-benar berasal dari model. Contohnya, angka skor pada desain adalah contoh visual, sehingga tidak boleh digunakan sebagai hasil prediksi aplikasi.”

## 9:15–10:00 — Penutup

[Tampilkan beranda PadiCare dan ringkasan status proyek.]

> “Kesimpulannya, PadiCare dirancang sebagai alat bantu pemeriksaan awal daun padi melalui aplikasi mobile. Proyek ini sudah memiliki analisis kebutuhan, rancangan alur dan antarmuka, serta fondasi aplikasi Flutter. [Jika model siap: Versi yang saya demonstrasikan sudah menjalankan klasifikasi lokal pada Android untuk kelas [kelas final], dengan batasan sesuai hasil uji.] [Jika model belum siap: Pada versi yang saya demonstrasikan, klasifikasi AI belum selesai sehingga aplikasi masih saya sebut prototipe antarmuka.]
>
> Pengembangan berikutnya adalah memperbaiki kualitas dan keberagaman data, menguji foto pada kondisi lapangan yang berbeda, mengukur kesalahan model, dan menyempurnakan kemudahan penggunaan. Terima kasih.”

---

## Pemeriksaan sebelum merekam

- Pilih hanya Demo A **atau** Demo B; hapus pilihan yang tidak dipakai dan semua kalimat dalam kurung siku yang tidak sesuai.
- Rekam layar dari perangkat dan versi aplikasi yang benar-benar diuji. Build web/Chrome tidak membuktikan inferensi TFLite Android.
- Jangan membacakan angka akurasi, skor, waktu inferensi, jumlah data, atau klaim offline tanpa bukti pengujian.
- Jika Antigravity memperbarui kelas, dataset, atau fitur, sesuaikan bagian 3:45–4:50 dan 7:25–8:25 dengan hasil akhir.
- Coba baca naskah sekali sambil mengukur waktu, lalu pendekkan jeda demo atau tambahkan penjelasan sesuai kebutuhan agar durasi mendekati 10 menit.
