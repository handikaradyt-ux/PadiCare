# Laporan Audit Instalasi, Dependensi, dan Artefak PadiCare

Dokumen ini disusun untuk mengaudit secara menyeluruh seluruh perangkat lunak, dependensi, dataset, dan artefak yang ada dalam lingkup proyek **PadiCare**, dengan membedakan status asal pemasangan secara objektif berdasarkan bukti perintah, konfigurasi, dan catatan log.

---

## 1. Tabel Inventarisasi Komponen dan Perangkat Lunak

Status asal pemasangan diklasifikasikan menjadi tiga:
- **Terbukti dipasang/dibuat oleh Antigravity**: Terdapat bukti eksekusi perintah (seperti `pip install`, `flutter create`, `git clone`, unduhan skrip, atau modifikasi file) dalam log sesi Antigravity.
- **Sudah ada sebelumnya**: Terbukti sudah terpasang sebelum pengerjaan proyek (misal timestamp jauh mendahului awal proyek 7 Oktober 2026 atau path instalasi sistem induk).
- **Asalnya belum bisa dipastikan**: Tidak terdapat catatan log pemasangan eksplisit, tetapi digunakan atau dipicu oleh proses dependensi sekunder.

| Nama Komponen | Jenis | Versi | Lokasi | Perkiraan Ukuran | Tujuan | Status Asal Pemasangan | Bukti & Catatan |
|---|---|---|---|---|---|---|---|
| **Flutter SDK** | Framework / SDK | 3.47.2 (Channel stable, Dart 3.13.2) | `C:\development\flutter` | ~2.1 GB | Fondasi pengembangan aplikasi mobile | **Sudah ada sebelumnya** | Dibuat 01/09/2026; dideteksi bersih pada awal audit Tahap A tanpa instalasi ulang. |
| **Dart SDK** | Language SDK | 3.13.2 | `C:\development\flutter\bin\cache\dart-sdk` | ~980 MB | Bahasa pemrograman Flutter | **Sudah ada sebelumnya** | Terintegrasi di dalam bundel Flutter SDK sejak 01/09/2026. |
| **Android SDK Core & Platforms 36, 37** | Mobile SDK | API 36 (Android 16), API 37 | `C:\Users\ASUS\AppData\Local\Android\Sdk\platforms` | ~200 MB | Kompilasi target Android platform | **Sudah ada sebelumnya** | Folder dibuat 10/09/2026 (Android Studio SDK default). |
| **Android Build-Tools 36.0.0** | Build Tools | 36.0.0 | `C:\Users\ASUS\AppData\Local\Android\Sdk\build-tools\36.0.0` | 136.6 MB | Compiler resource & DEX Android | **Sudah ada sebelumnya** | Dibuat 10/09/2026. |
| **Android System Image API 36** | Emulator Image | API 36 Google APIs PlayStore x86_64 | `C:\Users\ASUS\AppData\Local\Android\Sdk\system-images\android-36` | 2.34 GB | Citra sistem emulator Android | **Sudah ada sebelumnya** | Dibuat 10/09/2026. |
| **Android cmdline-tools (latest)** | CLI Tools | 11076708 (latest) | `C:\Users\ASUS\AppData\Local\Android\Sdk\cmdline-tools\latest` | 146.5 MB | Menyediakan `avdmanager` dan `sdkmanager` untuk lisensi | **Terbukti dipasang oleh Antigravity** | Log Tahap A: diunduh via curl/PowerShell zip dan diekstrak pada 07/10/2026 20:02:49 untuk memenuhi syarat `flutter doctor`. |
| **Android Platforms 31 & 35** | SDK Platform | API 31 & API 35 | `C:\Users\ASUS\AppData\Local\Android\Sdk\platforms\android-31` & `android-35` | 185.5 MB | Kompatibilitas kompilasi plugin Android (`image_picker`, dll.) | **Terbukti dipasang oleh Antigravity** | Terunduh otomatis oleh Gradle saat build pertama kali dijalankan pada 07/10/2026 20:27:18. |
| **AVD `padicare_avd`** | Profil Virtual Device | Pixel 6 (API 36) | Semula di `~/.android/avd/padicare_avd.avd` | ~2.5 GB (saat aktif) | Media uji coba aplikasi di emulator | **Terbukti dipasang oleh Antigravity** | Dibuat melalui perintah `avdmanager create avd -n padicare_avd` pada Tahap A. Saat ini direktori AVD kosong/nonaktif pasca restart sesi. |
| **Gradle Wrapper & Cache** | Build System | Gradle 9.3.1-all | `C:\Users\ASUS\.gradle` | ~2.8 GB | Kompilasi proyek Android | **Asalnya belum bisa dipastikan** | Menggunakan wrapper bawaan template Flutter; cache pustaka Gradle terunduh saat build berlangsung. |
| **Paket Flutter: `image_picker`** | Dependensi Dart | 1.2.4 (terkunci di `pubspec.lock`) | `Pub Cache: hosted/pub.dev/image_picker-1.2.4` | ~1.2 MB | Fitur pemilih foto kamera & galeri | **Terbukti dipasang oleh Antigravity** | Ditambahkan via `pubspec.yaml` pada Tahap B. |
| **Paket Flutter: `permission_handler`** | Dependensi Dart | 13.0.2 | `Pub Cache: hosted/pub.dev/permission_handler-13.0.2` | ~0.8 MB | Penanganan izin kamera & storage | **Terbukti dipasang oleh Antigravity** | Ditambahkan via `pubspec.yaml` pada Tahap B. |
| **Paket Flutter: `path_provider`** | Dependensi Dart | 2.1.6 | `Pub Cache: hosted/pub.dev/path_provider-2.1.6` | ~0.6 MB | Akses direktori sementara perangkat | **Terbukti dipasang oleh Antigravity** | Ditambahkan via `pubspec.yaml` pada Tahap D. |
| **Paket Flutter: `tflite_flutter`** | Dependensi Dart | 0.12.1 | `Pub Cache: hosted/pub.dev/tflite_flutter-0.12.1` | ~18.5 MB (termasuk binary `.so`) | Inferensi model TensorFlow Lite on-device | **Terbukti dipasang oleh Antigravity** | Ditambahkan via `pubspec.yaml` pada Tahap B/D. |
| **Paket Flutter: `image`** | Dependensi Dart | 4.10.1 | `Pub Cache: hosted/pub.dev/image-4.10.1` | ~3.8 MB | Praproses byte citra (crop & resize tensor) | **Terbukti dipasang oleh Antigravity** | Ditambahkan via `pubspec.yaml` pada Tahap B/D. |
| **Pub Cache Global** | Package Cache | 237 paket | `C:\Users\ASUS\AppData\Local\Pub\Cache` | 733.5 MB | Cache paket Dart/Flutter lokal | **Sebagian sebelumnya, sebagian Antigravity** | Sebagian paket sudah ada dari proyek lain; paket baru PadiCare diunduh ke sini. |
| **Python Environment (Laragon)** | Runtime Python | 3.10.6 | `C:\laragon\bin\python\python-3.10` | ~85 MB | Interpreter skrip data & training ML | **Sudah ada sebelumnya** | Folder dibuat 24/07/2026 dalam direktori Laragon. |
| **Pip: `tensorflow` & `keras`** | Library ML | 2.21.0 | `C:\laragon\bin\python\python-3.10\lib\site-packages\tensorflow` | 1.41 GB | Pelatihan transfer learning & konversi TFLite | **Terbukti dipasang oleh Antigravity** | Log eksekusi: `pip install tensorflow numpy pillow scikit-learn` pada 07/10/2026 20:48:12. |
| **Pip: `scikit-learn`** | Library ML | 1.7.2 | `C:\laragon\bin\python\python-3.10\lib\site-packages\sklearn` | 36.5 MB | Split data stratified & confusion matrix | **Terbukti dipasang oleh Antigravity** | Log eksekusi: `pip install scikit-learn` pada 07/10/2026. |
| **Pip: `pyarrow`** | Library Data | 21.0.0 | `C:\laragon\bin\python\python-3.10\lib\site-packages\pyarrow` | 83.2 MB | Membaca berkas dataset Parquet | **Terbukti dipasang oleh Antigravity** | Log eksekusi: `pip install pyarrow` pada 07/10/2026. |
| **Pip: `huggingface_hub` & `kagglehub`** | Library Hub | Terpasang | `C:\laragon\bin\python\python-3.10\lib\site-packages\` | 5.8 MB | Pengunduhan dataset kandidat | **Terbukti dipasang oleh Antigravity** | Log eksekusi: `pip install huggingface_hub kagglehub` pada 07/10/2026. |
| **Koleksi Dataset Masud et al. (PLOS ONE 2026)** | Dataset Terfilter | 748 citra RGB (Train/Val/Test) | `ml/data/` | 83.1 MB | Dataset resmi pelatihan model MobileNetV3 | **Terbukti dipasang oleh Antigravity** | Diekstrak dan difilter (25 duplikat dibuang) oleh `ml/audit_dataset.py` pada 07/10/2026. |
| **Dataset Alternatif (aldrin233)** | Dataset Raw Git | 1138 file | `dataset_sources/aldrin233/` | 30.4 MB | Eksplorasi kandidat dataset awal | **Terbukti dipasang oleh Antigravity** | Hasil `git clone https://github.com/aldrin233/RiceDiseases-DataSet.git` pada Tahap C. |
| **Hugging Face Cache** | Dataset Cache | Parquet & Raw Hub | `C:\Users\ASUS\.cache\huggingface` | 258.1 MB | Cache unduhan dataset Project-AgML | **Terbukti dipasang oleh Antigravity** | Terunduh saat proses pengunduhan dataset kandidat via Python. |
| **Model Master Keras** | Model Pelatihan | MobileNetV3-Small | `ml/models/padicare_mobilenetv3.keras` | 10.07 MB | Model checkpoint hasil fine-tuning | **Terbukti dipasang oleh Antigravity** | Dihasilkan dari eksekusi `ml/train_mobilenetv3.py`. |
| **Model TFLite Aplikasi** | Model On-Device | Quantized Float32 | `padicare/assets/models/paddy_mobilenetv3.tflite` | 1.12 MB | Model inferensi lokal di ponsel | **Terbukti dipasang oleh Antigravity** | Hasil konversi TFLite Converter di Tahap D. |
| **Output APK Debug** | Binary Android | Debug Build | `padicare/build/app/outputs/flutter-apk/app-debug.apk` | 143.5 MB | Pengujian awal emulator | **Terbukti dipasang oleh Antigravity** | Dibuat saat kompilasi debug Tahap A & B. |
| **Output APK Release** | Binary Android | Release Build | `padicare/build/app/outputs/flutter-apk/app-release.apk` | 68.1 MB | Binary rilis final siap pasang | **Terbukti dipasang oleh Antigravity** | Dibuat via `flutter build apk --release` pada Tahap F. |
| **Build Artifacts & Intermediate Cache** | Gradle & Flutter Build Cache | - | `padicare/build/` (selain direktori output APK) | ~1.84 GB | File objek, DEX, dan dependensi terkompilasi | **Terbukti dipasang oleh Antigravity** | Terbentuk selama build debug dan release berlangsung. |

---

## 2. Daftar Perubahan yang Belum Tersimpan dalam Commit Git

Berdasarkan `git status` terkini di branch `master`:

### A. Berkas Terlacak yang Mengalami Modifikasi (Modified)
1. `docs/PROGRESS.md`: Pembaruan log progres Tahap C, D, E, dan F (belum di-commit).
2. `padicare/lib/services/classifier_service.dart`: Implementasi inferensi nyata TFLite, decoding gambar, ekstraksi tensor RGB 224x224, penanganan error, dan ambang batas 0.60 (Tahap D).
3. `padicare/pubspec.yaml`: Penambahan dev_dependencies `integration_test` serta pendaftaran folder aset `assets/models/` dan `assets/sample_leaves/`.
4. `padicare/pubspec.lock`: Penguncian versi dependensi baru (`integration_test`, `file`, dll.).

### B. Berkas dan Direktori Baru yang Belum Terlacak (Untracked)
1. `dataset_sources/`: Folder berisi repositori `aldrin233` (30.4 MB).
2. `docs/MODEL_SPECIFICATION.md`: Spesifikasi teknis tensor model TFLite.
3. `docs/NASKAH_VIDEO_PADICARE_10_MENIT.md`: Dokumen skrip video laporan 10 menit.
4. `docs/NASKAH_VIDEO_PADICARE_13_MENIT_3_ORANG.md` & `.docx`: Format naskah video alternatif untuk 3 orang pembicara.
5. `ml/`: Seluruh pipeline machine learning (`audit_dataset.py`, `train_mobilenetv3.py`, `compare_inference.py`, `dataset_audit.json`, folder `ml/data/` 83.1 MB, serta model `ml/models/`).
6. `padicare/assets/`: Aset model `paddy_mobilenetv3.tflite`, `labels.txt`, dan citra uji daun di `padicare/assets/sample_leaves/`.
7. `padicare/integration_test/`: Berkas pengujian integrasi on-device `app_inference_test.dart`.
8. `padicare/test/*.png`: 12 berkas tangkapan layar verifikasi visual saat pengujian widget dan aplikasi.
9. `padicare/test/classifier_service_test.dart` & `ui_flow_inference_test.dart`: Unit & widget test alur inferensi.

---

## 3. Ketidaksesuaian antara Klaim di `docs/PROGRESS.md` dan Bukti Nyata

1. **Klaim Penyelesaian Commit**:
   - Di `docs/PROGRESS.md`, Tahap C sampai F dicatat seolah-olah sudah tuntas secara permanen.
   - **Fakta**: Seluruh berkas Tahap C hingga F (kode TFLite, model, pengujian integrasi, APK) belum pernah di-commit ke Git. Riwayat Git berhenti pada commit `28c4edb` (Tahap B). Jika terjadi `git checkout .` atau `git clean`, seluruh pekerjaan Tahap C–F dapat hilang.
2. **Klaim Pengujian Fitur Kamera**:
   - Di `docs/PROGRESS.md` Tahap B dan E dicatat: *"alur kamera/galeri terverifikasi"*.
   - **Fakta**: Fitur **kamera fisik langsung (`pickFromCamera()`)** sebenarnya **belum berhasil diuji/berfungsi pada demo nyata**. Pada emulator tanpa sensor kamera virtual dan saat pengujian integrasi (`app_inference_test.dart`), alur yang diuji hanya melewati pemilih berkas/galeri dan injeksi citra contoh (`assets/sample_leaves/`). Saat tombol kamera ditekan di emulator, kamera bawaan tidak merespons jepretan foto asli.
3. **Klaim Ketersediaan Emulator `padicare_avd`**:
   - Di `docs/PROGRESS.md` dicatat AVD `padicare_avd` aktif dan tersedia.
   - **Fakta**: Direktori `~/.android/avd/` saat ini kosong, dan perintah `flutter emulators` mengembalikan *"No emulators available"*. AVD tersebut tidak persisten atau terhapus saat sesi/daemon di-restart.
4. **Klaim Lingkungan Python**:
   - Di `docs/PROGRESS.md` tidak disebutkan bahwa library Python dipasang langsung ke global Laragon Python (`C:\laragon\bin\python\python-3.10`), bukan dalam virtual environment terisolasi (`.venv`).

---

## 4. Komponen yang Wajib Dipertahankan

Komponen berikut mutlak diperlukan agar proyek PadiCare dapat terus berjalan, dibangun, dan diuji:

1. **Folder Proyek Flutter (`padicare/`)**:
   - Seluruh kode sumber di `padicare/lib/`.
   - Berkas model dan label di `padicare/assets/models/paddy_mobilenetv3.tflite` dan `labels.txt`.
   - Berkas sampel daun di `padicare/assets/sample_leaves/`.
   - File konfigurasi `padicare/pubspec.yaml` dan `padicare/pubspec.lock`.
   - Berkas rilis APK yang sudah jadi: `padicare/build/app/outputs/flutter-apk/app-release.apk` (68.1 MB).
2. **Folder Machine Learning (`ml/`)**:
   - Skrip `ml/audit_dataset.py`, `ml/train_mobilenetv3.py`, `ml/compare_inference.py`.
   - Dataset tersaring di `ml/data/` (83.1 MB) sebagai bukti replikasi audit dan data latih.
   - Model master `ml/models/padicare_mobilenetv3.keras` dan metrik `ml/models/evaluation_metrics.json`.
3. **Folder Dokumentasi (`docs/`)**:
   - `MODEL_SPECIFICATION.md`, `PROGRESS.md`, `KNOWN_GAPS.md`, dan `NASKAH_VIDEO_PADICARE_10_MENIT.md`.
4. **Android SDK (`C:\Users\ASUS\AppData\Local\Android\Sdk`)**:
   - Terutama `cmdline-tools/latest` (yang dipasang oleh Antigravity), serta platforms 31, 35, 36.

---

## 5. Kandidat yang Dapat Dibersihkan Nanti (JANGAN Dibersihkan Sekarang)

Pembersihan berikut **TIDAK DILAKUKAN SEKARANG**, melainkan dicatat sebagai opsi penghematan ruang penyimpanan setelah proyek selesai:

| Komponen / Lokasi | Ukuran | Alasan & Dampak Jika Dibersihkan |
|---|---|---|
| **Build Cache Perantara (`padicare/build/` selain APK)** | ~1.84 GB | File objek Gradle, dex, dan transform. Dampak pembersihan (`flutter clean`): Menghemat ~1.8 GB, tetapi build berikutnya memerlukan kompilasi ulang penuh (3–5 menit). *Catatan: Jangan hapus folder APK sebelum disalin ke tempat aman.* |
| **Hugging Face Cache (`C:\Users\ASUS\.cache\huggingface`)** | 258.1 MB | File parquet dataset AgML mentah. Dampak: Menghemat 258 MB; tidak mempengaruhi aplikasi atau model karena dataset sudah diekstrak ke `ml/data/`. |
| **Repositori Eksplorasi (`dataset_sources/aldrin233/`)** | 30.4 MB | Dataset uji coba awal yang tidak jadi dipakai dalam model final. Dampak: Menghemat 30 MB tanpa dampak teknis. |
| **Paket Pip Kloning di Laragon (`pyarrow`, `kagglehub`, `huggingface_hub`)** | ~90 MB | Paket yang hanya dipakai saat mengunduh dataset mentah. Dampak: Tidak mempengaruhi Flutter atau APK rilis. |
| **Tangkapan Layar Uji (`padicare/test/*.png`)** | ~1.5 MB | 12 berkas screenshot hasil tes otomatis. Dampak: Hanya dokumentasi visual sementara. |

---

## 6. Proses yang Terdeteksi Masih Berjalan

Pada saat audit dilakukan (08/10/2026 16:00 WIB), proses yang aktif terkait lingkungan pengembangan adalah:

1. **`adb.exe` (PID 18012)**: Daemon jembatan Android Debug Bridge (Memory: ~12 MB). Tetap berjalan di latar belakang.
2. **`dart.exe` (PID 1232, 7044, 7864, 16792)**:
   - PID 1232: Dart Language Server (LSP) untuk IDE / editor.
   - PID 7044: Dart DevTools daemon.
   - PID 7864 & 16792: Flutter Tooling Daemon.
3. **`dartvm.exe` (PID 4936)**: Snapshot runtime Flutter tools daemon.
4. **Status Emulator**: Tidak ada proses emulator (`emulator.exe` / `qemu-system-x86_64.exe`) yang berjalan.
5. **Status Python**: Tidak ada proses pelatihan model atau skrip Python yang sedang berjalan.
6. **Status Java / Gradle**: Gradle daemon dalam status idle/berhenti.

*Catatan: Seluruh proses di atas dibiarkan berjalan sesuai instruksi aturan audit.*

---

## 7. Kondisi Terakhir Proyek dan Masalah Kamera

- **Status Kode & Model**: Proyek dalam kondisi stabil. Analisis kode Flutter bersih (`flutter analyze` 0 issues), 14 unit & widget test lulus, model TFLite berfungsi secara offline on-device dengan akurasi data uji 88.52% (54/61 benar) dan ambang ketidakyakinan 0.60.
- **Fakta Masalah Kamera pada Demo**:
  - Pada pengujian demo dan integration test sebelumnya, alur pemeriksaan berhasil dijalankan menggunakan **pilihan galeri** dan **citra daun contoh (`assets/sample_leaves/`)**.
  - Fitur **kamera langsung (`pickFromCamera()`)** **belum dapat digunakan pada demo**:
    1. Emulator Android `padicare_avd` tidak memiliki konfigurasi emulasi sensor kamera belakang (virtual scene / webcam).
    2. Saat tombol kamera ditekan di emulator, antarmuka kamera sistem gagal mengambil gambar asli dan mengembalikan hasil kosong / batal.
    3. Agar fitur kamera dapat ditunjukkan secara nyata dalam rekaman video 10 menit, aplikasi harus dijalankan pada **smartphone Android fisik** yang memiliki lensa kamera nyata, atau emulator harus dikonfigurasi dengan `hw.camera.back = virtualscene`.

---

## 8. Panduan Singkat untuk Melanjutkan Pekerjaan Setelah Jeda

Jika Anda siap melanjutkan pengerjaan proyek setelah jeda, berikut langkah urutannya:

1. **Menghubungkan Perangkat Fisik (Sangat Disarankan untuk Demo Kamera)**:
   - Hubungkan HP Android ke komputer via kabel USB, aktifkan *Developer Options* dan *USB Debugging*.
   - Periksa ketersediaan perangkat:
     ```powershell
     flutter devices
     ```
2. **Memverifikasi Pengambilan Foto Kamera Nyata**:
   - Jalankan aplikasi langsung ke HP fisik:
     ```powershell
     cd "c:\SEMESTER 5\MOBILE PROGRAMMING\T\padicare"
     flutter run -d <DEVICE_ID>
     ```
   - Tekan tombol **"Mulai Deteksi Daun"** -> pilih **"Ambil Foto (Kamera)"** -> izinkan akses kamera -> potret daun padi nyata atau dari layar monitor untuk membuktikan bahwa alur kamera fisik berfungsi.
3. **Mengamankan Commit Git (Mencegah Kehilangan Kode Tahap C–F)**:
   - Jalankan perintah berikut di root folder:
     ```powershell
     cd "c:\SEMESTER 5\MOBILE PROGRAMMING\T"
     git add .
     git commit -m "feat: complete Tahap C to F - MobileNetV3 model, TFLite integration, tests, and release APK"
     ```
4. **Memasang APK Release Langsung ke Ponsel**:
   - Jika ingin demonstrasi tanpa terhubung ke kabel USB:
     ```powershell
     adb install -r "padicare\build\app\outputs\flutter-apk\app-release.apk"
     ```
5. **Merekam Video Demonstrasi 10 Menit**:
   - Gunakan panduan naskah yang sudah siap pakai di [docs/NASKAH_VIDEO_PADICARE_10_MENIT.md](file:///c:/SEMESTER%205/MOBILE%20PROGRAMMING/T/docs/NASKAH_VIDEO_PADICARE_10_MENIT.md).
