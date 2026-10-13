# Naskah Video Laporan PadiCare — 3 Orang, ±13 Menit

## Petunjuk pemakaian

Naskah ini dibagi menjadi tiga pembicara dengan durasi yang hampir seimbang. Kalimat dalam tanda kutip dibacakan; teks dalam **[kurung siku]** adalah arahan tampilan atau isian yang harus disesuaikan. Gunakan nama asli tiap anggota. Bacakan dengan tempo percakapan, beri jeda saat berpindah layar, dan lakukan satu kali latihan dengan stopwatch.

| Pembicara | Waktu | Tanggung jawab |
|---|---:|---|
| Anggota 1 | 0:00–4:15 | Pembuka, masalah, PRD, pengguna, kebutuhan, dan alur sistem |
| Anggota 2 | 4:15–8:30 | Rancangan antarmuka, model data, arsitektur, dataset dan AI dalam pengerjaan |
| Anggota 3 | 8:30–13:00 | Demonstrasi, pengujian, batasan, dan penutup |

**Data yang wajib diisi sebelum rekaman:** [nama/NIM tiga anggota], [sumber dan izin dataset final], [jumlah citra serta kelas final jika sudah dipastikan], [metrik evaluasi jika tersedia], [perangkat dan platform demo], serta [hasil uji terakhir]. Kamera belum berfungsi pada versi demo ini. Pilih **Demo A** hanya jika prediksi TFLite benar-benar bekerja dari foto galeri di Android. Jika belum, gunakan **Demo B**. Jangan membaca kedua versi.

---

## Anggota 1 — 0:00–4:15

### 0:00–0:35 | Pembuka

[Tampilkan judul “PadiCare”, nama tiga anggota, mata kuliah, dan beranda aplikasi.]

> “Halo, kami dari kelompok [nama kelompok]. Saya [nama anggota 1], bersama [nama anggota 2] dan [nama anggota 3]. Pada video ini kami akan memaparkan PadiCare, proyek mata kuliah Mobile Programming. Pembahasan kami dimulai dari masalah dan kebutuhan pengguna, dilanjutkan rancangan sistem, proses pengembangan dengan bantuan AI, demonstrasi aplikasi, serta hasil pengujiannya.”

### 0:35–1:40 | Latar belakang dan masalah

[Tampilkan foto daun padi yang sah digunakan atau ringkasan latar belakang dari PRD.]

> “Daun padi dapat menunjukkan perubahan warna, bercak, atau kerusakan yang menjadi petunjuk awal adanya gangguan tanaman. Namun, pengamatan visual di lapangan tidak selalu mudah, terutama ketika pengguna perlu mengambil keputusan awal dengan cepat. Karena itu kami mengangkat masalah bagaimana sebuah aplikasi ponsel dapat membantu pengguna melakukan pemeriksaan awal dari foto satu daun padi.
>
> PadiCare dirancang untuk menerima gambar daun, menampilkan pratinjau, dan pada versi yang modelnya sudah terintegrasi memberikan dugaan kelas berdasarkan pola visual. Kata ‘dugaan’ penting di sini. Hasil aplikasi tidak menggantikan pemeriksaan agronomis atau konsultasi dengan petugas penyuluh lapangan. Aplikasi hanya menjadi alat bantu awal.”

### 1:40–2:50 | Tujuan, pengguna, dan kebutuhan

[Tampilkan halaman kebutuhan fungsional dan nonfungsional pada PRD.]

> “Tujuan pengembangan PadiCare adalah membuat alur pemeriksaan yang sederhana, dapat dipahami, dan nyaman digunakan pada layar ponsel. Pengguna utamanya adalah petani atau orang yang sedang mengamati kondisi tanaman padi. Mereka memerlukan tombol yang jelas, langkah yang singkat, serta penjelasan hasil yang tidak terlalu teknis.
>
> Kebutuhan fungsional utama meliputi memilih foto dari kamera atau galeri, melihat dan mengganti foto, meminta analisis, membaca hasil serta batasnya, membuka panduan pengambilan foto, dan melihat informasi penyakit. Aplikasi juga harus memberi pesan saat izin ditolak, foto gagal dibaca, atau model tidak tersedia. Dari sisi nonfungsional, kami memperhatikan keterbacaan, konsistensi tampilan, waktu respons, serta privasi foto. Pada MVP ini kami fokus pada satu foto daun untuk satu pemeriksaan. Fitur akun, riwayat pemeriksaan, dan layanan cloud belum termasuk cakupan.”

### 2:50–4:15 | Alur, use case, dan navigasi

[Tampilkan diagram alur Tahap 2, use case/skenario, dan struktur navigasi. Sorot jalurnya saat dibacakan.]

> “Pada Tahap 2, kami merancang alur aplikasi sebelum implementasi Flutter. Pengguna memulai dari beranda, memilih sumber foto, kemudian memeriksa pratinjau. Jika foto kurang jelas, pengguna dapat menggantinya. Jika foto sudah sesuai, pengguna melanjutkan ke analisis. Hasil yang diharapkan berupa dugaan kelas, skor keluaran model, penjelasan singkat, serta pilihan untuk memotret ulang. Bila ada kendala, aplikasi menampilkan pesan yang sesuai agar pengguna tahu langkah berikutnya.
>
> Use case utama adalah melakukan pemeriksaan dari satu foto daun. Skenario alternatifnya mencakup pembatalan pemilihan foto, izin kamera ditolak, berkas rusak, dan kegagalan memuat model. Navigasinya juga dibuat sederhana: dari beranda pengguna bisa masuk ke alur deteksi, Panduan Foto, Informasi Penyakit, atau halaman Tentang. Rancangan ini membantu kami menentukan layar mana yang perlu dibuat dan bagaimana pengguna kembali ke langkah sebelumnya.
>
> Selanjutnya, [nama anggota 2] akan menjelaskan rancangan antarmuka dan cara kami menyiapkan bagian teknisnya.”

## Anggota 2 — 4:15–8:30

### 4:15–5:20 | Wireframe dan purwarupa antarmuka

[Tampilkan wireframe pada dokumen Tahap 2, lalu beberapa layar Stitch dan tampilan Flutter.]

> “Terima kasih. Setelah alurnya jelas, kami membuat sketsa awal atau wireframe, kemudian purwarupa antarmuka dengan Google Stitch. Paket desainnya berisi dua belas rancangan layar atau status, antara lain beranda, pemilihan sumber foto, bantuan izin, panduan foto, pratinjau, proses analisis, variasi hasil, penanganan kendala, informasi penyakit, dan halaman Tentang.
>
> Kami memilih warna utama hijau tua, latar terang, teks kontras, dan tombol yang cukup besar. Tujuannya agar elemen penting mudah dibaca dan disentuh, termasuk saat aplikasi dipakai di luar ruangan. Rancangan Stitch kami gunakan sebagai acuan visual. Teks contoh dan angka skor pada desain tidak kami perlakukan sebagai hasil prediksi yang sebenarnya.”

### 5:20–6:15 | Model data dan struktur aplikasi

[Tampilkan struktur folder `lib/` dan diagram data sederhana.]

> “Rancangan data aplikasi berfokus pada satu pemeriksaan. Data yang dibutuhkan adalah foto masukan, status proses, kemungkinan label hasil, skor dari model, penjelasan, dan jenis kesalahan. Untuk cakupan awal ini, kami belum memerlukan basis data akun maupun riwayat. Struktur kode Flutter dipisahkan menjadi layar, komponen tampilan, tema, model data, serta layanan pemilihan foto dan klasifikasi. Pemisahan ini membantu agar tampilan tidak bercampur dengan proses pengolahan gambar.”

### 6:15–7:30 | Dataset, MobileNetV3, dan TensorFlow Lite

[Tampilkan diagram “dataset → pelatihan → evaluasi → TFLite → Flutter”; jika belum ada model, tampilkan sebagai rencana, bukan hasil.]

> “Untuk deteksi penyakit, rancangan kami memakai MobileNetV3 sebagai arsitektur klasifikasi gambar. Dataset harus lebih dahulu diaudit: sumber dan izin penggunaan, jumlah foto, kesesuaian label, mutu gambar, serta pembagian data latih, validasi, dan uji. Kandidat kelas awal dari PRD adalah daun tampak sehat, bercak coklat, dan hawar daun bakteri, tetapi kelas final harus mengikuti data yang benar-benar dapat digunakan.
>
> Setelah model dilatih, kami perlu mengevaluasi hasilnya, termasuk melihat kesalahan per kelas. Model kemudian dikonversi ke format TensorFlow Lite untuk integrasi pada Android. Foto yang dipilih pengguna harus diproses dengan ukuran, urutan warna, dan normalisasi yang sama seperti saat pelatihan. Skor yang dihasilkan model adalah skor klasifikasi pada gambar tersebut, bukan kepastian diagnosis. [Jika sudah ada hasil final: Dataset final kami berasal dari [sumber], terdiri dari [jumlah] citra dengan kelas [kelas]. Evaluasi pada data uji menghasilkan [metrik yang benar-benar tercatat].] [Jika belum: Saat rekaman ini, audit data dan pelatihan masih berjalan, sehingga kami belum menyebut nilai akurasi atau kelas final.]”

### 7:30–8:30 | Peran AI dan serah terima demo

[Tampilkan potongan PRD, desain Stitch, prompt Antigravity, lalu struktur proyek; tutup dengan beranda PadiCare.]

> “Dalam mata kuliah ini kami diwajibkan memakai AI selama pengerjaan. ChatGPT membantu kami menyusun dan meninjau PRD, roadmap, rancangan Tahap 2, serta batas klaim dan rencana pengujian. Google Stitch membantu membuat purwarupa antarmuka. Antigravity membantu implementasi kode Flutter dan pemeriksaan teknisnya. Tugas kami sebagai mahasiswa adalah memeriksa kembali hasil bantuan AI, memilih keputusan yang masuk akal, menjalankan aplikasi, dan melaporkan keterbatasannya secara jujur.
>
> Sebagai contoh, sebelum model nyata tersedia kami tidak menggunakan angka contoh dari desain sebagai prediksi aplikasi. Berikutnya, [nama anggota 3] akan memperlihatkan fitur yang sudah berjalan dan bukti pengujiannya.”

## Anggota 3 — 8:30–13:00

### 8:30–11:10 | Demo A — jika prediksi TFLite sudah berjalan di Android

**Pilih bagian ini hanya jika model, label, praproses, dan prediksi nyata dari foto galeri sudah diuji pada Android. Kamera tetap disebut sebagai kendala.**

[Rekam layar Android. Tunjukkan beranda → Panduan Foto → kembali → Mulai Deteksi → jelaskan kamera belum berfungsi → pilih galeri → pratinjau → analisis → hasil → foto ulang. Biarkan proses layar terlihat tanpa mempercepat bagian penting.]

> “Saya akan mendemonstrasikan aplikasi PadiCare pada [perangkat dan versi Android]. Ini adalah beranda aplikasi. Di sini ada tombol ‘Mulai Deteksi Daun’, Panduan Foto, Informasi Penyakit, dan Tentang PadiCare. Saya buka Panduan Foto terlebih dahulu. Panduan ini membantu pengguna memotret satu daun dengan pencahayaan yang cukup dan fokus yang jelas.
>
> Sekarang saya kembali ke beranda dan menekan ‘Mulai Deteksi Daun’. Aplikasi menampilkan pilihan kamera dan galeri, tetapi kamera pada versi ini belum bisa digunakan. Karena itu saya memilih foto daun yang sudah tersimpan melalui galeri. Foto muncul pada halaman pratinjau, sehingga saya dapat memeriksanya sebelum dianalisis. Saya memastikan satu helai daun terlihat cukup dekat, fokus, dan tidak tertutup bayangan. Jika salah memilih foto atau kualitasnya kurang baik, saya dapat menggantinya tanpa memulai aplikasi dari awal.
>
> Saya lanjutkan ke analisis. Hasil yang tampil untuk foto ini adalah [kelas yang benar-benar tampil], dengan skor model [skor yang benar-benar tampil]. Skor ini menunjukkan keluaran model untuk gambar ini, bukan jaminan bahwa hasilnya selalu benar. Halaman hasil memberi penjelasan singkat dan mengingatkan bahwa ini adalah pemeriksaan awal. Informasi ini perlu dibandingkan lagi dengan kondisi tanaman di lahan. Jika ada gejala yang tidak sesuai atau kerusakan terlihat meluas, pengguna tetap perlu meminta pendapat petugas penyuluh. [Tampilkan foto ulang atau contoh kedua yang benar-benar diuji.] Dari sini saya dapat mengulangi pemeriksaan dengan gambar lain. Saya sengaja memperlihatkan bahwa aplikasi menerima foto baru, bukan hanya menampilkan satu hasil yang sudah disiapkan sebelumnya.
>
> [Jika mode pesawat sudah diuji: Saya juga menguji fungsi ini saat mode pesawat aktif. Analisis tetap berjalan di Android karena model tersimpan di perangkat.] [Jika belum: Uji mode pesawat belum selesai, sehingga kemampuan offline penuh masih kami catat sebagai hal yang perlu dibuktikan.]”

### 8:30–11:10 | Demo B — jika model belum terintegrasi

**Pilih bagian ini bila aplikasi masih berupa prototipe antarmuka saat rekaman.**

[Tampilkan beranda → Panduan Foto → Informasi Penyakit → Tentang → pilihan sumber foto. Jelaskan kamera belum berfungsi. Coba galeri dan pratinjau hanya jika benar-benar berjalan. Jangan menayangkan mockup hasil sebagai prediksi aplikasi.]

> “Saya akan mendemonstrasikan bagian PadiCare yang sudah dapat ditunjukkan pada [perangkat atau platform demo]. Dari beranda terlihat tombol utama, panduan, informasi penyakit, dan halaman Tentang. Saya membuka Panduan Foto terlebih dahulu. Di halaman ini pengguna diberi arahan untuk memotret satu daun dengan jelas. Lalu saya membuka Informasi Penyakit, yang berisi penjelasan umum mengenai gejala visual dan langkah pengamatan. Halaman Tentang menjelaskan tujuan aplikasi dan batas hasilnya.
>
> Sekarang saya menekan ‘Mulai Deteksi Daun’. Aplikasi menampilkan pilihan kamera atau galeri, tetapi fungsi kamera belum berjalan pada versi demo ini. Karena itu saya tidak menampilkan pengambilan foto langsung. [Jika galeri berhasil: Saya memilih foto yang sudah tersimpan melalui galeri. Foto tampil pada halaman pratinjau dan dapat diganti jika kurang jelas.] [Jika galeri belum berhasil: Pemilihan foto dari galeri dan pratinjau juga masih dalam perbaikan, sehingga alur input foto belum kami nyatakan selesai.]
>
> Pada versi yang direkam ini, model MobileNetV3 belum selesai diintegrasikan ke aplikasi. Karena itu PadiCare masih kami sebut prototipe antarmuka. Kami tidak menampilkan skor atau nama penyakit tiruan sebagai hasil analisis. Jika model belum tersedia, aplikasi harus menyampaikan kendala tersebut secara jelas. Ini juga menjadi alasan mengapa tampilan contoh hasil dari Stitch tidak kami jadikan bukti bahwa sistem sudah mampu mengklasifikasikan daun. Tampilan tersebut hanya menjelaskan bagaimana informasi akan disajikan setelah prediksi nyata tersedia.
>
> Tahap berikutnya adalah menyelesaikan audit dataset, pelatihan, evaluasi, konversi ke TensorFlow Lite, dan uji prediksi nyata pada Android. Kami juga perlu memastikan foto yang masuk diproses dengan cara yang sama seperti data saat model dilatih. Sesudah itu barulah kami dapat menilai apakah hasilnya cukup konsisten untuk didemonstrasikan sebagai fungsi deteksi awal. [Tunjukkan kembali layar utama atau status kendala yang benar-benar ada.]”

### 11:10–12:15 | Pengujian dan keterbatasan

[Tampilkan hasil `flutter analyze`, `flutter test`, APK debug, dan tabel pengujian terbaru.]

> “Kami memeriksa hasil implementasi dengan analisis kode dan tes. Pada pemeriksaan yang telah dilakukan, `flutter analyze` tidak menemukan masalah, enam tes antarmuka dan model data lulus, dan APK debug berhasil dibuat. Tes tersebut membuktikan sebagian tampilan, navigasi, serta konsistensi status data. Tes itu belum membuktikan ketepatan klasifikasi penyakit. Uji kamera juga belum lulus karena kamera belum dapat digunakan pada versi demo.
>
> [Jika model siap: Pengujian model pada data uji menunjukkan [metrik dan jumlah sampel yang dapat dibuktikan]. Kami juga mencatat contoh prediksi yang salah agar batas model terlihat.] [Jika belum: Pengujian akurasi klasifikasi, foto lapangan, dan kemampuan offline penuh masih belum selesai.] Kami membedakan hasil yang sudah diuji dari fitur yang baru dirancang atau dibuat.”

### 12:15–13:00 | Kesimpulan

[Tampilkan ringkasan status dan logo/beranda PadiCare, lalu nama anggota.]

> “Sebagai kesimpulan, PadiCare adalah upaya membuat pemeriksaan awal gejala visual daun padi lebih mudah diakses melalui aplikasi mobile. Kelompok kami sudah menyusun PRD, rancangan sistem dan antarmuka, serta fondasi aplikasi Flutter. [Jika model siap: Model yang terintegrasi dapat menghasilkan dugaan kelas pada Android, dengan batas sesuai hasil pengujian kami.] [Jika belum: Integrasi model masih menjadi pekerjaan lanjutan, jadi hasil saat ini belum kami klaim sebagai aplikasi deteksi penyakit yang selesai.]
>
> Pengembangan berikutnya berfokus pada perbaikan kamera, mutu dataset, pengujian dengan foto dari berbagai kondisi lapangan, perbaikan kesalahan model, dan penyempurnaan pengalaman pengguna. Terima kasih sudah menyimak laporan kelompok kami.”

---

## Checklist akhir kelompok

1. Ganti semua `[nama]`, `[perangkat]`, `[sumber]`, `[jumlah]`, dan `[metrik]` dengan data yang benar. Hapus pilihan yang tidak dipakai.
2. Pilih hanya Demo A **atau** Demo B. Kamera tidak didemonstrasikan sebagai fitur yang berhasil. Gunakan galeri hanya jika sudah diuji. Versi Chrome dapat menunjukkan UI, tetapi tidak membuktikan inferensi TFLite Android.
3. Jalankan ulang `flutter analyze` dan `flutter test` setelah perubahan kode terakhir; sesuaikan narasi jika hasilnya berubah.
4. Pastikan setiap anggota berbicara sesuai pembagian waktu, lalu latihan bersama dengan stopwatch. Jeda perpindahan layar sudah diperhitungkan dalam durasi ±13 menit.
