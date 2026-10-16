import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/detection_result.dart';

class ClassifierService {
  static const String modelAssetPath = 'assets/models/paddy_mobilenetv3.tflite';
  static const String labelsAssetPath = 'assets/models/labels.txt';
  static const double uncertaintyThreshold = 0.65;
  static const int inputImageSize = 224;

  Interpreter? _interpreter;
  bool _isModelLoaded = false;
  List<String> _labels = [];

  bool get isModelLoaded => _isModelLoaded;
  List<String> get labels => List.unmodifiable(_labels);

  Future<void> loadModel() async {
    try {
      final labelsData = await rootBundle.loadString(labelsAssetPath);
      _labels = labelsData
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      _interpreter = await Interpreter.fromAsset(modelAssetPath);
      _isModelLoaded = true;
    } catch (_) {
      _interpreter = null;
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

    if (!_isModelLoaded || _interpreter == null) {
      await loadModel();
      if (!_isModelLoaded || _interpreter == null) {
        return DetectionResult.error(
          errorType: DetectionErrorType.modelLoadFailed,
          message:
              'Model klasifikasi TensorFlow Lite belum dimuat atau belum tersedia pada aset aplikasi.',
          recoveryAction: 'Muat Ulang Model',
          imagePath: imagePath,
        );
      }
    }

    try {
      final imageBytes = await file.readAsBytes();
      final decodedImage = img.decodeImage(imageBytes);

      if (decodedImage == null) {
        return DetectionResult.error(
          errorType: DetectionErrorType.imageReadFailed,
          message: 'Berkas foto rusak atau format gambar tidak didukung.',
          recoveryAction: 'Pilih Foto Ulang',
          imagePath: imagePath,
        );
      }

      // Resize ke dimensi tensor model (224x224)
      final resizedImage = img.copyResize(
        decodedImage,
        width: inputImageSize,
        height: inputImageSize,
        interpolation: img.Interpolation.linear,
      );

      // Siapkan input tensor [1, 224, 224, 3] float32 bernilai [0.0, 255.0]
      final input = List.generate(
        1,
        (_) => List.generate(
          inputImageSize,
          (y) => List.generate(
            inputImageSize,
            (x) {
              final pixel = resizedImage.getPixel(x, y);
              return [
                pixel.r.toDouble(),
                pixel.g.toDouble(),
                pixel.b.toDouble(),
              ];
            },
          ),
        ),
      );

      // Siapkan output tensor [1, N]
      final output = List.generate(1, (_) => List.filled(_labels.length, 0.0));

      // Jalankan inferensi dan ukur waktu proses
      final stopwatch = Stopwatch()..start();
      _interpreter!.run(input, output);
      stopwatch.stop();
      final inferenceTimeMs = stopwatch.elapsedMilliseconds;

      final probabilities = output[0];
      int maxIndex = 0;
      double maxScore = probabilities[0];

      for (int i = 1; i < probabilities.length; i++) {
        if (probabilities[i] > maxScore) {
          maxScore = probabilities[i];
          maxIndex = i;
        }
      }

      // Ambang ketidakyakinan (uncertainty threshold)
      if (maxScore < uncertaintyThreshold) {
        return DetectionResult.uncertain(
          confidence: maxScore,
          imagePath: imagePath,
          inferenceTimeMs: inferenceTimeMs,
        );
      }

      final labelName = _labels[maxIndex];

      switch (labelName) {
        case 'bacterial_leaf_blight':
          return DetectionResult.disease(
            labelId: 'bacterial_leaf_blight',
            displayName: 'Hawar Daun Bakteri (BLB)',
            confidence: maxScore,
            imagePath: imagePath,
            description:
                'Dugaan gejala garis basah memanjang atau bercak kuning keabuan di tepi helai daun padi.',
            inferenceTimeMs: inferenceTimeMs,
          );
        case 'brown_spot':
          return DetectionResult.disease(
            labelId: 'brown_spot',
            displayName: 'Bercak Cokelat (Brown Spot)',
            confidence: maxScore,
            imagePath: imagePath,
            description:
                'Dugaan lesi bercak oval kecokelatan dengan pusat pucat atau abu-abu pada permukaan daun padi.',
            inferenceTimeMs: inferenceTimeMs,
          );
        case 'leaf_blast':
          return DetectionResult.disease(
            labelId: 'leaf_blast',
            displayName: 'Blas Daun (Leaf Blast)',
            confidence: maxScore,
            imagePath: imagePath,
            description:
                'Dugaan lesi kumparan abu-abu keputihan dengan tepi coklat kemerahan khas patogen blas.',
            inferenceTimeMs: inferenceTimeMs,
          );
        case 'normal':
          return DetectionResult.healthy(
            confidence: maxScore,
            imagePath: imagePath,
            inferenceTimeMs: inferenceTimeMs,
          );
        case 'tungro':
          return DetectionResult.disease(
            labelId: 'tungro',
            displayName: 'Penyakit Tungro (Tungro)',
            confidence: maxScore,
            imagePath: imagePath,
            description:
                'Dugaan diskolorisasi daun kuning-jingga mulai dari ujung daun dan indikasi pertumbuhan kerdil.',
            inferenceTimeMs: inferenceTimeMs,
          );
        default:
          return DetectionResult.uncertain(
            confidence: maxScore,
            imagePath: imagePath,
            inferenceTimeMs: inferenceTimeMs,
          );
      }
    } catch (e) {
      return DetectionResult.error(
        errorType: DetectionErrorType.inferenceFailed,
        message: 'Gagal menjalankan inferensi model pada foto: $e',
        recoveryAction: 'Coba Lagi',
        imagePath: imagePath,
      );
    }
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isModelLoaded = false;
  }
}
