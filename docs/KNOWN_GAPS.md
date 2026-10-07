# Daftar Kekurangan dan Pekerjaan Tertunda (Known Gaps) - PadiCare

Dokumen ini mencatat batasan teknis, item yang belum selesai, atau kendala yang memerlukan tindak lanjut.

## Status Terkini (Tahap B Selesai)

1. **Model Machine Learning (MobileNetV3 & TFLite)**:
   - Dataset daun padi (Paddy Doctor / Rice Leaf Disease) perlu diaudit sumber, lisensi, dan distribusinya.
   - Kelas final penyakit padi akan ditetapkan berbasis dataset nyata (kandidat acuan PRD: `brown_spot`, `bacterial_leaf_blight`, `normal`).
   - Skrip pelatihan Python transfer learning MobileNetV3, evaluasi confusion matrix & precision/recall, serta konversi `.tflite` dan `labels.txt` akan diselesaikan di Tahap C dan Tahap D.

2. **Inferensi Nyata di Flutter**:
   - `ClassifierService` saat ini mengembalikan status aman (`modelLoadFailed`) saat aset tflite belum ada di aplikasi, tanpa menampilkan hasil dummy/tiruan.
   - Setelah model `.tflite` dibuat di Tahap D, praproses tensor RGB 224x224 akan dihubungkan ke `tflite_flutter`.

3. **Pengujian Nyata di Emulator/Perangkat**:
   - UI dan navigasi telah teruji di emulator `emulator-5554` (Pixel 6, API 36).
   - Pengujian inferensi foto nyata, ambang batas ketidakyakinan, dan mode offline penuh akan dilakukan di Tahap E.
