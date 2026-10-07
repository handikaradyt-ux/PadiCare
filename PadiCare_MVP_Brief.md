# PadiCare MVP untuk video laporan 10 menit

## Tujuan

Buat prototipe Android bernama **PadiCare** yang memperlihatkan alur nyata: pengguna memilih atau memotret satu daun padi, melihat pratinjau, menjalankan klasifikasi di perangkat tanpa internet, lalu membaca dugaan kelas dan batas hasilnya. Dokumen acuan utama adalah `PRD_Deteksi_Dini_Penyakit_Daun_Padi_REVISI.docx` di folder ini.

Prototipe ini cukup untuk video laporan sekitar 10 menit. Kode Flutter dikerjakan dengan bantuan **Antigravity**; ChatGPT membantu meninjau rancangan, error, hasil model, pengujian, dan naskah video. Mahasiswa memeriksa serta menjelaskan semua hasil akhir.

## Cakupan minimum

1. Beranda dengan nama PadiCare, tujuan aplikasi, dan tombol mulai.
2. Pilih foto dari kamera atau galeri, izin akses, dan pratinjau foto.
3. Analisis **nyata** memakai model `.tflite` yang dilatih untuk kelas daun padi yang sudah ditetapkan. Jangan menampilkan hasil contoh sebagai prediksi nyata.
4. Halaman hasil: dugaan kelas, skor model, penjelasan singkat, tombol foto ulang, dan catatan bahwa hasil bukan diagnosis pasti.
5. Pesan yang jelas saat izin ditolak, foto gagal dibaca, model gagal dimuat, atau hasil belum meyakinkan.
6. Fungsi inti dapat dijalankan pada Android dalam mode pesawat.

**Di luar cakupan MVP:** akun, backend, database cloud, riwayat, splash screen, onboarding, banyak daun dalam satu foto, dan klaim akurasi lapangan yang belum diuji. Dukungan iOS hanya boleh diklaim setelah dibangun dan diuji pada iOS.

## Keputusan data yang harus dibuat sebelum integrasi model

- Kandidat dataset: Paddy Doctor. Usulan kelas awal: daun normal, brown spot, dan bacterial leaf blight, jika jumlah dan mutu foto serta izin penggunaannya memadai.
- Catat sumber, jumlah foto per kelas, label, serta cara memisahkan data latih, validasi, dan uji. Foto dari daun atau sesi pemotretan yang sama tidak boleh tersebar ke kelompok berbeda.
- Sisihkan foto sawah yang belum pernah dipakai melatih model untuk pengujian nyata.
- Simpan bersama model final: ukuran dan tipe input, urutan kanal warna, normalisasi, urutan label, serta contoh prediksi Python dan TFLite pada foto yang sama.
- Ambang untuk pesan "hasil belum meyakinkan" ditentukan dari evaluasi. Skor rendah tidak otomatis membuktikan bahwa gambar bukan daun padi.

## Urutan kerja singkat

| Tahap | Antigravity mengerjakan | Mahasiswa dan ChatGPT memeriksa | Bukti selesai |
|---|---|---|---|
| 1. Lingkungan | Diagnosis Flutter SDK; buat proyek `padicare`; jalankan proyek awal | Periksa hasil `flutter doctor`, `flutter --version`, perangkat Android, dan folder proyek | Aplikasi Flutter awal terbuka di ponsel atau emulator |
| 2. UI dan input | Beranda, kamera, galeri, izin, pratinjau, halaman hasil tanpa prediksi palsu | Cocokkan dengan PRD, periksa navigasi dan error | Foto dapat diambil/dipilih dan ditampilkan |
| 3. Model | Skrip persiapan data, pelatihan MobileNetV3, evaluasi, dan konversi TFLite | Periksa sumber data, label, confusion matrix, precision/recall, dan contoh salah | `model.tflite`, `labels.txt`, spesifikasi input, hasil evaluasi |
| 4. Integrasi | Jalankan TFLite di Flutter, cocokkan praproses dan label, tampilkan hasil | Bandingkan prediksi Python dan aplikasi pada foto sama | Prediksi nyata berjalan offline di Android |
| 5. Uji dan video | Perbaiki bug; buat APK release; bantu dokumentasi teknis | Uji mode pesawat, izin ditolak, foto buram, foto bukan daun, dan waktu respons | APK, tabel uji, tangkapan layar, video demo |

Lakukan satu tahap atau satu fitur per permintaan. Setelah setiap perubahan: lihat diff, jalankan `flutter analyze`, uji fitur di perangkat, lalu simpan commit Git jika hasilnya sudah benar. Jalankan `flutter test` untuk logika yang mempunyai perilaku jelas dan `flutter build apk --release` pada tahap akhir.

## Prompt pertama untuk Antigravity

> Saya mengerjakan tugas Mobile Programming. Nama aplikasi **PadiCare**. Baca `PadiCare_MVP_Brief.md` dan `PRD_Deteksi_Dini_Penyakit_Daun_Padi_REVISI.docx` dalam folder ini. Target pertama hanya menyiapkan lingkungan dan proyek Flutter Android bernama `padicare`. Periksa `flutter --version`, `flutter doctor`, perangkat yang tersedia, dan jelaskan setiap masalah lingkungan sebelum mengubah kode. Jika SDK siap, buat proyek, jalankan aplikasi awal, dan tampilkan struktur folder serta perintah yang dipakai. Jangan membuat fitur deteksi atau hasil prediksi tiruan pada tahap ini. Ringkas berkas yang berubah dan bukti bahwa proyek dapat dijalankan.

Catatan kondisi awal: saat pemeriksaan dari Codex, folder ini belum berisi proyek Flutter atau repositori Git, dan `flutter --version` tidak menghasilkan keluaran sebelum dihentikan. Diagnosis kondisi tersebut lebih dahulu; jangan menyatakan SDK berhasil sebelum perintahnya selesai.

## Prompt kedua setelah proyek awal berjalan

> Implementasikan hanya beranda PadiCare, tombol pilih kamera/galeri, penanganan izin, dan pratinjau satu foto. Buat antarmuka sederhana dalam bahasa Indonesia. Jangan menampilkan prediksi penyakit sampai model TFLite tersedia. Jalankan `flutter analyze`, jelaskan berkas yang diubah, dan berikan langkah uji manual di Android.

## Bahan video 10 menit

| Durasi | Isi |
|---|---|
| 0:00–1:00 | Masalah yang dihadapi petani dan tujuan PadiCare. |
| 1:00–2:00 | Pengguna, fitur inti, dan batas aplikasi dari PRD. |
| 2:00–3:30 | Sumber data, kelas penyakit, serta cara pelatihan dan evaluasi model. |
| 3:30–4:30 | Alur Flutter → praproses foto → TFLite → hasil. |
| 4:30–7:30 | Demo langsung: kamera/galeri, pratinjau, prediksi offline, dan foto ulang. |
| 7:30–8:30 | Bukti pengujian, termasuk satu contoh berhasil dan satu keterbatasan. |
| 8:30–9:15 | Cara ChatGPT dan Antigravity membantu, serta pemeriksaan yang dilakukan mahasiswa. |
| 9:15–10:00 | Kesimpulan, keterbatasan, dan pengembangan berikutnya. |

Jika model belum siap saat video harus dibuat, sebut aplikasi sebagai **prototipe antarmuka**, jangan menyebutnya sudah mampu mendeteksi penyakit. Untuk memenuhi judul dan tujuan PRD, prioritas akhir tetap satu alur prediksi nyata yang bekerja offline.
