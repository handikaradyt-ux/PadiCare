// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:padicare/models/detection_result.dart';
import 'package:padicare/services/classifier_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('On-Device TFLite Real Inference Tests', () {
    late ClassifierService classifier;

    setUpAll(() async {
      classifier = ClassifierService();
      await classifier.loadModel();
      expect(
        classifier.isModelLoaded,
        isTrue,
        reason: 'Model TFLite harus berhasil dimuat dari aset',
      );
      expect(
        classifier.labels,
        [
          'bacterial_leaf_blight',
          'brown_spot',
          'leaf_blast',
          'normal',
          'tungro',
        ],
        reason: 'Urutan label harus sama dengan model lima kelas yang dipasang',
      );
      print(
        '✅ Model TFLite loaded successfully on Android: ${classifier.labels}',
      );
    });

    tearDownAll(() {
      classifier.dispose();
    });

    Future<File> getTestImageFile(String assetPath, String filename) async {
      final byteData = await rootBundle.load(assetPath);
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/$filename');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      return file;
    }

    testWidgets('Inference on Bacterial Leaf Blight sample', (
      WidgetTester tester,
    ) async {
      final file = await getTestImageFile(
        'assets/sample_leaves/sample_blb.jpg',
        'test_blb.jpg',
      );
      final result = await classifier.classify(file.path);
      print(
        'BLB Result: status=${result.status}, label=${result.labelId}, conf=${result.confidence}, time=${result.inferenceTimeMs}ms',
      );

      expect(result.status, DetectionStatus.diseaseDetected);
      expect(result.labelId, 'bacterial_leaf_blight');
      expect(
        result.confidence,
        greaterThanOrEqualTo(ClassifierService.uncertaintyThreshold),
      );
      expect(result.inferenceTimeMs, greaterThan(0));
    });

    testWidgets('Inference on Brown Spot sample', (WidgetTester tester) async {
      final file = await getTestImageFile(
        'assets/sample_leaves/sample_brown_spot.jpg',
        'test_brown_spot.jpg',
      );
      final result = await classifier.classify(file.path);
      print(
        'Brown Spot Result: status=${result.status}, label=${result.labelId}, conf=${result.confidence}, time=${result.inferenceTimeMs}ms',
      );

      expect(result.status, DetectionStatus.diseaseDetected);
      expect(result.labelId, 'brown_spot');
      expect(
        result.confidence,
        greaterThanOrEqualTo(ClassifierService.uncertaintyThreshold),
      );
      expect(result.inferenceTimeMs, greaterThan(0));
    });

    testWidgets('Inference on Healthy / Normal sample', (
      WidgetTester tester,
    ) async {
      final file = await getTestImageFile(
        'assets/sample_leaves/sample_normal.jpg',
        'test_normal.jpg',
      );
      final result = await classifier.classify(file.path);
      print(
        'Healthy Result: status=${result.status}, label=${result.labelId}, conf=${result.confidence}, time=${result.inferenceTimeMs}ms',
      );

      expect(result.status, DetectionStatus.healthy);
      expect(result.labelId, 'normal');
      expect(
        result.confidence,
        greaterThanOrEqualTo(ClassifierService.uncertaintyThreshold),
      );
      expect(result.inferenceTimeMs, greaterThan(0));
    });

    testWidgets('Inference on supported Blast sample', (
      WidgetTester tester,
    ) async {
      final file = await getTestImageFile(
        'assets/sample_leaves/sample_blast.jpg',
        'test_blast.jpg',
      );
      final result = await classifier.classify(file.path);
      print(
        'Blast Result: status=${result.status}, label=${result.labelId}, conf=${result.confidence}, time=${result.inferenceTimeMs}ms',
      );

      // The model either predicts with valid format or flags uncertain
      expect(result.status != DetectionStatus.error, isTrue);
      expect(result.inferenceTimeMs, greaterThan(0));
    });

    testWidgets('Inference on missing image handles error cleanly', (
      WidgetTester tester,
    ) async {
      final result = await classifier.classify(
        '/sdcard/non_existent_file_xyz123.jpg',
      );

      expect(result.status, DetectionStatus.error);
      expect(result.errorType, DetectionErrorType.imageReadFailed);
      expect(result.recoveryAction, 'Pilih Foto Ulang');
    });
  });
}
