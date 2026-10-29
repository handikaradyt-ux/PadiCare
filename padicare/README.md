# PadiCare

PadiCare adalah aplikasi Flutter Android untuk pemeriksaan awal kondisi daun padi dari satu foto. Inferensi berjalan di perangkat dengan TensorFlow Lite, tanpa akun atau koneksi internet. Hasilnya adalah dugaan visual, bukan diagnosis pasti.

## Cakupan model

Model MobileNetV3 mendukung lima label: `bacterial_leaf_blight` (hawar daun bakteri), `brown_spot` (bercak cokelat), `leaf_blast` (blas daun), `normal` (daun tampak sehat), dan `tungro` (tungro). Ambang hasil belum meyakinkan adalah 0,65. Model tertutup ini masih dapat memberi skor tinggi pada penyakit di luar lima label tersebut; pengguna perlu memeriksa ulang dengan penyuluh pertanian bila gejala tidak sesuai.

## Alur aplikasi

Beranda → pilih kamera atau galeri → pratinjau → analisis lokal → hasil dan saran tindak lanjut. Halaman pendukung berisi panduan foto, informasi penyakit, bantuan izin, dan batasan aplikasi. Foto tidak dikirim ke server.

## Menjalankan proyek

1. Pasang Flutter dan Android SDK, lalu jalankan `flutter doctor`.
2. Dari folder `padicare`, jalankan `flutter pub get`.
3. Sambungkan perangkat Android atau gunakan emulator, lalu jalankan `flutter run`.
4. Untuk APK kandidat, jalankan `flutter build apk --release`. Hasilnya ada di `build/app/outputs/flutter-apk/app-release.apk`.

Mode `--release` pada konfigurasi saat ini masih ditandatangani dengan **debug key** untuk kebutuhan tugas, bukan sertifikat rilis produksi. Flutter Web belum didukung oleh pipeline inferensi native. iOS belum dibangun atau diuji.

## Verifikasi dan dokumen

- Tes unit dan widget: `flutter test --no-pub`.
- Analisis statis: `flutter analyze --no-pub`.
- Tes integrasi Android: `flutter test integration_test/app_inference_test.dart -d <device-id>` setelah perangkat/emulator tersedia.
- Spesifikasi model: `../docs/MODEL_SPECIFICATION.md`.
- Catatan progres: `../docs/PROGRESS.md`.
- Keterbatasan dan pekerjaan tertunda: `../docs/KNOWN_GAPS.md`.

Dataset citra mentah tidak disimpan dalam Git. Skrip pelatihan, metrik, model, dan label ada dalam folder `../ml/`. Kode sumber: https://github.com/handikaradyt-ux/PadiCare.
