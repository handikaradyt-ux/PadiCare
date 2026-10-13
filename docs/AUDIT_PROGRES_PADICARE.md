# Laporan Audit Progres Proyek PadiCare

Dokumen ini memuat audit objektif atas status pengerjaan proyek **PadiCare** per tanggal **13 Oktober 2026**. Pemeriksaan dilakukan tanpa mengubah kode, dataset, model, PRD, dokumen progres eksisting, serta tanpa menjalankan pelatihan model atau membuat build APK baru.

---

## 1. Ringkasan Singkat Status Proyek

Proyek PadiCare saat ini berada pada kondisi **implementasi inti selesai, namun berada dalam status uncommitted di Git dan memerlukan verifikasi kamera pada perangkat fisik sebelum rekaman video**. 

Pipeline machine learning (audit dataset Masud et al. PLOS ONE 2026, pelatihan MobileNetV3-Small, dan konversi ke TFLite 1.12 MB) telah selesai di Python. Aset model telah dimasukkan ke dalam proyek Flutter dan terintegrasi pada `ClassifierService`. Build release APK (`app-release.apk`, 68.09 MB) telah terbentuk dan terbukti memuat berkas model `.tflite` serta `labels.txt`. Seluruh 14 unit dan widget test lokal lulus (`flutter test --no-pub`).

Namun, terdapat dua kendala utama:
1. **Seluruh pekerjaan Tahap C sampai F belum di-commit ke Git** (Git repository berhenti pada commit Tahap B `28c4edb`), sehingga pekerjaan berisiko hilang jika terjadi operasi pembersihan repository.
2. **Fitur jepretan kamera langsung (`pickFromCamera()`) belum berfungsi pada demo** (hanya alur galeri dan injeksi berkas daun yang terbukti berjalan pada emulator).

---

## 2. Tabel Evaluasi Tahap A–F pada Roadmap

| Tahap | Deskripsi | Status Objektif | Bukti Nyata (Path / Perintah / Artefak) | Kekurangan yang Ditemukan | Langkah Berikutnya |
|---|---|---|---|---|---|
| **Tahap A** | Audit Lingkungan & Proyek | **Selesai dan Teruji** | • Flutter 3.47.2, Dart 3.13.2 (`C:\development\flutter`)<br>• Android SDK API 36, build-tools 36.0.0, `cmdline-tools/latest`<br>• Kompilasi awal sukses di commit `8156a36` | AVD `padicare_avd` saat ini tidak aktif dan tidak terdaftar di direktori profil pengguna. | Buat AVD baru atau gunakan HP fisik langsung via USB debugging. |
| **Tahap B** | Fondasi Aplikasi & UI 12 Layar | **Selesai dan Teruji (dengan catatan kamera)** | • Tema AgroSawah M3 di `padicare/lib/theme/app_theme.dart`<br>• 12 layar/status modular di `padicare/lib/screens/` dan `lib/widgets/`<br>• Tes navigasi lulus (commit `28c4edb`) | Fitur kamera langsung belum teruji/berfungsi di demo; hanya pemilih galeri yang siap. | Verifikasi penanganan kamera pada HP Android fisik. |
| **Tahap C** | Dataset & Model MobileNetV3 | **Dibuat tetapi Belum Ter-commit** | • Dataset 748 citra unik (Masud et al., CC-BY-4.0) di `ml/data/`<br>• Skrip `ml/audit_dataset.py` & `ml/train_mobilenetv3.py`<br>• Checkpoint master Keras: `ml/models/padicare_mobilenetv3.keras` (10.07 MB)<br>• Hasil evaluasi uji murni 61 citra: Akurasi 88.52%, Macro F1 0.8819 (`ml/models/evaluation_metrics.json`) | Seluruh folder `ml/` dan `dataset_sources/` berstatus *untracked* di Git. | Lakukan `git add ml/ dataset_sources/` dan simpan dalam commit resmi. |
| **Tahap D** | Konversi & Integrasi TFLite | **Dibuat tetapi Belum Ter-commit** | • Berkas TFLite: `padicare/assets/models/paddy_mobilenetv3.tflite` (1.12 MB / 1,172,360 bytes)<br>• Berkas label: `padicare/assets/models/labels.txt` (3 kelas)<br>• Spesifikasi tensor di `docs/MODEL_SPECIFICATION.md`<br>• Skrip `ml/compare_inference.py` membuktikan selisih skor Keras vs TFLite < 0.005<br>• Integrasi inferensi nyata di `padicare/lib/services/classifier_service.dart` | Berkas model dan perubahan kode integrasi belum di-commit ke Git. | Lakukan `git add padicare/assets/` dan commit perubahan `classifier_service.dart`. |
| **Tahap E** | Uji Aplikasi & Perbaikan | **Sebagian** | • `flutter analyze --no-pub`: 0 error (5 info lints pada test)<br>• `flutter test --no-pub`: 14/14 unit & widget test lulus (13/10/2026 11:56 WIB)<br>• Integration test `padicare/integration_test/app_inference_test.dart` pernah lulus 5/5 di emulator Android 16 API 36<br>• Log uji mode pesawat via ADB mencatat inferensi lokal berhasil offline | • Pengujian kamera langsung pada HP fisik belum pernah dilakukan.<br>• Integration test di emulator menggunakan injeksi citra aset, bukan interaksi UI kamera nyata. | Uji coba langsung di HP fisik dengan izin kamera aktif dan pengambilan foto nyata. |
| **Tahap F** | Rilis APK & Bahan Laporan | **Sebagian** | • Berkas APK rilis: `padicare/build/app/outputs/flutter-apk/app-release.apk` (68.09 MB / 71,395,050 bytes, dibuat 07/10/2026 21:57:17)<br>• Isi APK terverifikasi memuat `paddy_mobilenetv3.tflite` dan `labels.txt`<br>• Naskah video siap di `docs/NASKAH_VIDEO_PADICARE_10_MENIT.md` dan `docs/NASKAH_VIDEO_PADICARE_13_MENIT_3_ORANG.md` | • Belum ada rekaman video riil.<br>• APK rilis dan naskah belum di-commit ke Git. | Lakukan commit Git, instal APK release ke HP fisik, dan lakukan rekaman video demo. |

---

## 3. Daftar Klaim yang Belum Terbukti atau Bertentangan

1. **Klaim Penyelesaian Commit Git pada `docs/PROGRESS.md`**:
   - *Klaim*: `docs/PROGRESS.md` mencatat seluruh Tahap C hingga F telah selesai.
   - *Fakta*: Riwayat commit Git berhenti pada commit `28c4edb` (Tahap B, 07/10/2026). Seluruh berkas machine learning, model TFLite, aset sampel, pengujian integrasi, dan pembaruan dokumen masih berstatus *untracked* atau *modified*.
2. **Klaim Pengujian Alur Kamera pada `docs/PROGRESS.md`**:
   - *Klaim*: Ringkasan Tahap B dan E menyebutkan *"alur kamera/galeri terverifikasi"*.
   - *Fakta*: Fitur pengambilan foto langsung dari kamera (`pickFromCamera()`) **belum berhasil pada demo**. Pada emulator, intent kamera tidak menghasilkan citra nyata. Pada perangkat fisik, belum ada catatan pengujian yang membuktikan kamera berfungsi. Pengujian yang berhasil hanya membuktikan pemilih galeri dan berkas daun contoh.
3. **Dokumen `docs/KNOWN_GAPS.md` yang Sudah Kedaluwarsa**:
   - *Klaim Dokumen*: `docs/KNOWN_GAPS.md` masih bertuliskan *"Status Terkini (Tahap B Selesai)"*, menyebutkan dataset belum diaudit, model belum dilatih, dan `ClassifierService` masih mengembalikan status dummy `modelLoadFailed`.
   - *Fakta*: Klaim tersebut sudah kedaluwarsa. Dataset sudah diaudit di `ml/audit_dataset.py`, model sudah dilatih di `ml/train_mobilenetv3.py`, dan `ClassifierService` sudah mengimplementasikan pemuatan TFLite nyata di kode lokal.
4. **Klaim Ketersediaan Emulator `padicare_avd`**:
   - *Klaim*: `docs/PROGRESS.md` mencatat AVD `padicare_avd` aktif dan tersedia.
   - *Fakta*: Saat audit dijalankan, `flutter emulators` mengembalikan *"No emulators available"*, direktori `C:\Users\ASUS\.android\avd\` kosong, dan tidak ada proses emulator yang berjalan di latar belakang.

---

## 4. Evaluasi Dataset dan Model Machine Learning

- **Sumber Dataset**: Masud et al., PLOS ONE 2026 / Project-AgML (`CC-BY-4.0`), citra sawah Bangladesh (musim Aman 2025, iPhone 12 Pro, 480x640 RGB).
- **Audit & Pembersihan Citra**:
  - Total record mentah: 773 citra.
  - Duplikat hash SHA-256 yang dihapus: 25 citra.
  - Total citra unik: 748 citra.
- **Distribusi Pembagian Citra (Stratified 70/15/15)** di `ml/data/`:
  - **Train (275 citra)**: Bacterial Leaf Blight (77), Brown Spot (127), Normal (71).
  - **Validation (59 citra)**: Bacterial Leaf Blight (17), Brown Spot (27), Normal (15).
  - **Test Murni (61 citra)**: Bacterial Leaf Blight (17), Brown Spot (28), Normal (16).
  - **Out-of-Scope (353 citra)**: Leaf Blast (133), Leaf Scald (107), Narrow Brown Spot (113) digunakan khusus untuk kalibrasi batas ketidakyakinan.
- **Metrik Evaluasi Data Uji Murni (61 citra)**:
  - **Akurasi**: **88.52%** (54 dari 61 prediksi benar).
  - **Macro F1-Score**: **0.8819**, Weighted F1: **0.8865**.
  - **Confusion Matrix**:
    - Bacterial Leaf Blight (17 sampel): 14 benar, 3 terprediksi Brown Spot, 0 Normal (Recall 82.35%, Precision 77.78%, F1 0.80).
    - Brown Spot (28 sampel): 26 benar, 2 terprediksi BLB, 0 Normal (Recall 92.86%, Precision 89.66%, F1 0.912).
    - Normal (16 sampel): 14 benar, 2 terprediksi BLB, 0 Brown Spot (Recall 87.50%, Precision 100.0%, F1 0.933).
  - Rata-rata confidence pada prediksi benar: **93.18%**.
- **Ambang Ketidakyakinan (Uncertainty Threshold)**:
  - Ditetapkan pada **0.60** berdasarkan evaluasi citra out-of-scope. Prediksi dengan confidence < 0.60 dipetakan ke status `DetectionStatus.inconclusive` ("Hasil Belum Meyakinkan").
- **Keberadaan Berkas Model**:
  - Master Keras: `ml/models/padicare_mobilenetv3.keras` (10.07 MB).
  - TFLite: `padicare/assets/models/paddy_mobilenetv3.tflite` (1.12 MB / 1,172,360 bytes).
  - Labels: `padicare/assets/models/labels.txt` (`bacterial_leaf_blight`, `brown_spot`, `normal`).
  - Input Tensor: `[1, 224, 224, 3]` float32 RGB dengan rentang nilai `[0.0, 255.0]`.
  - Output Tensor: `[1, 3]` float32 softmax.
- **Verifikasi Inferensi Keras vs TFLite**:
  - Skrip `ml/compare_inference.py` membuktikan probabilitas Keras dan TFLite memiliki selisih skor < 0.005 pada seluruh citra sampel verifikasi.

---

## 5. Evaluasi Aplikasi Flutter dan Batas Penggunaan di Chrome

- **Layar & Alur yang Tersedia**:
  - Tersedia 12 layar/status modular: Beranda Utama, Modal Pemilihan Sumber Foto, Panduan Foto Daun, Pratinjau Foto, Indikator Proses Analisis, Hasil Deteksi Penyakit (BLB dan Brown Spot), Hasil Daun Sehat (Normal), Hasil Belum Meyakinkan, 4 Varian Error (Izin Ditolak, Berkas Rusak, Model Gagal Dimuat, Analisis Gagal), Informasi Penyakit, dan Halaman Tentang PadiCare.
- **Alur Pemilihan Galeri & Pratinjau**:
  - Pemilihan berkas melalui galeri dan pratinjau foto berfungsi penuh pada Android.
- **Inferensi Nyata**:
  - Terintegrasi penuh pada Android melalui library `tflite_flutter` yang memuat model secara lokal dari aset aplikasi tanpa jaringan internet.
- **Batas Penggunaan di Chrome (Flutter Web)**:
  - **Aplikasi PadiCare TIDAK DAPAT menjalankan inferensi di browser Google Chrome / Flutter Web.**
  - Paket `tflite_flutter` bergantung pada binary C++ asli (`libtensorflowlite_c.so`) via `dart:ffi` serta pustaka `dart:io`. Keduanya tidak didukung di lingkungan web. Menjalankan aplikasi di Chrome akan memicu crash/kegagalan runtime pada service klasifikasi. PadiCare dirancang dan diwajibkan berjalan di Android.

---

## 6. Status Fitur Kamera

- **Status Tegas**: **Fitur kamera belum berhasil pada demo sebelumnya dan belum dapat dinyatakan berfungsi.**
- **Pemeriksaan Kode Sejak Demo**:
  - Berkas `padicare/lib/services/image_picker_service.dart` **tidak mengalami perubahan kode** sejak commit Tahap B (`28c4edb`).
- **Analisis Penyebab**:
  - **Pada Emulator Android**: Kegagalan disebabkan oleh lingkungan emulator (`padicare_avd`) yang dijalankan tanpa sensor kamera hardware atau tanpa konfigurasi kamera virtual (`hw.camera.back = virtualscene` / webcam). Pemanggilan intent kamera sistem mengembalikan status null/cancel atau gagal merender jendela jepretan foto.
  - **Pada HP Android Fisik**: Fitur kamera **belum pernah diuji**. Tidak ada catatan log, bukti pengujian, atau perangkat fisik yang terhubung via ADB selama sesi pengembangan.
- **Konsekuensi untuk Demonstrasi**:
  - Jangan mengklaim kamera berfungsi jika demonstrasi dilakukan di emulator. Demonstrasi di emulator harus menggunakan alur galeri dengan foto daun yang sudah disiapkan.

---

## 7. Status Pengujian Perangkat Lunak

Pemeriksaan pengujian dijalankan pada 13 Oktober 2026 pukul 11:56 WIB:

1. **Analisis Kode Statis (`flutter analyze --no-pub`)**:
   - Hasil: **0 error, 0 warning**.
   - Catatan: Terdapat 5 pesan informasi lints (`avoid_print`) khusus pada berkas pengujian `padicare/integration_test/app_inference_test.dart`. Kode produksi (`lib/`) bersih 100%. (Waktu eksekusi: 1.8 detik).
2. **Pengujian Unit & Widget (`flutter test --no-pub`)**:
   - Hasil: **14 dari 14 tes lulus (100% pass)**. (Waktu eksekusi: 14 detik).
   - Rincian tes:
     - `test/classifier_service_test.dart` (2 tes): Validasi penanganan error berkas tidak ada dan berkas rusak.
     - `test/ui_flow_inference_test.dart` (5 tes): Verifikasi tampilan Pratinjau, transisi status analisis, dan layar Hasil Belum Meyakinkan (memastikan tidak ada badge palsu "skor tinggi").
     - `test/widget_test.dart` (7 tes): Verifikasi navigasi ke Panduan Foto, Info Penyakit, Tentang PadiCare, serta konsistensi logika domain `DiseaseInfo` dan `DetectionResult`.
3. **Integration Test di Emulator**:
   - Pernah dijalankan pada sesi sebelumnya di emulator Android 16 (Pixel 6, API 36). Seluruh 5 skenario lolos (BLB latensi 1454 ms, Brown Spot latensi 2587 ms, Normal latensi 983 ms, Out-of-Scope handling, dan Missing image error). Tes ini menggunakan injeksi citra aset, bukan kamera langsung. Saat ini emulator tidak aktif sehingga tes tidak diulang.
4. **Pengujian di HP Android Fisik**:
   - **Belum dilakukan** (perangkat fisik belum dihubungkan).
5. **Pengujian Mode Pesawat (Offline)**:
   - Terbukti lulus pada emulator via perintah `adb shell cmd connectivity airplane-mode enable`; inferensi tetap berjalan lokal tanpa koneksi data/WiFi.

---

## 8. Verifikasi Berkas APK Debug dan Release

Berdasarkan pemeriksaan fisik berkas di `padicare/build/app/outputs/flutter-apk/`:

1. **APK Debug (`app-debug.apk`)**:
   - Ukuran: 143.52 MB (150,492,104 bytes).
   - Waktu modifikasi: 07/10/2026 21:44:56.
2. **APK Release (`app-release.apk`)**:
   - Ukuran: **68.09 MB (71,395,050 bytes)**.
   - Waktu pembuatan: 07/10/2026 21:57:17.
   - **Verifikasi Konten APK Release**:
     Pemeriksaan isi arsip APK mengonfirmasi bahwa APK release **benar-benar memuat model dan aset terbaru**:
     - `assets/flutter_assets/assets/models/paddy_mobilenetv3.tflite` (1,172,360 bytes).
     - `assets/flutter_assets/assets/models/labels.txt` (43 bytes).
     - `assets/flutter_assets/assets/sample_leaves/sample_blb.jpg` (99,304 bytes).
     - `assets/flutter_assets/assets/sample_leaves/sample_brown_spot.jpg` (103,242 bytes).
     - `assets/flutter_assets/assets/sample_leaves/sample_normal.jpg` (158,685 bytes).
     - `assets/flutter_assets/assets/sample_leaves/sample_blast.jpg` (134,097 bytes).

---

## 9. Kesiapan Naskah Video Demonstrasi (10 Menit & 13 Menit)

- **Keputusan Pilihan Skenario Demo**:
  - **Gunakan DEMO A dengan penegasan bahwa input foto menggunakan GALERI (bukan kamera langsung).**
  - **Alasan**: Model MobileNetV3 TFLite, praproses tensor RGB 224x224, pemetaan 3 label, dan skor inferensi nyata sudah terbukti berjalan di Android (bukan mockup/dummy). APK release sudah memuat model nyata. Tidak perlu memakai Demo B (prototipe antarmuka tanpa model) karena modelnya sudah berfungsi.
- **Daftar Fitur yang AMAN Didemonstrasikan**:
  1. Halaman Beranda baru dengan indikator status lokal on-device.
  2. Pembukaan halaman pendukung: Panduan Pengambilan Foto, Informasi Penyakit Padi, dan Halaman Tentang PadiCare & Batasan Sistem.
  3. Alur deteksi daun: tombol "Mulai Deteksi Daun" -> pemilihan modal sumber foto -> **pemilihan foto dari galeri**.
  4. Halaman Pratinjau Foto dengan kemampuan mengganti foto jika tidak sesuai.
  5. Proses inferensi on-device nyata dengan indikator memuat (latensi ~1–2 detik).
  6. Halaman Hasil Deteksi nyata:
     - Hawar Daun Bakteri (BLB) dengan skor model nyata.
     - Bercak Cokelat (Brown Spot) dengan skor model nyata.
     - Daun Sehat (Normal) dengan skor model nyata.
     - Hasil Belum Meyakinkan (jika citra tidak jelas atau skor < 0.60).
  7. Penjelasan tegas bahwa skor adalah "Skor Model" keluaran klasifikasi, bukan kepastian diagnosis mutlak.
  8. Kemampuan berjalan dalam kondisi Mode Pesawat (100% offline tanpa cloud backend).
- **Daftar yang BELUM BOLEH Diklaim / Harus Dijelaskan Secara Jujur**:
  1. **JANGAN mengklaim kamera langsung sudah bekerja sempurna**. Jika opsi kamera disorot, jelaskan secara jujur bahwa integrasi sensor kamera perangkat masih menjadi pekerjaan penyempurnaan berikutnya, sehingga demo menggunakan foto galeri.
  2. **JANGAN mengklaim aplikasi dapat mendeteksi semua jenis penyakit padi**. Tegaskan bahwa model terbatas pada 3 kelas latih (`bacterial_leaf_blight`, `brown_spot`, `normal`).
  3. **JANGAN mengklaim aplikasi diuji di iOS atau Chrome**.
  4. **JANGAN menyebut hasil analisis sebagai diagnosis definitif**; selalu sebut sebagai dugaan awal berbasis pola visual.

---

## 10. Daftar Berkas yang Belum Tersimpan dalam Commit Git

Seluruh pekerjaan berikut saat ini **berisiko hilang** jika terjadi perintah pembersihan Git (`git clean` atau `git reset`):

### A. Berkas Terlacak yang Mengalami Modifikasi (Modified)
1. `docs/PROGRESS.md`
2. `padicare/lib/services/classifier_service.dart`
3. `padicare/pubspec.yaml`
4. `padicare/pubspec.lock`

### B. Berkas dan Direktori Baru yang Belum Terlacak (Untracked)
1. `dataset_sources/` (repositori dataset alternatif aldrin233)
2. `docs/AUDIT_INSTALASI_ANTIGRAVITY.md`
3. `docs/AUDIT_PROGRES_PADICARE.md`
4. `docs/MODEL_SPECIFICATION.md`
5. `docs/NASKAH_VIDEO_PADICARE_10_MENIT.md`
6. `docs/NASKAH_VIDEO_PADICARE_13_MENIT_3_ORANG.md`
7. `docs/Naskah_Video_PadiCare_13_Menit_3_Orang.docx`
8. `ml/` (seluruh folder machine learning: `audit_dataset.py`, `train_mobilenetv3.py`, `compare_inference.py`, `dataset_audit.json`, `ml/data/` [748 citra], dan `ml/models/` [Keras master model & TFLite])
9. `padicare/assets/` (`paddy_mobilenetv3.tflite`, `labels.txt`, dan folder `sample_leaves/`)
10. `padicare/integration_test/app_inference_test.dart`
11. `padicare/test/*.png` (12 tangkapan layar verifikasi visual)
12. `padicare/test/classifier_service_test.dart`
13. `padicare/test/ui_flow_inference_test.dart`

---

## 11. Prioritas Tindakan Berikutnya (Berdasarkan Kepentingan Video & Laporan)

1. **Prioritas 1 — Amankan Perubahan ke dalam Git Commit**:
   - Seluruh implementasi ML, TFLite, integrasi kode, aset, dan dokumen naskah video harus segera di-commit agar tidak ada risiko kehilangan data.
2. **Prioritas 2 — Sinkronkan Dokumen `KNOWN_GAPS.md`**:
   - Perbarui `docs/KNOWN_GAPS.md` agar mencerminkan kondisi riil terkini (menghapus status kedaluwarsa Tahap B, mendokumentasikan batasan 3 kelas model, dan mencatat status fitur kamera).
3. **Prioritas 3 — Uji dan Verifikasi Kamera di HP Android Fisik (Bila Memungkinkan)**:
   - Hubungkan HP Android fisik via USB debugging, pasang APK release, dan uji apakah tombol kamera dapat mengambil foto daun secara langsung. Jika berhasil, kamera dapat dimasukkan ke dalam rekaman video; jika tidak, gunakan alur galeri sesuai skenario aman.
4. **Prioritas 4 — Siapkan Bahan Foto Galeri di Perangkat Uji**:
   - Salin foto contoh daun padi (BLB, Brown Spot, Normal, dan daun buram/out-of-scope) ke galeri perangkat yang akan digunakan untuk merekam video demonstrasi.
5. **Prioritas 5 — Lakukan Rekaman Video Demonstrasi Mengikuti Naskah**:
   - Gunakan skenario Demo A pada `docs/NASKAH_VIDEO_PADICARE_10_MENIT.md` atau `docs/NASKAH_VIDEO_PADICARE_13_MENIT_3_ORANG.md` dengan durasi dan pembagian tugas yang telah ditetapkan.

---

## 12. Kesimpulan Tegas

Secara arsitektur dan fungsionalitas komputasi lokal, **PadiCare saat ini SUDAH MEMILIKI mesin inferensi offline nyata berbasis MobileNetV3 dan TensorFlow Lite yang terbukti berjalan di Android (bukan lagi sekadar prototipe antarmuka)**. Akurasi model pada data uji murni mencapai 88.52% dan APK rilis telah selesai dibangun secara mandiri.

Namun demikian, **aplikasi belum dapat dinyatakan selesai 100% dan teruji penuh di lapangan** karena:
1. Fitur pengambilan foto langsung dari kamera fisik belum terverifikasi secara nyata pada demo.
2. Seluruh implementasi Tahap C hingga F masih berstatus *uncommitted* di sistem kontrol versi Git.

Untuk kebutuhan laporan dan video demonstrasi saat ini, aplikasi **sangat layak dan siap didemonstrasikan menggunakan alur pemilihan foto galeri offline**, dengan secara jujur menyampaikan bahwa integrasi kamera fisik langsung masih dalam proses penyempurnaan perangkat keras.
