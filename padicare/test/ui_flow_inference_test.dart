import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:padicare/models/detection_result.dart';
import 'package:padicare/screens/preview_screen.dart';
import 'package:padicare/screens/result_screen.dart';
import 'package:padicare/services/classifier_service.dart';
import 'package:padicare/theme/app_theme.dart';

// Mock classifier for testing UI flow states deterministically
class MockClassifierService extends ClassifierService {
  final DetectionResult mockResult;

  MockClassifierService(this.mockResult);

  @override
  bool get isModelLoaded => true;

  @override
  Future<void> loadModel() async {}

  @override
  Future<DetectionResult> classify(String imagePath) async {
    return mockResult;
  }
}

void main() {
  group('UI Flow & Screen Verification Tests', () {
    late File dummyImage;

    setUpAll(() async {
      dummyImage = File('test_dummy_leaf.jpg');
      await dummyImage.writeAsBytes([1, 2, 3, 4]);
    });

    tearDownAll(() async {
      if (await dummyImage.exists()) {
        await dummyImage.delete();
      }
    });

    testWidgets('PreviewScreen displays image and triggers analysis', (WidgetTester tester) async {
      final mockClassifier = MockClassifierService(
        DetectionResult.disease(
          labelId: 'brown_spot',
          displayName: 'Bercak Cokelat (Brown Spot)',
          confidence: 0.9837,
          imagePath: dummyImage.path,
          description: 'Dugaan lesi bercak oval kecokelatan...',
          inferenceTimeMs: 120,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: PreviewScreen(
            initialImagePath: dummyImage.path,
            classifierService: mockClassifier,
          ),
        ),
      );

      expect(find.text('Pratinjau Foto Daun'), findsOneWidget);
      expect(find.text('Foto dipilih'), findsOneWidget);
      expect(find.text('Analisis Foto Daun'), findsOneWidget);

      // Tap Analisis Foto Daun
      await tester.tap(find.text('Analisis Foto Daun'));
      await tester.pumpAndSettle();

      // Should navigate to ResultScreen
      expect(find.text('Dugaan Hasil Pemeriksaan'), findsOneWidget);
      expect(find.text('Bercak Cokelat (Brown Spot)'), findsOneWidget);
      expect(find.text('Skor Model: 98.4%'), findsOneWidget);
      expect(find.text('Dugaan Gejala Penyakit'), findsOneWidget);
    });

    testWidgets('ResultScreen for Healthy Leaf displays correct badge and text', (WidgetTester tester) async {
      final healthyResult = DetectionResult.healthy(
        confidence: 0.9853,
        imagePath: dummyImage.path,
        inferenceTimeMs: 95,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: ResultScreen(
            result: healthyResult,
            classifierService: ClassifierService(),
          ),
        ),
      );

      expect(find.text('Daun Tampak Sehat'), findsWidgets);
      expect(find.text('Skor Model: 98.5%'), findsOneWidget);
      expect(find.text('Periksa Foto Lain'), findsOneWidget);
    });

    testWidgets('ResultScreen for Uncertain Result displays guidance and no misleading high score badge', (WidgetTester tester) async {
      final uncertainResult = DetectionResult.uncertain(
        confidence: 0.54,
        imagePath: dummyImage.path,
        inferenceTimeMs: 110,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: ResultScreen(
            result: uncertainResult,
            classifierService: ClassifierService(),
          ),
        ),
      );

      expect(find.text('Hasil Belum Meyakinkan'), findsWidgets);
      // PRD/Prompt: no confident score badge on uncertain
      expect(find.text('Perlu Verifikasi Ulang'), findsOneWidget);
      expect(find.text('Ambil Foto Ulang Sekarang'), findsOneWidget);
    });

    testWidgets('PreviewScreen shows error view when analysis encounters error', (WidgetTester tester) async {
      final mockClassifier = MockClassifierService(
        DetectionResult.error(
          errorType: DetectionErrorType.inferenceFailed,
          message: 'Keluaran model tidak terbaca atau rusak.',
          recoveryAction: 'Coba Lagi',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: PreviewScreen(
            initialImagePath: dummyImage.path,
            classifierService: mockClassifier,
          ),
        ),
      );

      await tester.tap(find.text('Analisis Foto Daun'));
      await tester.pumpAndSettle();

      expect(find.text('Kendala Pemeriksaan'), findsOneWidget);
      expect(find.text('Analisis Citra Gagal Diproses'), findsOneWidget);
      expect(find.text('Keluaran model tidak terbaca atau rusak.'), findsOneWidget);
      expect(find.text('Buka Pengaturan Izin'), findsNothing);
    });
  });
}
