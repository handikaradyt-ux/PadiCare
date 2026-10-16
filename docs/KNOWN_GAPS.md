# Daftar Keterbatasan dan Pekerjaan Tertunda (Known Gaps) - PadiCare

Dokumen ini mencatat batasan teknis riil, keterbatasan model, dan item pengujian yang memerlukan tindak lanjut setelah audit dan pembaruan kode per **13 Oktober 2026**.

---

## 1. Status Pengujian Kamera pada Perangkat Fisik (Pending Verification)

- **Kondisi Aktual**:
  - Penanganan kamera telah diperbarui di `padicare/lib/services/image_picker_service.dart` (termasuk pemeriksaan izin sebelum pemanggilan intent, `preferredCameraDevice: rear`, penanganan `PlatformException`, dan metode `retrieveLostData()` untuk pemulihan foto pasca-restart aktivitas oleh sistem Android).
  - Alur di `HomeScreen` dan `PreviewScreen` telah dipasangi penjaga status `mounted` dan pemulihan data kamera hilang saat inisialisasi.
  - Namun, **pengambilan foto kamera langsung pada smartphone Android fisik belum diuji** karena perangkat fisik belum disambungkan ke stasiun kerja.
  - Pada Android emulator tanpa sensor kamera virtual, intent kamera sistem gagal menghasilkan jepretan foto nyata.
- **Tindak Lanjut**:
  - Sambungkan HP Android fisik via USB Debugging.
  - Jalankan pengujian manual untuk skenario: izin pertama kali, izin ditolak, pembatalan kamera, jepretan foto berhasil, dan foto ulang.

---

## 2. Keterbatasan Arsitektur Model AI (Closed-Set 5 Kelas & Ambang 0.65)

- **Kondisi Aktual**:
  - Model `paddy_mobilenetv3.tflite` (3,87 MB) adalah model klasifikasi 5 kelas daun: `bacterial_leaf_blight`, `brown_spot`, `leaf_blast`, `normal`, dan `tungro`.
  - Evaluasi pada data uji murni (450 citra riil, 90 per kelas) mencapai akurasi **77.78%** dan Macro F1 **0.7787**.
  - **Kalibrasi Ambang Ketidakyakinan (0.65)**:
    - Ambang dinaikkan menjadi **0.65** berdasarkan evaluasi kalibrasi empiris.
    - Pada skor ≥ 0.65, akurasi prediksi in-scope yang dipertahankan mencapai **91.19%**.
  - **Keterbatasan Out-of-Scope (OOS)**:
    - Pengujian pada 400 citra non-target (`dead_heart`, `hispa`, `leaf_scald`, `narrow_brown_spot`) menunjukkan laju penolakan 48.5% pada ambang 0.65.
    - Penyakit dengan bentuk lesi menyerupai bercak cokelat (seperti *narrow brown spot* dan *leaf scald*) masih dapat menghasilkan skor di atas ambang jika pola bercak sangat mirip.
  - **Klaim Produk**:
    - Aplikasi secara jujur menyatakan hanya mendukung 5 kelas daun tersebut, BUKAN "semua penyakit padi".
- **Tindak Lanjut**:
    - Edukasi pengguna melalui teks antarmuka di `ResultScreen` dan `AboutScreen` bahwa hasil pemeriksaan adalah *dugaan awal berbasis foto*, serta menyarankan pemeriksaan lanjutan oleh penyuluh (PPL) jika hasil belum meyakinkan.

---

## 3. Keterbatasan Platform (Web & iOS)

- **Kondisi Aktual**:
  - **Flutter Web (Chrome)**: Tidak didukung. Pustaka `tflite_flutter` dan `dart:io` bergantung pada library native C++ Android/Desktop dan FFI yang tidak tersedia di lingkungan browser.
  - **iOS**: Konfigurasi `NSCameraUsageDescription` dan `NSPhotoLibraryUsageDescription` telah ditambahkan di `ios/Runner/Info.plist`, namun build dan pengujian di perangkat fisik iOS **belum pernah dilakukan** karena lingkungan kerja berbasis Windows tanpa macOS/Xcode.
- **Tindak Lanjut**:
  - Target operasional MVP difokuskan 100% pada platform Android. Pengujian iOS dicatat sebagai pekerjaan lanjutan jika infrastruktur macOS tersedia.
