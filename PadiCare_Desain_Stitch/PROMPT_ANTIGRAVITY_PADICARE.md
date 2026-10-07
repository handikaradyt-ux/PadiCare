# Prompt utama untuk Antigravity

Salin seluruh bagian mulai dari **MULAI PROMPT** sampai **AKHIR PROMPT** ke Antigravity. Jalankan Antigravity dengan folder kerja `C:\SEMESTER 5\MOBILE PROGRAMMING\T`. Prompt ini bisa digunakan sebagai tugas utama; kemajuan dan kekurangan berikutnya dapat dimasukkan melalui bagian **Format permintaan update** di bawah.

---

## MULAI PROMPT

Saya mengerjakan proyek mata kuliah Mobile Programming bernama **PadiCare**. Bangun aplikasi Flutter Android yang membantu pemeriksaan awal gejala penyakit pada **satu foto daun padi** melalui klasifikasi MobileNetV3 dan TensorFlow Lite di perangkat. Saya akan memakainya untuk laporan dan video demonstrasi sekitar 10 menit. Kerjakan proyek secara bertahap dari pemeriksaan lingkungan sampai APK dan dokumentasi, dengan hasil yang dapat dijalankan dan diverifikasi. Berikan laporan ringkas setiap tahap, lalu lanjutkan ke tahap berikutnya jika tidak ada penghalang nyata. Jangan menyatakan tahap selesai hanya karena kode sudah ditulis.

### 1. Baca acuan dan tentukan batas kerja

- Periksa isi folder kerja sebelum membuat atau mengubah berkas. Jangan menimpa hasil yang sudah ada tanpa memeriksanya.
- Baca `PRD_Deteksi_Dini_Penyakit_Daun_Padi_REVISI.docx`, `PadiCare_MVP_Brief.md`, dan `PadiCare_Desain_Stitch/README.md`.
- Periksa semua `screen.png`, `code.html`, dan `agrosawah_material_system/DESIGN.md` di `PadiCare_Desain_Stitch/stitch_padicare_flutter_app_ui_design/`. Gunakan gambar dan HTML sebagai referensi visual; implementasikan ulang dengan widget Flutter Material 3, bukan WebView atau salinan HTML/Tailwind.
- Bila dokumen bertentangan, pertahankan tujuan PRD dan batas MVP. Daftar kelas, skor, akurasi, dan isi penyakit harus mengikuti model serta sumber yang benar-benar tersedia. Desain Stitch hanya contoh tampilan.
- Target yang wajib selesai adalah Android. Jangan mengklaim aplikasi teruji di iOS sebelum benar-benar membangun dan mengujinya di perangkat iOS.
- Saya **tidak memiliki emulator Android**. Gunakan `flutter run -d chrome` untuk iterasi UI dan alur pemilihan foto. Jika ada HP Android fisik, gunakan USB debugging untuk uji kamera, TFLite, mode pesawat, dan APK. Jangan menyamakan uji Chrome dengan uji Android.

### 2. Lingkup MVP dan alur pengguna

Alur inti: **Beranda → pilih Kamera/Galeri → bantuan izin bila perlu → pratinjau satu foto → analisis lokal → hasil penyakit / daun tampak sehat / belum meyakinkan → periksa foto lain**. Dari hasil penyakit, pengguna dapat membuka informasi penyakit. Panduan foto dan Tentang PadiCare dapat diakses dari Beranda. Kesalahan harus menampilkan langkah pemulihan yang sesuai.

Bangun 12 layar/status berdasarkan indeks di README, tetapi gunakan komponen ulang agar kode tetap sederhana. Prioritaskan alur kamera/galeri, pratinjau, inferensi nyata, hasil, dan error. Jangan menambah login, akun, cuaca, lokasi sawah, petak tanaman, backend, cloud, riwayat, chat, e-commerce, splash screen, atau onboarding wajib. Gunakan kamera dan pemilih galeri bawaan perangkat; tidak perlu membuat UI kamera khusus. Seluruh teks pengguna dalam bahasa Indonesia yang mudah dibaca di luar ruangan.

### 3. Koreksi wajib atas rancangan Stitch saat coding

- Layar 1 adalah **beranda baru**. Pada layar 2, ambil desain modal sumber foto saja dan tampilkan di atas beranda baru; abaikan cuaca, lokasi, petak, peringatan, dan klaim hama pada latar lama.
- Hasil sehat yang memperlihatkan `0.94` dan hasil penyakit yang berisi nilai contoh **tidak boleh menjadi hasil prediksi tetap**. Nilai, kelas, dan foto hasil harus berasal dari input dan keluaran model nyata. Sebelum model tersedia, tampilkan status bahwa analisis belum tersedia; jangan membuat prediksi tiruan untuk pengguna.
- Ubah istilah yang terlalu pasti seperti `DIAGNOSIS AWAL` menjadi `Pemeriksaan awal` atau `Dugaan hasil`. Tulis `Skor model`, bukan `akurasi diagnosis`. Sertakan catatan bahwa hasil bukan diagnosis pasti.
- Hapus `Fokus area bercak` dan `Kesesuaian Pola Tinggi` jika model hanya melakukan klasifikasi dan tidak menghasilkan lokasi bercak atau penjelasan visual.
- Ubah badge `Siap Dianalisis` menjadi `Foto dipilih`, kecuali ada pemeriksaan kualitas foto yang sungguh diimplementasikan.
- Pada halaman Tentang, jangan menjanjikan semua gejala di luar kelas otomatis terdeteksi sebagai `Hasil Belum Meyakinkan`. Jelaskan bahwa model terbatas pada kelas latih dan dapat salah pada foto di luar cakupan. Hapus klaim kerja bersama tim agronomis kecuali benar ada bukti. Jangan mengklaim pemrosesan `100% di RAM` jika file sementara kamera/galeri masih digunakan. Klaim offline dan tanpa unggahan harus sesuai implementasi dan hasil uji.
- Layar 10 adalah contoh empat **varian error**, bukan menu simulasi untuk pengguna. Tampilkan dialog atau halaman yang tepat secara otomatis ketika izin ditolak, foto rusak/tidak terbaca, model gagal dimuat, atau inferensi gagal.
- Informasi penyakit hanya untuk kelas final yang benar-benar didukung model. Semua gejala dan tindak lanjut perlu sumber pertanian yang diperiksa; bila belum diverifikasi, tampilkan informasi umum yang aman atau tandai sebagai pekerjaan tertunda. Jangan memberi dosis atau merek pestisida.
- Jangan hardcode jarak foto `10–15 cm` sebagai syarat teknis. Pakai panduan sederhana: satu daun, terang merata, fokus jelas.
- Gambar dan font pada HTML Stitch mungkin berasal dari URL internet. Gunakan aset lokal berlisensi jelas atau ikon Flutter. Aplikasi inti harus bekerja dalam mode pesawat.

### 4. Tahap pengerjaan dan bukti selesai

**Tahap A — Audit lingkungan dan proyek.** Jalankan `flutter --version`, `flutter doctor -v`, `flutter devices`, dan periksa Android SDK, Chrome, HP Android fisik bila tersambung, serta struktur folder. Tidak ada emulator; jangan menunggu emulator untuk memulai. Jika belum ada proyek, buat proyek Flutter `padicare` tanpa mengubah dokumen acuan. Catat versi SDK, platform uji, dan masalah lingkungan. Jalankan aplikasi awal di Chrome untuk memulai UI; jalankan juga di HP Android fisik bila tersedia. Jika Flutter/SDK gagal, jelaskan log penyebabnya dan langkah perbaikan yang dapat dilakukan; lanjutkan pekerjaan nonblokir.

**Tahap B — Fondasi aplikasi dan UI.** Buat tema Material 3 dengan warna utama `#133E26`, hijau pendukung `#2E7D32`, latar `#F7F9F5`, kartu putih, teks kontras, dan target sentuh minimal 48 dp. Tata letak harus nyaman pada lebar sekitar 360–412 dp. Buat navigasi, komponen, seluruh layar/status yang relevan, kamera/galeri, izin, dan pratinjau foto. Gunakan state yang eksplisit untuk kosong, memuat, sukses, belum meyakinkan, dan gagal. Jangan menampilkan prediksi sampel pada alur pengguna. Verifikasi navigasi dan galeri di Chrome. Pada Chrome desktop, `image_picker` dengan sumber kamera dapat membuka pemilih berkas, bukan webcam; bila demo webcam memang dibutuhkan, gunakan dukungan web dari paket `camera` secara khusus tanpa merusak alur kamera Android. Akses webcam browser memerlukan izin dan konteks aman seperti `localhost`. Untuk pratinjau lintas platform, baca byte `XFile` dan tampilkan dengan `Image.memory`, bukan selalu `Image.file`. Verifikasi kamera dan izin Android di HP fisik bila tersedia.

**Tahap C — Dataset dan model MobileNetV3.** Audit dataset kandidat seperti Paddy Doctor: URL sumber, izin penggunaan, label, jumlah per kelas, mutu gambar, duplikasi, dan kecocokan dengan foto daun. Tetapkan kelas final hanya setelah audit. Kandidat awal dari PRD adalah daun normal, brown spot, dan bacterial leaf blight; ini **bukan daftar kelas pasti**. Pisahkan train/validasi/uji sebelum augmentasi dan hindari foto dari daun atau sesi yang sama masuk ke kelompok berbeda. Gunakan transfer learning MobileNetV3 yang sesuai kemampuan mesin. Simpan skrip yang dapat dijalankan ulang, konfigurasi, seed, metadata data, evaluasi confusion matrix serta precision/recall per kelas, dan beberapa contoh kegagalan. Foto lapangan terverifikasi dipakai sebagai pengujian tambahan bila tersedia. Jangan mengarang akurasi atau hasil uji. Jika data/izin/komputasi tidak tersedia, catat penghalangnya secara spesifik dan lanjutkan bagian aplikasi yang tidak bergantung pada model.

**Tahap D — Konversi dan integrasi TFLite.** Konversi model final menjadi `.tflite`; simpan `labels.txt` dan dokumen spesifikasi input/output (ukuran, tipe tensor, RGB/BGR, normalisasi, urutan label, kuantisasi bila ada). Muat model sebagai aset lokal Flutter **untuk Android**. Paket `tflite_flutter` tidak mendukung web; pisahkan implementasi native dan status web melalui conditional import/abstraksi agar build Chrome tidak memuat kode FFI. Di Chrome, tampilkan pesan jujur bahwa analisis belum tersedia pada platform web, bukan hasil tiruan. Buat praproses Flutter Android yang sama dengan pipeline Python. Bandingkan keluaran Python dan TFLite/Flutter Android pada beberapa foto yang sama; laporkan selisih dan perbaiki jika label atau nilai tidak cocok. Gunakan skor model hanya sebagai skor keluaran, bukan kepastian diagnosis. Tentukan ambang `Hasil Belum Meyakinkan` dari evaluasi, bukan angka acak. Ambang skor rendah tidak membuktikan objek bukan daun padi.

**Tahap E — Uji aplikasi dan perbaikan.** Jalankan `flutter analyze` dan pengujian logika yang memang punya perilaku jelas, terutama urutan label, praproses, pemetaan hasil, dan error. Di Chrome, uji UI, responsif, galeri, dan webcam bila diimplementasikan. Di HP Android fisik bila tersedia, uji kamera, galeri, izin ditolak, foto gagal dibaca, model gagal, analisis gagal, foto buram, foto di luar cakupan, foto ulang, serta mode pesawat. Catat platform/perangkat, versi Android bila ada, model, waktu inferensi nyata, dan hasil setiap uji. Jika HP Android belum tersedia, tandai uji native serta klaim offline sebagai **belum terverifikasi**, walaupun APK berhasil dibangun. Bandingkan tampilan Flutter dengan 12 rancangan serta cek scroll, ukuran teks, kontras, dan tombol pada layar kecil. Perbaiki masalah penting. Jangan menandai prediksi salah sebagai berhasil.

**Tahap F — Rilis dan bahan laporan.** Jalankan build APK release setelah semua syarat inti terpenuhi. Simpan lokasi APK dan perintah build. Buat dokumentasi singkat: cara menjalankan proyek, arsitektur folder, sumber data/izin, kelas final, pipeline model, hasil evaluasi, batasan, tabel uji, dan daftar kekurangan. Siapkan urutan demonstrasi 10 menit berdasarkan fitur yang benar-benar berjalan. Bila model belum terintegrasi, sebut hasilnya prototipe antarmuka dan jangan membuat video yang mengaku sudah melakukan deteksi nyata.

### 5. Cara bekerja dan laporan setiap tahap

- Bekerja langsung di folder proyek dan menjaga berkas acuan tetap utuh. Pakai paket Flutter/Python yang kompatibel dengan SDK yang terpasang; periksa dokumentasi paket jika versinya berubah.
- Setelah setiap tahap, tulis: berkas yang dibuat/diubah, perintah yang dijalankan, hasil uji beserta bukti ringkas, kekurangan yang tersisa, dan tahap berikutnya. Pelihara `docs/PROGRESS.md` serta `docs/KNOWN_GAPS.md` agar update berikutnya bisa melanjutkan pekerjaan tanpa mengulang.
- Jika memakai Git, buat commit kecil setelah tahap yang berhasil. Jangan menghapus perubahan saya yang belum diperiksa.
- Pilih implementasi paling sederhana yang memenuhi PRD. Hindari dependensi, arsitektur, atau layanan tambahan tanpa alasan jelas.
- Lanjutkan sendiri bila keputusan teknis dapat dibuat dari bukti. Tanyakan saya hanya bila memerlukan dataset/izin yang tidak tersedia, perangkat/kredensial yang saya harus sediakan, atau keputusan yang sungguh mengubah lingkup proyek. Jika terhalang, kerjakan bagian lain yang tetap bisa diselesaikan.
- Akhiri dengan daftar status setiap tahap: selesai dan teruji, dibuat tetapi belum teruji, atau terhalang. Sertakan perintah untuk menjalankan aplikasi dan lokasi APK bila sudah ada. Jangan menyatakan seluruh proyek selesai sebelum inferensi nyata dan uji offline Android terbukti.

Mulai sekarang dengan **Tahap A**. Tunjukkan temuan lingkungan dan struktur proyek, lalu lanjutkan tahap berikutnya sesuai bukti yang tersedia.

## AKHIR PROMPT

---

## Format permintaan update nanti

Untuk perubahan setelah pengerjaan awal, kirim ke Antigravity:

> Lanjutkan proyek PadiCare berdasarkan `docs/PROGRESS.md`, `docs/KNOWN_GAPS.md`, PRD revisi, dan folder desain Stitch. Perubahan yang saya minta: **[tulis perubahan spesifik]**. Periksa implementasi dan tes yang ada sebelum mengubah kode. Pertahankan alur MVP yang sudah berjalan. Setelah selesai, jelaskan berkas yang berubah, hasil uji nyata, serta kekurangan yang masih terbuka. Jangan mengarang hasil model atau mengklaim fitur telah diuji jika belum ada bukti.
