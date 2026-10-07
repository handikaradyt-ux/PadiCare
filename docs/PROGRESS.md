# Catatan Kemajuan Proyek PadiCare

Dokumen ini mencatat kemajuan per tahap, status verifikasi nyata, dan perintah yang digunakan.

## Ringkasan Status Tahap

| Tahap | Deskripsi | Status | Catatan Verifikasi |
|---|---|---|---|
| Tahap A | Audit Lingkungan & Proyek | **Selesai dan Teruji** | Flutter 3.47.2, Dart 3.13.2, Android SDK 36.0.0, cmdline-tools terpasang, lisensi disetujui, `flutter doctor` bersih, AVD `padicare_avd` dibuat & aktif, proyek `padicare` dibuat, `flutter analyze` 0 issue, build debug APK sukses (`app-debug.apk`). |
| Tahap B | Fondasi Aplikasi & UI 12 Layar | **Selesai dan Teruji** | Tema AgroSawah M3 (`#133E26`), 12 layar/status, komponen modular, alur kamera/galeri, 4 varian error, `flutter test` lolos 6/6, `flutter analyze` 0 issue, APK debug terpasang & diverifikasi di emulator `emulator-5554`. |
| Tahap C | Dataset & Model MobileNetV3 | Belum dimulai | Siap dikerjakan |
| Tahap D | Konversi & Integrasi TFLite | Belum dimulai | Menunggu Tahap C |
| Tahap E | Uji Aplikasi & Perbaikan | Belum dimulai | Menunggu Tahap D |
| Tahap F | Rilis APK & Bahan Laporan | Belum dimulai | Menunggu Tahap E |

---

## Log Aktivitas Tahap

### Tahap A — Audit Lingkungan dan Proyek
- **Tanggal/Waktu**: 2026-10-07
- **Perintah yang Dijalankan**:
  1. `flutter --version` -> Flutter 3.47.2, Dart 3.13.2, DevTools 2.60.0.
  2. `flutter doctor -v` -> Mengidentifikasi ketiadaan `cmdline-tools` dan lisensi SDK belum diterima.
  3. Pemasangan `cmdline-tools`: Mengunduh dan mengekstrak `commandlinetools-win-11076708_latest.zip` ke `C:\Users\ASUS\AppData\Local\Android\sdk\cmdline-tools\latest`.
  4. `flutter doctor --android-licenses` -> Semua lisensi Android SDK disetujui.
  5. `flutter doctor -v` -> Status bersih tanpa masalah (`• No issues found!`).
  6. Pembuatan AVD: `avdmanager create avd -n padicare_avd -k "system-images;android-36;google_apis_playstore;x86_64" --device "pixel_6" --force`.
  7. Peluncuran emulator: `emulator -avd padicare_avd -no-window -no-audio -no-boot-anim` -> `emulator-5554` aktif.
  8. Pembuatan proyek: `flutter create --org com.padicare --project-name padicare padicare`.
  9. Analisis kode: `flutter analyze` di `padicare` -> `No issues found!`.
  10. Verifikasi kompilasi Android: `flutter build apk --debug` di `padicare` -> Sukses menghasilkan `build\app\outputs\flutter-apk\app-debug.apk` (189.5s).
- **Hasil Uji & Bukti Ringkas**:
  - `flutter doctor -v`: 0 issue.
  - Kompilasi Gradle Android API 36 dan Java SE 20 berjalan tanpa error.
  - APK debug terbentuk di `padicare/build/app/outputs/flutter-apk/app-debug.apk`.
- **Kekurangan yang Tersisa**:
  - Implementasi UI 12 status layar dari rancangan Stitch dan alur kamera/galeri (Tahap B).
  - Penyiapan dataset daun padi dan pelatihan model MobileNetV3 (Tahap C).
- **Tahap Berikutnya**:
  - **Tahap B**: Implementasi tema Material 3 AgroSawah, komponen UI, navigasi, alur kamera/galeri, pratinjau foto, dan 4 penanganan error.

### Tahap B — Fondasi Aplikasi dan UI (12 Layar/Status)
- **Tanggal/Waktu**: 2026-10-07
- **Perintah yang Dijalankan**:
  1. Penambahan dependensi di `pubspec.yaml`: `image_picker: ^1.1.2`, `permission_handler: ^11.3.1`, `tflite_flutter: ^0.10.4`, `image: ^4.3.0`.
  2. Penyesuaian `android/build.gradle.kts` & `android/app/build.gradle.kts`: `compileSdk = 37`, resolusi dependensi `tensorflow-lite:2.14.0` untuk mencegah duplikasi namespace Android Gradle Plugin.
  3. Konfigurasi `kotlin.jvm.target.validation.mode=warning` di `android/gradle.properties` untuk kompatibilitas Java 20.
  4. Implementasi sistem desain AgroSawah Material 3 di `lib/theme/app_theme.dart` (`#133E26`, `#2E7D32`, `#F7F9F5`).
  5. Implementasi model domain: `lib/models/detection_result.dart` (state eksplisit tanpa hasil dummy), `lib/models/disease_info.dart` (informasi aman agronomi tanpa dosis pestisida).
  6. Implementasi widget modular: `lib/widgets/offline_badge.dart`, `lib/widgets/status_badge.dart`, `lib/widgets/source_picker_sheet.dart` (modal Layar 2), `lib/widgets/error_view.dart` (4 varian error Layar 10).
  7. Implementasi layar: `lib/screens/home_screen.dart` (Layar 1 beranda baru), `lib/screens/permission_help_screen.dart` (Layar 3), `lib/screens/photo_guide_screen.dart` (Layar 4), `lib/screens/preview_screen.dart` (Layar 5 & 6), `lib/screens/result_screen.dart` (Layar 7, 8, 9), `lib/screens/disease_info_screen.dart` (Layar 11), `lib/screens/about_screen.dart` (Layar 12).
  8. `flutter test` -> 6/6 test lolos (`widget_test.dart`).
  9. `flutter analyze` -> 0 issue found.
  10. `flutter install` & verifikasi visual tangkapan layar di emulator `emulator-5554`.
- **Hasil Uji & Bukti Ringkas**:
  - Seluruh alur UI 12 layar/status terverifikasi.
  - Tangkapan layar tersimpan: `home_screen.png`, `modal_sheet.png`, `guide_screen.png`, `disease_screen.png`, `about_screen.png`.
- **Kekurangan yang Tersisa**:
  - Model inferensi nyata MobileNetV3 TFLite belum terpasang (masih menggunakan fallback aman).
- **Tahap Berikutnya**:
  - **Tahap C**: Audit dataset padi, penetapan kelas final, pelatihan transfer learning MobileNetV3, dan evaluasi matriks.

