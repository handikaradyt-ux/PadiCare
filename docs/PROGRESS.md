# Catatan Kemajuan Proyek PadiCare

Dokumen ini mencatat kemajuan proyek dan bukti pengujian. Ringkasan A–F di bawah merekam status **16 Oktober 2026**; pembaruan **29 Oktober 2026** ada pada bagian akhir.

## Ringkasan Status Tahap

| Tahap | Deskripsi | Status | Catatan Verifikasi & Kondisi Nyata |
|---|---|---|---|
| **Tahap A** | Audit Lingkungan & Proyek | **Selesai dan Teruji** | Flutter 3.47.2, Dart 3.13.2, Android SDK API 36, `cmdline-tools/latest`, lisensi disetujui, proyek `padicare` aktif. |
| **Tahap B** | Fondasi Aplikasi & UI 12 Layar | **Selesai dan Teruji (dengan catatan kamera)** | Tema AgroSawah M3 (`#133E26`), 12 layar/status modular, komponen teruji. Alur galeri berfungsi penuh. Alur kamera langsung telah diperbarui kodenya (izin, exception handling, `retrieveLostData`), tetapi pengujian pada HP fisik berstatus menunggu pengujian manual oleh pengguna. |
| **Tahap C** | Dataset & Model MobileNetV3 5 Kelas | **Selesai dan Teruji** | Dataset multi-sumber berlisensi CC BY 4.0 (Sethy et al. 2020/2024, Paddy Doctor IEEE 2022, Masud et al. 2026). 5 kelas daun: BLB, Bercak Cokelat, Blas Daun, Daun Sehat, Tungro. Total 3.000 citra (Train 2.100, Val 450, Test 450) + 400 OOS benchmark. Akurasi data uji: **77.78%** (Macro F1: **0.7787**). Pada ambang keyakinan 0.65, akurasi in-scope yang dipertahankan mencapai **91.19%**. |
| **Tahap D** | Konversi & Integrasi TFLite | **Selesai dan Teruji** | Model dikonversi ke TFLite float32: `padicare/assets/models/paddy_mobilenetv3.tflite` (**3.87 MB** / 4.059.772 bytes). `labels.txt` (5 kelas). Komparasi Keras vs TFLite identik (selisih probabilitas maksimum 3.46e-06). Integrasi `ClassifierService` selesai dengan ambang keyakinan terkalibrasi 0.65 dan praproses RGB 224x224 float32. |
| **Tahap E** | Uji Aplikasi & Perbaikan | **Sebagian (Kamera Fisik Menunggu Pengujian Manual)** | • `flutter analyze --no-pub`: **0 issues found**.<br>• `flutter test --no-pub`: **15/15 unit & widget tests lulus** (16/10/2026).<br>• Uji offline mode pesawat terbukti berjalan di Android.<br>• **Pending**: Pengujian kamera langsung pada HP fisik berstatus **menunggu pengujian manual oleh pengguna**. |
| **Tahap F** | Rilis APK & Bahan Laporan | **Selesai dan Teruji** | • Fresh Release APK: `padicare/build/app/outputs/flutter-apk/app-release.apk` (**71.1 MB**, dibuat 16/10/2026).<br>• Terverifikasi memuat model TFLite 5 kelas, label 5 kelas, dan aset penyakit lengkap.<br>• Panduan pengujian manual dan dokumentasi siap di `docs/`. |

---

## Log Aktivitas Terkini (Ekspansi 5 Kelas & Rilis APK 16 Oktober 2026)

### 1. Audit Sumber Dataset & Eliminasi Pilot 6 Kelas
- Pilot 6 kelas sebelumnya (`ml/models_v2/`) hanya mencapai akurasi 53.04% karena volume data minim (521 latih) dan kebingungan lesi antara `leaf_scald` (recall 29.4%) dan `narrow_brown_spot`. Sesuai PRD dan instruksi, model pilot ini **TIDAK DIRILIS**.
- Mengunduh dan mengaudit dataset primer berlisensi CC BY 4.0:
  - **AgML India (Sethy et al., Mendeley Data 2024)**: 5.932 citra real daun padi (Bacterial blight, Blast, Brown spot, Tungro).
  - **Paddy Doctor (IEEE Dataport 2022)**: 10.407 citra. Memilah kelas daun vs kelas hama/malai.
  - **AgML Bangladesh (Masud et al. 2026)**: 748 citra.
- Memilih 5 kelas daun bergejala jelas dan bervolume tinggi:
  1. `bacterial_leaf_blight` (Hawar Daun Bakteri / Kresek)
  2. `brown_spot` (Bercak Cokelat)
  3. `leaf_blast` (Blas Daun)
  4. `normal` (Daun Tampak Sehat)
  5. `tungro` (Penyakit Tungro)
- Memisahkan 400 citra luar cakupan (`hispa`, `dead_heart`, `leaf_scald`, `narrow_brown_spot`) untuk benchmark kalibrasi ambang penolakan.

### 2. Pelatihan & Evaluasi Model 5 Kelas
- Pelatihan transfer learning 2 fase:
  - Fase 1: Base MobileNetV3 dibekukan, latih dense head dengan Adam (lr=1e-3).
  - Fase 2: Unfreeze 40 layer teratas base, fine-tuning dengan Adam (lr=1e-4).
- Evaluasi pada 450 citra test murni:
  - Akurasi: **77.78%**, Macro F1: **0.7787**.
  - BLB: F1 80.4%, Brown Spot: F1 72.9%, Leaf Blast: F1 72.7%, Normal: F1 80.9%, Tungro: F1 82.4%.
  - Kalibrasi ambang: Ambang dioptimalkan pada **0.65** (akurasi in-scope yang dipertahankan mencapai **91.19%** dan laju penolakan out-of-scope 48.5%).
  - Paritas TFLite: Selisih probabilitas Keras vs TFLite maksimum adalah **3.46e-06** (< 0.00001).

### 3. Integrasi Flutter & Build APK Rilis
- Menyalin model `paddy_mobilenetv3.tflite` (3.87 MB) dan `labels.txt` ke `padicare/assets/models/`.
- Memperbarui `ClassifierService` dengan 5 kelas dan threshold 0.65.
- Memperbarui `DiseaseInfo` dengan informasi agronomis lengkap 5 kelas.
- Memperbarui `AboutScreen` dengan pernyataan batas kelas model yang jujur.
- Menjalankan verifikasi:
  - `flutter test --no-pub`: 15/15 lulus.
  - `flutter analyze --no-pub`: 0 issues found.
  - `flutter build apk --release`: Sukses menghasilkan APK rilis 71.1 MB di `padicare/build/app/outputs/flutter-apk/app-release.apk`.

---

## Pembaruan Tahap 4 dan Persiapan Tahap 5 — 29 Oktober 2026

- `flutter test --no-pub`: **15/15 tes unit dan widget lulus**.
- `flutter analyze --no-pub`: **No issues found**.
- Tes integrasi Android lima kelas belum dijalankan: `emulator-5554` terdeteksi tetapi belum terotorisasi, dan HP fisik belum dipakai untuk pengujian.
- APK yang dibuat 16 Oktober 2026 berukuran **74.528.266 byte**. SHA-256 APK: `bb21e501dd0189887e505192508eab9907670c84bcdca33717774b6d83dcdf0a`. Model TFLite di dalam APK mempunyai SHA-256 yang sama dengan aset proyek, dan `labels.txt` di dalam APK memuat tepat lima kelas.
- Tes integrasi yang masih merujuk tiga kelas dan ambang 0,60 telah diselaraskan dengan model lima kelas dan ambang 0,65. README dan spesifikasi model juga diperbarui; `FINAL_VALIDATION.md` diberi label arsip versi tiga kelas.
- Pengujian kamera langsung di HP Android fisik dan pengujian beberapa calon pengguna **belum dilakukan**. APK saat ini berstatus **kandidat pengujian**, bukan aplikasi final. Video demonstrasi akan dibuat sendiri oleh kelompok.
- Skenario uji, tabel hasil yang sudah memiliki bukti, kolom hasil uji pengguna yang menunggu pengisian, daftar temuan, dan gerbang finalisasi tersedia dalam `Laporan_Tahap_4_dan_Persiapan_Tahap_5_PadiCare.docx`.
