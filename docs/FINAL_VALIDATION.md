# Dokumen Validasi Akhir Proyek PadiCare

Dokumen ini memuat matriks pemenuhan kebutuhan PRD, status implementasi dan verifikasi teknis, batas arsitektur model machine learning, serta protokol pengujian manual pada smartphone Android fisik.

---

## 1. Matriks Kebutuhan PRD & Status Pemenuhan

| Kebutuhan PRD / MVP Brief | Spesifikasi Teknis | Status Pemenuhan | Bukti Verifikasi / Catatan |
|---|---|---|---|
| **Input Satu Foto Daun** | Pengambilan citra satu daun padi via Kamera perangkat atau Galeri lokal | **Sebagian** | • Alur Galeri: **Teruji & Berfungsi**.<br>• Alur Kamera: **Kode Selesai**, **Menunggu pengujian di HP fisik** (emulator tidak memiliki kamera virtual). |
| **Pratinjau Foto** | Konfirmasi foto sebelum analisis dengan tombol ganti foto dan badge status | **Selesai dan Teruji** | `PreviewScreen` (`padicare/lib/screens/preview_screen.dart`), teruji di unit test & emulator. |
| **Inferensi On-Device Offline** | Klasifikasi lokal tanpa ketergantungan cloud, server luar, atau koneksi internet | **Selesai dan Teruji** | `ClassifierService` menggunakan `tflite_flutter` dan model `paddy_mobilenetv3.tflite` (1.12 MB). Teruji dalam mode pesawat. |
| **Klasifikasi 3 Kelas Target** | Mengenali Hawar Daun Bakteri (BLB), Bercak Coklat (Brown Spot), dan Daun Sehat (Normal) | **Selesai dan Teruji** | Model MobileNetV3-Small terlatih dengan akurasi 88.52% pada 61 sampel uji murni (`ml/models/evaluation_metrics.json`). |
| **Skor Model & Bukan Kepastian** | Menampilkan skor model keluaran probabilitas (bukan klaim akurasi aplikasi atau diagnosis mutlak) | **Selesai dan Teruji** | `ResultScreen` menampilkan badge *"Dugaan Hasil Pemeriksaan"*, *"Skor Model: XX.X%"*, dan catatan batasan. |
| **Ambang Belum Meyakinkan** | Menandai hasil jika skor model berada di bawah ambang batas | **Selesai dan Teruji** | Ambang batas empiris **0.60**; status `uncertain` menampilkan saran foto ulang tanpa badge skor palsu. |
| **Penanganan 4 Varian Error** | Error terpisah: Izin ditolak, Berkas rusak, Model gagal dimuat, dan Inferensi gagal | **Selesai dan Teruji** | Komponen modular `ErrorView` (`padicare/lib/widgets/error_view.dart`) dengan aksi pemulihan spesifik. |
| **Informasi Penyakit** | Penjelasan gejala visual, anjuran pengamatan umum, dan sumber rujukan pertanian | **Selesai dan Teruji** | `DiseaseInfoScreen` menyajikan data dari IRRI & Kementan tanpa dosis/merek pestisida kimia. |
| **Panduan Pengambilan Foto** | Petunjuk memotret satu daun, pencahayaan alami, kamera stabil, tanpa hardcode jarak | **Selesai dan Teruji** | `PhotoGuideScreen` (`padicare/lib/screens/photo_guide_screen.dart`). |
| **Halaman Tentang & Batasan** | Transparansi keterbatasan AI, privasi penyimpanan lokal, dan anjuran pendampingan PPL | **Selesai dan Teruji** | `AboutScreen` (`padicare/lib/screens/about_screen.dart`). |
| **Batasan MVP Ketat** | Tanpa akun, tanpa cloud database, tanpa riwayat otomatis, tanpa e-commerce/cuaca | **Terpenuhi 100%** | Tidak ada dependensi autentikasi, database cloud, atau fitur sekunder yang tidak relevan. |

---

## 2. Status Komponen: Rincian Kategori Kesiapan

### A. Sudah Diimplementasikan dan Lulus Tes Otomatis / Emulator
1. **Sistem Desain Material 3 AgroSawah**: Palet hijau `#133E26`, kartu permukaan putih `#FFFFFF`, kontras tinggi untuk kondisi sawah luar ruangan.
2. **Pustaka Model On-Device**: Model `assets/models/paddy_mobilenetv3.tflite` (1.12 MB) dan `assets/models/labels.txt`.
3. **Pipeline Praproses Citra Flutter**: Decode gambar -> crop/resize bilinear 224x224 -> normalisasi float32 RGB `[0.0, 255.0]`.
4. **Unit & Widget Tests (15/15 passed)**:
   - Validasi error handling berkas rusak/hilang.
   - Validasi threshold 0.60 dan urutan label.
   - Validasi transisi state UI Pratinjau, Hasil Sehat, Hasil Sakit, dan Hasil Belum Meyakinkan.
   - Validasi smoke navigation ke seluruh layar pendukung.
   - Validasi kontrak model `PickResult` dan `ImagePickerService`.
5. **Penanganan Aktivitas Android Mati (`retrieveLostData`)**: Sesi kamera yang sempat terputus oleh OS Android dipulihkan saat startup aplikasi.
6. **Guard Asinkron (`mounted`)**: Perlindungan sebelum pemanggilan `setState` dan navigasi.
7. **Arsip Rilis APK**: `padicare/build/app/outputs/flutter-apk/app-release.apk` (68.32 MB).

### B. Belum Diuji / Menunggu Pengujian di Smartphone Android Fisik
1. **Pengambilan Foto Kamera Langsung (`pickFromCamera()`)**:
   - Membuka aplikasi kamera bawaan perangkat OEM Android (Samsung, Xiaomi, Vivo, Oppo, Google Pixel).
   - Permintaan izin runtime kamera (`android.permission.CAMERA`).
   - Penangkapan file gambar resolusi penuh dari sensor kamera belakang fisik.
   - Penyerahan URI berkas foto kembali ke `PreviewScreen`.
2. **Responsivitas Perangkat Nyata**:
   - Pengukuran durasi decoding citra kamera asli (misal 12 MP/50 MP) dan latensi inferensi total (target PRD: ≤ 5 detik) pada hardware prosesor HP fisik.

---

## 3. Hasil Perintah Pengujian Terkini

### A. Analisis Statis Kode
```powershell
flutter analyze --no-pub
# Hasil: No issues found! (ran in 2.5s)
```

### B. Pengujian Unit & Widget
```powershell
flutter test --no-pub
# Hasil: 00:01 +15: All tests passed! (15/15 tests passed, ran in 14s)
```

### C. Kompilasi Release APK
```powershell
flutter build apk --release
# Hasil: Built build\app\outputs\flutter-apk\app-release.apk (68.3MB in 70.8s)
# Lokasi: C:\SEMESTER 5\MOBILE PROGRAMMING\T\padicare\build\app\outputs\flutter-apk\app-release.apk
# Ukuran persis: 71,640,842 bytes (68.32 MB)
# Waktu pembuatan: 13 Oktober 2026 12:14 WIB
```

---

## 4. Evaluasi Model Machine Learning dan Batasannya

### A. Metrik Evaluasi Data Uji Murni (61 Citra Lapangan Masud et al.)
- **Akurasi Total**: **88.52%** (54 benar, 7 salah dari 61 citra).
- **Macro Average F1**: **0.8819**, Weighted F1: **0.8865**.
- **Performa per Kelas**:
  - `bacterial_leaf_blight` (17 citra): Precision 77.78%, Recall 82.35%, F1 0.80.
  - `brown_spot` (28 citra): Precision 89.66%, Recall 92.86%, F1 0.912.
  - `normal` (16 citra): Precision 100.0%, Recall 87.50%, F1 0.933.
- **Rata-rata Skor Confidence Prediksi Benar**: **93.18%**.

### B. Keterbatasan Nyata Model (Out-of-Scope & Ambang 0.60)
1. **Perilaku Closed-Set Softmax**: Model hanya memiliki 3 neuron output probabilitas. Citra penyakit padi lain diuji empiris pada 353 sampel:
   - *Leaf Blast* (133 citra): 96 diprediksi Brown Spot, 35 BLB, 2 Normal (rata-rata confidence 95.22%).
   - *Leaf Scald* (107 citra): 73 diprediksi BLB, 34 Brown Spot (rata-rata confidence 90.39%).
   - *Narrow Brown Spot* (113 citra): 66 diprediksi Brown Spot, 47 BLB (rata-rata confidence 86.13%).
2. **Batas Ambang 0.60**: Ambang 0.60 efektif menyaring citra yang membingungkan bagi model (skor merata), namun **TIDAK MAMPU menolak semua penyakit di luar 3 kelas latih** karena lesi bercak lain memiliki fitur visual mirip yang memicu confidence tinggi.
3. **Konsekuensi Operasional**: Aplikasi wajib menegaskan bahwa hasil adalah **dugaan awal mandiri berdasarkan kemiripan pola visual**, bukan diagnosis agronomis pasti.

---

## 5. Protokol Pengujian Manual di HP Android Fisik

Saat smartphone Android fisik disambungkan via kabel USB:

### Langkah Persiapan
1. Aktifkan **Developer Options** dan centang **USB Debugging** pada HP Android.
2. Periksa keterbacaan perangkat di terminal:
   ```powershell
   & "C:\Users\ASUS\AppData\Local\Android\Sdk\platform-tools\adb.exe" devices
   ```
3. Pasang APK Release ke ponsel:
   ```powershell
   & "C:\Users\ASUS\AppData\Local\Android\Sdk\platform-tools\adb.exe" install -r "padicare\build\app\outputs\flutter-apk\app-release.apk"
   ```

### Tabel Skenario Uji Manual di Ponsel

| ID Skenario | Tindakan yang Diuji | Hasil yang Diharapkan | Status |
|---|---|---|---|
| **TC-01** | Buka aplikasi pertama kali -> Tekan "Mulai Deteksi Daun" -> Pilih "Ambil Foto (Kamera)" | Sistem Android memunculkan dialog runtime request izin kamera (*"While using the app"* / *"Only this time"*). | Menunggu HP Fisik |
| **TC-02** | Pilih *"Don't allow"* pada dialog izin kamera | Aplikasi menampilkan `PermissionHelpScreen` dengan tombol menuju Pengaturan Aplikasi tanpa crash. | Menunggu HP Fisik |
| **TC-03** | Izinkan akses kamera -> Buka kamera -> Tekan tombol shutter -> Konfirmasi centang (OK) | Aplikasi kamera tertutup, foto tampil penuh di `PreviewScreen` dengan badge *"Foto dipilih"*. | Menunggu HP Fisik |
| **TC-04** | Buka kamera -> Tekan tombol kembali / silang (Cancel) | Kamera tertutup, pengguna kembali ke `HomeScreen` tanpa pesan error rusak atau crash. | Menunggu HP Fisik |
| **TC-05** | Di `PreviewScreen`, tekan tombol "Ganti / Ambil Ulang Foto" | Muncul kembali modal pemilihan sumber, foto lama dapat diganti dengan foto baru. | Menunggu HP Fisik |
| **TC-06** | Tekan "Analisis Foto Daun" pada foto daun bercak coklat | Muncul layar indikator proses analisis (~1–3 detik) -> Berpindah ke `ResultScreen` menampilkan *"Bercak Cokelat"* dan skor model. | Menunggu HP Fisik |
| **TC-07** | Aktifkan **Mode Pesawat (Airplane Mode)** pada ponsel -> Lakukan pengujian analisis dari Galeri | Analisis tetap berlangsung normal dan menampilkan hasil 100% offline tanpa error koneksi. | Menunggu HP Fisik |
| **TC-08** | Ukur latensi inferensi total di `ResultScreen` | Waktu proses tercatat ≤ 5 detik pada antarmuka. | Menunggu HP Fisik |
