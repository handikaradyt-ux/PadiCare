# PadiCare

PadiCare adalah aplikasi Flutter untuk **pemeriksaan awal gejala pada daun padi** dari satu foto. Aplikasi Android memproses gambar di perangkat menggunakan model MobileNetV3 dalam format TensorFlow Lite. Hasilnya berupa dugaan kondisi visual dan informasi tindak lanjut, **bukan diagnosis pertanian yang pasti**.

> **Status proyek:** APK Android yang tersedia adalah kandidat pengujian. Berdasarkan [catatan verifikasi terakhir](docs/PROGRESS.md) pada 29 Oktober 2026, tes unit dan widget lulus 15/15 serta `flutter analyze` tidak menemukan masalah. Pengujian kamera pada HP fisik dan pengujian beberapa calon pengguna belum tercatat selesai. Kode untuk kedua alur masukan foto tersedia, tetapi jangan menganggap status kamera telah terverifikasi hanya dari keberadaan kodenya.

## Fungsi aplikasi

1. Pengguna memilih satu foto daun padi melalui galeri atau kamera perangkat.
2. Foto ditampilkan pada halaman pratinjau agar dapat diperiksa atau diganti.
3. Model TensorFlow Lite menganalisis foto secara lokal tanpa akun, server, atau koneksi internet.
4. Aplikasi menampilkan dugaan hasil, skor model, informasi gejala, dan langkah pengamatan awal. Skor di bawah ambang 0,65 ditandai sebagai **hasil belum meyakinkan**.
5. Halaman pendukung menyediakan panduan foto, informasi penyakit, bantuan izin, dan penjelasan batasan aplikasi.

Model yang **terpasang di aplikasi** memiliki lima label berikut. `normal` adalah kondisi daun tampak sehat, bukan penyakit.

| Label model | Tampilan dalam aplikasi |
|---|---|
| `bacterial_leaf_blight` | Hawar Daun Bakteri |
| `brown_spot` | Bercak Cokelat |
| `leaf_blast` | Blas Daun |
| `normal` | Daun Tampak Sehat |
| `tungro` | Penyakit Tungro |

Pada 450 citra uji terpisah, model lima kelas mencapai akurasi **77,78%** dan macro F1 **0,7787**. Angka tersebut adalah hasil evaluasi dataset, bukan jaminan ketepatan pada setiap foto lapangan. Model tidak mendeteksi semua penyakit padi; penyakit di luar lima label dapat memperoleh prediksi yang keliru dengan skor tinggi. Rincian input, label, metrik, dan keterbatasan ada di [spesifikasi model](docs/MODEL_SPECIFICATION.md).

## Struktur repositori

| Folder atau berkas | Kegunaan |
|---|---|
| [`padicare/`](padicare/) | Proyek aplikasi Flutter yang dijalankan dan dibangun menjadi APK Android. |
| [`ml/`](ml/) | Skrip audit dataset, penyiapan data, pelatihan, evaluasi, dan artefak model ML. |
| [`docs/`](docs/) | Catatan progres, spesifikasi model, audit, keterbatasan, dan naskah video. Sebagian dokumen mencatat versi lama; lihat tanggal dan penanda arsipnya. |
| [`PadiCare_Desain_Stitch/`](PadiCare_Desain_Stitch/) | Dua belas rancangan layar/status dari Stitch, ekspor HTML/PNG, sistem desain, dan prompt implementasi. HTML di sini adalah acuan visual, bukan kode Flutter aplikasi. |
| [`test_images_synthetic/`](test_images_synthetic/) | Gambar daun sintetis untuk percobaan manual alur aplikasi. **Tidak digunakan** untuk pelatihan atau pengukuran akurasi model. |
| [`prd_revisi_render/`](prd_revisi_render/) | Teks hasil ekstraksi PRD revisi untuk memudahkan penelusuran isi dokumen. |
| Berkas `.docx` di akar repo | PRD, roadmap, rancangan Tahap 2, laporan Tahap 2–3, serta laporan pengujian dan persiapan Tahap 4–5. |
| [`PadiCare_MVP_Brief.md`](PadiCare_MVP_Brief.md) | Ringkasan ruang lingkup MVP dan fungsi utama aplikasi. |

### Isi penting `padicare/`

| Path | Kegunaan |
|---|---|
| `lib/screens/` | Halaman beranda, panduan foto, pratinjau, hasil, informasi penyakit, bantuan izin, dan tentang aplikasi. |
| `lib/services/` | Pemilihan foto kamera/galeri dan layanan klasifikasi TensorFlow Lite. |
| `lib/models/`, `lib/widgets/`, `lib/theme/` | Model data, komponen antarmuka yang dipakai ulang, dan tema visual. |
| `assets/models/` | Model TFLite lima kelas dan `labels.txt` yang benar-benar dimuat aplikasi. |
| `assets/sample_leaves/` | Contoh foto yang dipakai dalam pengujian integrasi; bukan dataset evaluasi lengkap. |
| `test/` | Tes unit dan widget. |
| `integration_test/` | Skenario inferensi pada perangkat Android; verifikasi versi lima kelas pada perangkat masih perlu dijalankan. |
| `android/` | Konfigurasi dan proyek native Android, termasuk izin serta pengaturan build APK. |
| `ios/`, `web/`, `linux/`, `macos/`, `windows/` | Berkas platform bawaan proyek Flutter. Target yang diuji untuk proyek ini adalah Android; iOS dan web belum dinyatakan didukung. |

### Isi penting `ml/`

| Path | Kegunaan |
|---|---|
| `models/` | Artefak dan metrik **model tiga kelas lama** untuk riwayat eksperimen. |
| `models_v2/` | Artefak **pilot enam kelas**; hasilnya tidak dipasang ke aplikasi. |
| `models_v3/` | Artefak pelatihan dan evaluasi **model lima kelas** yang digunakan pada versi Android saat ini. |
| `audit_dataset.py`, `prepare_*.py`, `train_*.py`, `evaluate_*.py`, `compare_inference.py` | Skrip audit, penyiapan data, pelatihan, evaluasi, dan pembandingan keluaran model. |

Dataset citra mentah, hasil pembagian data `ml/data/`, `ml/data_v2/`, `ml/data_v3/`, lingkungan Python, serta berkas build **tidak dipush** karena dikecualikan oleh [`.gitignore`](.gitignore). Sumber dataset, lisensi, keputusan pemilihan kelas, dan hasil pilot dijelaskan dalam [catatan ekspansi model](docs/RENCANA_EKSPANSI_PENYAKIT_DAUN.md). Repositori ini menyimpan skrip dan artefak model untuk menelusuri proses pengembangan, tetapi tidak menyediakan seluruh citra latih.

## Menjalankan aplikasi Android

Siapkan Flutter SDK dan Android SDK, lalu jalankan perintah berikut dari akar repositori:

```powershell
cd padicare
flutter pub get
flutter devices
flutter run -d ID_PERANGKAT_ANDROID
```

Ganti `ID_PERANGKAT_ANDROID` dengan ID yang ditampilkan oleh `flutter devices`.

Untuk membuat APK kandidat:

```powershell
cd padicare
flutter build apk --release
```

Hasil build berada di `padicare/build/app/outputs/flutter-apk/app-release.apk`. Folder `build/` tidak dipush, sehingga APK tidak tersedia langsung sebagai berkas dalam repo ini. Konfigurasi `release` saat ini masih memakai **debug key** untuk keperluan tugas, bukan sertifikat penandatanganan distribusi produksi.

## Pengujian

Jalankan dari folder `padicare/` setelah `flutter pub get`:

```powershell
flutter analyze --no-pub
flutter test --no-pub
```

Tes integrasi memerlukan emulator atau HP Android yang terotorisasi:

```powershell
flutter test integration_test/app_inference_test.dart -d ID_PERANGKAT_ANDROID
```

Skenario uji, hasil yang sudah memiliki bukti, temuan, dan pekerjaan yang masih menunggu uji perangkat/pengguna ada dalam [laporan Tahap 4–5 dengan sampul](Laporan_Tahap_4_dan_Persiapan_Tahap_5_PadiCare_REVISI_SAMPUL.docx). Lihat juga [catatan keterbatasan](docs/KNOWN_GAPS.md).

## Dokumen dan demonstrasi

- [PRD revisi](PRD_Deteksi_Dini_Penyakit_Daun_Padi_REVISI.docx)
- [Laporan perancangan dan implementasi Tahap 2–3](Laporan_Tahap_2_dan_3_PadiCare_REVISI.docx)
- [Laporan pengujian dan persiapan finalisasi Tahap 4–5](Laporan_Tahap_4_dan_Persiapan_Tahap_5_PadiCare_REVISI_SAMPUL.docx)
- [Catatan progres terkini](docs/PROGRESS.md)
- [Video demonstrasi yang dibagikan kelompok](https://www.youtube.com/watch?v=wuCKPZ0iPAo)

## Penggunaan AI dan sumber eksternal

Pengembangan tugas ini menggunakan bantuan Google Stitch untuk purwarupa antarmuka, Antigravity untuk pengerjaan aplikasi, serta ChatGPT/Codex untuk perencanaan, dokumentasi, dan audit. Kelompok tetap perlu memahami, memeriksa, dan mampu menjelaskan kode maupun hasilnya. Dataset dan materi pihak ketiga harus digunakan sesuai sumber dan lisensi masing-masing; rincian yang dicatat proyek tersedia pada dokumen di `docs/`.
