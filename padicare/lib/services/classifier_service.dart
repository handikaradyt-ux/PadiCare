import 'dart:io';
import 'package:flutter/services.dart';
import '../models/detection_result.dart';

class ClassifierService {
  static const String modelAssetPath = 'assets/models/paddy_mobilenetv3.tflite';
  static const String labelsAssetPath = 'assets/models/labels.txt';

  bool _isModelLoaded = false;
  List<String> _labels = [];

  bool get isModelLoaded => _isModelLoaded;
  List<String> get labels => List.unmodifiable(_labels);

  Future<void> loadModel() async {
    try {
      // Periksa keberadaan berkas aset model & label
      final manifest = await rootBundle.loadString('AssetManifest.json');
      if (manifest.contains(modelAssetPath) && manifest.contains(labelsAssetPath)) {
        final labelsData = await rootBundle.loadString(labelsAssetPath);
        _labels = labelsData
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        _isModelLoaded = true;
      } else {
        _isModelLoaded = false;
      }
    } catch (_) {
      _isModelLoaded = false;
    }
  }

  Future<DetectionResult> classify(String imagePath) async {
    final file = File(imagePath);
    if (!await file.exists()) {
      return DetectionResult.error(
        errorType: DetectionErrorType.imageReadFailed,
        message: 'Berkas foto tidak ditemukan atau tidak dapat dibaca dari penyimpanan.',
        recoveryAction: 'Pilih Foto Ulang',
      );
    }

    if (!_isModelLoaded) {
      return DetectionResult.error(
        errorType: DetectionErrorType.modelLoadFailed,
        message:
            'Model klasifikasi TensorFlow Lite belum dimuat atau belum tersedia pada aset aplikasi.',
        recoveryAction: 'Muat Ulang Model',
        imagePath: imagePath,
      );
    }

    // Pipeline inferensi nyata akan diimplementasikan pada Tahap D
    return DetectionResult.uncertain(
      confidence: 0.0,
      imagePath: imagePath,
    );
  }
}
