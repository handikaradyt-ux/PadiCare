# Catatan Kemajuan Proyek PadiCare

Dokumen ini mencatat kemajuan per tahap, status verifikasi nyata, dan hasil pengujian terkini per **13 Oktober 2026**.

## Ringkasan Status Tahap

| Tahap | Deskripsi | Status | Catatan Verifikasi & Kondisi Nyata |
|---|---|---|---|
| **Tahap A** | Audit Lingkungan & Proyek | **Selesai dan Teruji** | Flutter 3.47.2, Dart 3.13.2, Android SDK API 36, `cmdline-tools/latest`, lisensi disetujui, proyek `padicare` aktif, kompilasi debug berjalan sukses. |
| **Tahap B** | Fondasi Aplikasi & UI 12 Layar | **Selesai dan Teruji (dengan catatan kamera)** | Tema AgroSawah M3 (`#133E26`), 12 layar/status modular, komponen teruji. Alur galeri berfungsi penuh. Alur kamera langsung telah diperbarui kodenya (izin, exception handling, `retrieveLostData`), tetapi pengujian pada HP fisik berstatus menunggu sambungan perangkat. |
| **Tahap C** | Dataset & Model MobileNetV3 | **Selesai dan Teruji** | Dataset Masud et al. (PLOS ONE 2026, CC-BY-4.0). 748 citra unik setelah audit & hapus 25 duplikat hash. Split 70/15/15 di `ml/data/`: Train 275, Val 59, Test murni 61. Akurasi data uji: **88.52%** (54/61 benar, Macro F1: 0.8819). Evaluasi out-of-scope 353 citra; ambang 0.60 membantu menyaring skor rendah, namun model closed-set masih memberi confidence tinggi pada lesi penyakit lain. |
| **Tahap D** | Konversi & Integrasi TFLite | **Selesai dan Teruji** | Model dikonversi ke TFLite dynamic range: `padicare/assets/models/paddy_mobilenetv3.tflite` (1.12 MB / 1,172,360 bytes). `labels.txt` (3 kelas). Spesifikasi tensor di `docs/MODEL_SPECIFICATION.md`. Komparasi Python vs TFLite identik (selisih skor < 0.005). Integrasi `ClassifierService` selesai dengan praproses RGB 224x224 float32. |
| **Tahap E** | Uji Aplikasi & Perbaikan | **Sebagian (Kamera Fisik Menunggu Pengujian)** | • `flutter analyze --no-pub`: **0 issues found**.<br>• `flutter test --no-pub`: **15/15 unit & widget tests lulus** (13/10/2026).<br>• Integration test emulator Android 16 (Pixel 6) lulus 5/5 dengan injeksi citra daun (BLB, Brown Spot, Normal, Out-of-Scope, Missing file).<br>• Uji offline mode pesawat terbukti berjalan di Android.<br>• **Pending**: Pengujian kamera langsung pada HP fisik belum dilakukan. |
| **Tahap F** | Rilis APK & Bahan Laporan | **Selesai dan Teruji** | • Fresh Release APK: `padicare/build/app/outputs/flutter-apk/app-release.apk` (**68.32 MB**, dibuat 13/10/2026 12:14 WIB).<br>• Terverifikasi memuat model TFLite, label, dan sampel daun.<br>• Naskah video siap di `docs/NASKAH_VIDEO_PADICARE_10_MENIT.md` dan `docs/NASKAH_VIDEO_PADICARE_13_MENIT_3_ORANG.md`. |

---

## Log Aktivitas Terkini (Pembaruan Pasca-Audit 13 Oktober 2026)

### Penyempurnaan Alur Kamera dan Ketahanan Aplikasi
1. **Pemulihan Data Kamera Hilang (`retrieveLostData`)**:
   - Menambahkan metode `retrieveLostData()` pada `ImagePickerService` untuk menangani skenario di mana sistem operasi Android menutup proses utama aplikasi akibat keterbatasan memori saat aktivitas kamera sistem berada di latar depan.
   - Mengintegrasikan pemanggilan `_checkLostData()` pada callback pasca-frame awal di `HomeScreenState.initState()`.
2. **Pemeriksaan Status Izin Kamera**:
   - Memperbarui `pickFromCamera()` agar memeriksa `Permission.camera.status` sebelum meminta ulang izin, menghindari glitch pada perangkat Android modern.
   - Menambahkan parameter `preferredCameraDevice: CameraDevice.rear` untuk memprioritaskan kamera belakang di lapangan.
   - Menambahkan penanganan spesifik `PlatformException` (misal `camera_access_denied`).
3. **Pemberian Penjaga `mounted`**:
   - Memperbaiki pemanggilan `setState` dan navigasi di `home_screen.dart` dan `preview_screen.dart` dengan memastikan `mounted == true` setelah operasi asinkron `SourcePickerSheet.show()` dan pemilihan gambar.
4. **Perbaikan Aksi Pemulihan (Smart Retry)**:
   - Pada `PreviewScreen`, tombol coba lagi pada `ErrorView` kini secara otomatis mengarahkan ke `_changePhoto()` jika jenis kendala adalah `imageReadFailed` atau `permissionDenied`, dan ke `_startAnalysis()` jika kendala adalah `inferenceFailed` atau `modelLoadFailed`.
5. **Konfigurasi Manifest & Info.plist**:
   - Menambahkan `<uses-feature android:name="android.hardware.camera.autofocus" android:required="false" />` di `AndroidManifest.xml`.
   - Menambahkan `NSCameraUsageDescription` dan `NSPhotoLibraryUsageDescription` di `ios/Runner/Info.plist`.
6. **Verifikasi Kualitas Kode & Kompilasi**:
   - `flutter analyze --no-pub`: 0 issues found.
   - `flutter test --no-pub`: 15/15 tests passed.
   - `flutter build apk --release`: Sukses menghasilkan build APK rilis berukuran 68.32 MB.
