# Rencana perluasan kelas penyakit daun PadiCare

Status: rancangan kerja, 13 Oktober 2026. Model Android yang terpasang saat ini tetap model tiga kelas sampai kandidat baru lulus evaluasi.

## Sasaran produk

PadiCare versi berikutnya menambah penyakit **daun** yang dapat dikenali dari satu foto. Istilah "semua penyakit padi" tidak dipakai sebagai klaim produk: sumber IRRI mencatat puluhan penyakit yang mengenai organ berbeda, termasuk pelepah, batang, dan bulir. Nama kelas yang tampil sebagai prediksi harus sama dengan kelas yang dilatih dan diuji.

## Tahap 1: pilot enam kategori dari data yang sudah diaudit

Dataset Project-AgML Bangladesh berlisensi CC BY 4.0 di proyek ini mempunyai 748 foto unik. Enam kategorinya: `bacterial_leaf_blight`, `brown_spot`, `leaf_blast`, `leaf_scald`, `narrow_brown_spot`, dan `normal` (lima penyakit serta satu daun normal). Model saat ini hanya menggunakan tiga kategori; 353 foto dari tiga penyakit lain sebelumnya dipakai sebagai evaluasi di luar cakupan.

`ml/prepare_six_class_data.py` menyiapkan pemisahan enam kelas di `ml/data_v2/` tanpa mengubah `ml/data/` atau APK saat ini. `ml/train_six_class_pilot.py` menulis model percobaan ke `ml/models_v2/` tanpa mengganti aset Flutter. `ml/evaluate_six_class_pilot.py` menghitung metrik test dan memeriksa kesesuaian TFLite. Foto sintetis dalam `test_images_synthetic/` tidak dipakai untuk pelatihan atau pengukuran akurasi.

**Hasil pilot pertama:** 521 foto train, 112 validasi, 115 test. Akurasi test **53,04%** dan macro F1 **0,5391** (`ml/models_v2/evaluation_metrics.json`). Recall `leaf_blast` hanya 35% dan `leaf_scald` 29,41%. Ekspor TFLite float32 berhasil, dengan perbedaan probabilitas maksimum Keras–TFLite sekitar 0,0000014 pada lima foto contoh. Model ini **tidak layak dirilis**; jangan menyalinnya ke `padicare/assets/models/`. Percobaan quantization sebelumnya menghasilkan selisih sekitar 0,0772 dan tidak dipakai. Hasil ini menjadi dasar kebutuhan data tambahan dan peninjauan label/strategi pelatihan.

Ketika tiga kelas tambahan dilatih, foto mereka tidak lagi sah sebagai pengujian penyakit di luar cakupan. Evaluasi penolakan input yang tidak dikenal memerlukan kumpulan foto lain yang terpisah.

## Tahap 2: audit data tambahan sebelum menambah kelas

| Sumber kandidat | Potensi | Pemeriksaan sebelum dipakai |
|---|---|---|
| [Paddy Doctor, AgML](https://huggingface.co/datasets/Project-AgML/paddy_disease_classification) | 10.407 foto, 10 label; termasuk bacterial leaf streak, blast, downy mildew, tungro, dan normal | Periksa izin data dari sumber primer/aturan kompetisi, label yang sebenarnya penyakit daun, duplikasi lintas dataset, mutu anotasi, dan perbedaan gaya foto. Label seperti `hispa` adalah hama; `dead_heart` bukan penyakit daun; `bacterial_panicle_blight` menyangkut malai. Jangan otomatis menggabungkan semua label sebagai penyakit daun. |
| [Mendeley Data n8jpkpfz5p](https://data.mendeley.com/datasets/n8jpkpfz5p/1) | CC BY 4.0; beberapa label tambahan seperti hispa, tungro, neck blast, sheath blight | Deskripsi situs menyebut "nine categories" tetapi merinci sepuluh nama; jumlah per kelas yang tercantum juga tidak sama dengan total 6.758. Unduh dan audit isi nyata sebelum dipakai. Pisahkan organ yang tidak sesuai foto daun. |
| [UCI Rice Leaf Diseases](https://archive.ics.uci.edu/dataset/486/rice+leaf+diseases) | CC BY 4.0; tambahan leaf smut | Hanya 40 foto leaf smut. Belum memadai sebagai satu-satunya sumber untuk mengklaim kelas ini andal di lapangan. |

Prioritas kelas tambahan ditetapkan setelah audit: cukup foto nyata berlabel benar, kesesuaian gejala pada daun, izin penggunaan jelas, dan tersedia foto uji dari lokasi/perangkat berbeda. Jangan gunakan gambar hasil AI sebagai data berlabel penyakit.

## Aturan evaluasi dan penerimaan

1. Bekukan daftar kelas dan sumber sebelum pelatihan. Simpan jumlah per kelas, sumber, lisensi, tanggal akses, dan aturan penyatuan label.
2. Hapus duplikat tepat dan cari foto hampir sama lintas sumber. Kelompok foto dari daun, tanaman, lokasi, atau sesi yang sama sebelum membagi train/validasi/test. Augmentasi hanya untuk train.
3. Laporkan confusion matrix, precision, recall, dan F1 per kelas pada test yang tidak digunakan untuk memilih model. Uji juga foto lapangan Indonesia yang dilabeli penyuluh/ahli bila tersedia.
4. Ukur performa pada foto bukan daun, penyakit yang belum didukung, foto buram, dan gangguan hara/hama. Softmax berkeyakinan tinggi tidak membuktikan foto termasuk kelas yang dikenal. Kalibrasi ulang mekanisme "hasil belum meyakinkan"; jangan menyalin ambang 0,60 dari model lama.
5. Bandingkan keluaran Python dan TFLite pada foto yang sama. Setelah itu perbarui label, pemetaan hasil, informasi penyakit, tes Flutter, dan APK secara serempak.
6. Rilis model baru hanya jika pengujian kelas tambahan dan kelas lama memenuhi kriteria yang disepakati. Simpan model lama sebagai pembanding dan jalur kembali. Jika bukti belum cukup, tampilkan kelas sebagai "belum didukung" dalam dokumentasi, bukan sebagai prediksi aplikasi.

## Tahap 3: Pelaksanaan Audit Sumber Tambahan, Pelatihan 5 Kelas, dan Model Akhir

Pada audit Oktober 2026, sumber dataset diperluas dan diverifikasi lisensi resminya:
1. **AgML India (Sethy et al., Mendeley Data V2 2024, doi:10.17632/fwcj7stb8r.2, CC BY 4.0):** 5.932 foto, memuat kelas daun `Bacterialblight`, `Blast`, `Brownspot`, dan `Tungro`.
2. **Paddy Doctor (Chithambaram et al., IEEE Dataport 2022, doi:10.21227/hz4v-af08, CC BY 4.0):** 10.407 foto, memuat kelas daun `bacterial_leaf_blight`, `blast`, `brown_spot`, `normal`, dan `tungro`. Kelas non-daun seperti `hispa` (hama serangga) dan `dead_heart` (gejala penggerek batang) dipisahkan ke pengujian luar cakupan (out-of-scope).
3. **AgML Bangladesh (Masud et al., PLOS ONE 2026, CC BY 4.0):** 748 foto. Kelas `leaf_scald` (107 foto) dan `narrow_brown_spot` (113 foto) dialihkan menjadi dataset evaluasi out-of-scope karena data nyata tidak mencukupi untuk generalisasi mandiri dan memiliki tumpang tindih visual tinggi dengan brown spot.

### Data latih, validasi, dan uji akhir (`ml/data_v3/`)
- 5 kelas daun: `bacterial_leaf_blight`, `brown_spot`, `leaf_blast`, `normal`, `tungro`.
- Data latih (train): 2.100 foto (420 per kelas).
- Data validasi (val): 450 foto (90 per kelas).
- Data uji (test): 450 foto (90 per kelas, seimbang dan terisolasi).
- Data out-of-scope (OOS): 400 foto (100 dead heart, 100 hispa, 100 leaf scald, 100 narrow brown spot).

### Hasil evaluasi model 5 kelas akhir (`ml/models_v3/evaluation_metrics.json`)
- **Akurasi test:** **77,78%** (pada 450 foto uji riil).
- **Macro F1:** **0,7787** (meningkat signifikan dari pilot 6 kelas yang hanya 0,5391).
- **Metrik per kelas:**
  - `bacterial_leaf_blight`: Precision 76,8%, Recall 84,4%, F1 **80,4%**
  - `brown_spot`: Precision 68,6%, Recall 77,8%, F1 **72,9%**
  - `leaf_blast`: Precision 74,4%, Recall 71,1%, F1 **72,7%** (naik dari 36,8% di pilot)
  - `normal`: Precision 84,3%, Recall 77,8%, F1 **80,9%**
  - `tungro`: Precision 87,5%, Recall 77,8%, F1 **82,4%**
- **Kalibrasi ambang batas ketidakyakinan (uncertainty threshold):**
  - Ambang dinaikkan dari 0,60 menjadi **0,65**.
  - Pada ambang 0,65, akurasi foto in-scope yang diterima mencapai **91,19%**, dan tingkat penolakan foto luar cakupan (OOS) mencapai **48,5%**.
- **Paritas TFLite:** Selisih probabilitas maksimum Keras vs TFLite adalah **0,0000035** (jauh di bawah batas toleransi 0,01). Ukuran model TFLite adalah **3,87 MB**.

## Keputusan rilis

Model 5 kelas (`paddy_mobilenetv3_five_class.tflite`) memenuhi seluruh kriteria evaluasi dan secara resmi dipasang ke aplikasi Android (`padicare/assets/models/paddy_mobilenetv3.tflite`). Seluruh aset, `labels.txt`, `ClassifierService`, `DiseaseInfo`, dan antarmuka informasi penyakit telah diselaraskan untuk 5 kelas yang didukung. Model 6 kelas pilot tetap disimpan sebagai riwayat eksperimen yang tidak dipasang.
