# Spesifikasi Model TensorFlow Lite PadiCare

- **Model File**: `paddy_mobilenetv3.tflite`
- **Labels File**: `labels.txt`
- **Arsitektur Dasar**: MobileNetV3-Small (Transfer Learning dari ImageNet)
- **Ukuran Input**: `[1, 224, 224, 3]` (Batch=1, Height=224, Width=224, Channels=3)
- **Tipe Tensor Input**: `float32`
- **Format Warna**: RGB (Red, Green, Blue)
- **Rentang Nilai Input**: `[0.0, 255.0]` (Layer Rescaling bawaan MobileNetV3 mengonversi otomatis ke `[-1.0, 1.0]`)
- **Tipe Tensor Output**: `float32`
- **Bentuk Output**: `[1, 3]` (vektor probabilitas Softmax)
- **Ukuran Berkas**: ~1.12 MB (TFLite Dynamic Range Quantized)
- **Ambang Ketidakyakinan (Uncertainty Threshold)**: `0.6`

## Urutan Label (Indeks Keluaran)
- **Indeks 0**: `bacterial_leaf_blight` (Hawar Daun Bakteri)
- **Indeks 1**: `brown_spot` (Bercak Cokelat)
- **Indeks 2**: `normal` (Daun Normal / Sehat)

## Ringkasan Metrik Evaluasi Data Uji
- **Akurasi Data Uji**: 88.52%
- **Jumlah Sampel Uji**: 61 gambar riil lapangan
- **Rata-rata Keyakinan Prediksi Benar**: 93.18%
