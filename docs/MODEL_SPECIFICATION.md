# Spesifikasi Model TensorFlow Lite PadiCare

Dokumen ini menjelaskan model lima kelas yang **terpasang pada aplikasi** per 29 Oktober 2026. Artefak model tiga kelas dalam `ml/models/` disimpan sebagai riwayat eksperimen.

| Komponen | Nilai |
|---|---|
| Berkas aplikasi | `padicare/assets/models/paddy_mobilenetv3.tflite` |
| Berkas label | `padicare/assets/models/labels.txt` |
| Arsitektur dasar | MobileNetV3 Small, transfer learning |
| Tensor input | `[1, 224, 224, 3]`, `float32`, RGB, nilai piksel 0–255 |
| Tensor output | `[1, 5]`, `float32`, probabilitas softmax |
| Ukuran model | 4.059.772 byte |
| Ambang hasil belum meyakinkan | Skor tertinggi di bawah 0,65 |

## Urutan label keluaran

| Indeks | Label | Tampilan aplikasi |
|---|---|---|
| 0 | `bacterial_leaf_blight` | Hawar Daun Bakteri |
| 1 | `brown_spot` | Bercak Cokelat |
| 2 | `leaf_blast` | Blas Daun |
| 3 | `normal` | Daun Tampak Sehat |
| 4 | `tungro` | Penyakit Tungro |

## Evaluasi model

Pada 450 citra uji terpisah (90 per kelas), akurasi 77,78% dan macro F1 0,7787. Dengan ambang 0,65, 73,11% citra dalam cakupan menghasilkan label; akurasi pada bagian yang diberi label adalah 91,19%. Dari 400 citra luar cakupan, 48,5% ditandai belum meyakinkan. Angka ini berasal dari evaluasi model, bukan hasil uji pengguna atau bukti akurasi kamera HP. Sumber rinci: `ml/models_v3/evaluation_metrics.json`.

Selisih probabilitas maksimum antara model Keras dan TFLite pada pengujian paritas adalah 0,00000346. Model bersifat *closed set* sehingga penyakit lain dapat keliru diberi salah satu dari lima label dengan skor tinggi. Hasil aplikasi harus dipakai sebagai dugaan awal dan dikonfirmasi melalui pengamatan atau penyuluh pertanian.
