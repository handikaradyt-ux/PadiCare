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

## 2. Keterbatasan Arsitektur Model AI (Closed-Set Classifier & Ambang 0.60)

- **Kondisi Aktual**:
  - Model `paddy_mobilenetv3.tflite` adalah model klasifikasi tertutup (*closed-set classifier*) dengan lapisan output 3 kelas: `bacterial_leaf_blight`, `brown_spot`, dan `normal`.
  - Evaluasi pada data uji murni (61 citra) mencapai akurasi **88.52%** (54/61 benar).
  - **Keterbatasan Penting**: Evaluasi empiris pada 353 citra penyakit di luar cakupan (133 *Leaf Blast*, 107 *Leaf Scald*, dan 113 *Narrow Brown Spot*) menunjukkan bahwa model closed-set softmax cenderung memetakan lesi nekrotik daun tersebut ke kelas latih terdekat (mayoritas ke Brown Spot atau BLB) dengan skor confidence tinggi (> 85%–95%).
  - **Kesimpulan Ambang**: Ambang ketidakyakinan (uncertainty threshold) **0.60** menyaring citra yang menghasilkan distribusi probabilitas datar, tetapi **BELUM DAPAT DIANDALKAN untuk menolak semua penyakit di luar tiga kelas atau foto bukan daun padi**.
- **Tindak Lanjut**:
  - Edukasi pengguna melalui teks antarmuka di `ResultScreen` dan `AboutScreen` bahwa hasil pemeriksaan adalah *dugaan awal berbasis pola visual*, bukan diagnosis agronomis mutlak.
  - Pengembangan jangka panjang memerlukan arsitektur *open-set recognition*, penambahan kelas out-of-scope (*background/other*), atau model segmentasi visual.

---

## 3. Keterbatasan Platform (Web & iOS)

- **Kondisi Aktual**:
  - **Flutter Web (Chrome)**: Tidak didukung. Pustaka `tflite_flutter` dan `dart:io` bergantung pada library native C++ Android/Desktop dan FFI yang tidak tersedia di lingkungan browser.
  - **iOS**: Konfigurasi `NSCameraUsageDescription` dan `NSPhotoLibraryUsageDescription` telah ditambahkan di `ios/Runner/Info.plist`, namun build dan pengujian di perangkat fisik iOS **belum pernah dilakukan** karena lingkungan kerja berbasis Windows tanpa macOS/Xcode.
- **Tindak Lanjut**:
  - Target operasional MVP difokuskan 100% pada platform Android. Pengujian iOS dicatat sebagai pekerjaan lanjutan jika infrastruktur macOS tersedia.
