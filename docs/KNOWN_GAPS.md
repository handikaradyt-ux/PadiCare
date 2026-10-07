# Daftar Kekurangan dan Pekerjaan Tertunda (Known Gaps) - PadiCare

Dokumen ini mencatat batasan teknis, item yang belum selesai, atau kendala yang memerlukan tindak lanjut.

## Status Terkini (Tahap A Selesai)

1. **Emulator / Perangkat Android**:
   - AVD `padicare_avd` (API 36, Pixel 6, x86_64) sudah dibuat.
   - Perlu pengujian peluncuran emulator dan uji `flutter run` pada Android.
   - Jika emulator lambat di hardware pengguna atau akselerasi hardware terbatas, build APK dan pengujian pada perangkat fisik/emulator dapat disesuaikan.

2. **Model Machine Learning (MobileNetV3 & TFLite)**:
   - Dataset daun padi (misalnya Paddy Doctor) belum diaudit dan diunduh.
   - Kelas final penyakit padi belum ditetapkan (kandidat awal: daun normal, brown spot, bacterial leaf blight).
   - Skrip pelatihan, evaluasi (confusion matrix, precision/recall), dan konversi `.tflite` belum dibuat.

3. **UI / Komponen Flutter**:
   - 12 layar/status dari Stitch belum diimplementasikan di Flutter (akan dikerjakan di Tahap B).
   - Pengambilan gambar (kamera & galeri) dan penanganan izin belum diimplementasikan di `padicare`.
