import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:padicare/main.dart';
import 'package:padicare/models/detection_result.dart';
import 'package:padicare/models/disease_info.dart';
import 'package:padicare/services/classifier_service.dart';

void main() {
  group('PadiCare UI & Navigation Smoke Tests', () {
    late ClassifierService classifierService;

    setUp(() {
      classifierService = ClassifierService();
    });

    testWidgets('Beranda menampilkan elemen identitas PadiCare dan Mode Offline',
        (WidgetTester tester) async {
      await tester.pumpWidget(PadiCareApp(classifierService: classifierService));

      // Verifikasi judul dan badge offline
      expect(find.text('PadiCare'), findsWidgets);
      expect(find.text('Mode Offline'), findsOneWidget);
      expect(find.text('Pemeriksaan Awal Gejala Daun Padi'), findsOneWidget);

      // Verifikasi tombol-tombol utama
      expect(find.text('Mulai Deteksi Daun'), findsOneWidget);
      expect(find.text('Panduan Foto'), findsOneWidget);
      expect(find.text('Info Penyakit'), findsOneWidget);
      expect(find.text('Tentang PadiCare & Batasan'), findsOneWidget);
      expect(find.text('Catatan Pemeriksaan Awal'), findsOneWidget);
    });

    testWidgets('Navigasi ke Panduan Foto Daun berhasil', (WidgetTester tester) async {
      await tester.pumpWidget(PadiCareApp(classifierService: classifierService));

      // Klik tombol Panduan Foto
      await tester.tap(find.text('Panduan Foto'));
      await tester.pumpAndSettle();

      // Verifikasi halaman panduan terbuka
      expect(find.text('Panduan Foto Daun'), findsOneWidget);
      expect(find.text('4 Langkah Pengambilan Foto yang Tepat'), findsOneWidget);
      expect(find.text('Fokus pada Satu Helai Daun'), findsOneWidget);

      // Kembali ke beranda
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('Mulai Deteksi Daun'), findsOneWidget);
    });

    testWidgets('Navigasi ke Informasi Penyakit Padi berhasil', (WidgetTester tester) async {
      await tester.pumpWidget(PadiCareApp(classifierService: classifierService));

      // Klik tombol Info Penyakit
      await tester.tap(find.text('Info Penyakit'));
      await tester.pumpAndSettle();

      // Verifikasi judul dan item penyakit pertama tampak di layar
      expect(find.text('Informasi Penyakit Padi'), findsOneWidget);
      expect(find.text('Bercak Coklat'), findsOneWidget);
      expect(find.text('Bipolaris oryzae / Drechslera oryzae'), findsOneWidget);
    });

    testWidgets('Navigasi ke Tentang PadiCare & Batasan berhasil', (WidgetTester tester) async {
      await tester.pumpWidget(PadiCareApp(classifierService: classifierService));

      // Klik tombol Tentang PadiCare & Batasan
      await tester.tap(find.text('Tentang PadiCare & Batasan'));
      await tester.pumpAndSettle();

      // Verifikasi halaman batasan terbuka
      expect(find.text('Tentang PadiCare'), findsOneWidget);
      expect(find.text('Latar Belakang Proyek'), findsOneWidget);
      expect(find.text('Privasi & Pemrosesan Lokal'), findsOneWidget);
      expect(find.text('Batasan Penting Model AI'), findsOneWidget);
    });
  });

  group('PadiCare Domain Logic Unit Tests', () {
    test('DiseaseInfo menyediakan informasi valid untuk kelas acuan PRD', () {
      final brownSpot = DiseaseInfo.getById('brown_spot');
      expect(brownSpot, isNotNull);
      expect(brownSpot!.name, 'Bercak Coklat');
      expect(brownSpot.visualSymptoms.isNotEmpty, true);
      expect(brownSpot.followUpSteps.isNotEmpty, true);

      final bacterialBlight = DiseaseInfo.getById('bacterial_leaf_blight');
      expect(bacterialBlight, isNotNull);
      expect(bacterialBlight!.name, contains('Hawar Daun Bakteri'));

      final normal = DiseaseInfo.getById('normal');
      expect(normal, isNotNull);
      expect(normal!.name, 'Daun Tampak Sehat');
    });

    test('DetectionResult state model konsisten dan tidak ambigu', () {
      final initial = DetectionResult.initial();
      expect(initial.status, DetectionStatus.initial);

      final disease = DetectionResult.disease(
        labelId: 'brown_spot',
        displayName: 'Bercak Coklat',
        confidence: 0.88,
        imagePath: '/test/image.jpg',
        description: 'Bercak oval terdeteksi',
      );
      expect(disease.status, DetectionStatus.diseaseDetected);
      expect(disease.confidence, 0.88);

      final healthy = DetectionResult.healthy(
        confidence: 0.95,
        imagePath: '/test/leaf.jpg',
      );
      expect(healthy.status, DetectionStatus.healthy);
      expect(healthy.labelId, 'normal');

      final uncertain = DetectionResult.uncertain(
        confidence: 0.42,
        imagePath: '/test/blurry.jpg',
      );
      expect(uncertain.status, DetectionStatus.uncertain);

      final error = DetectionResult.error(
        errorType: DetectionErrorType.modelLoadFailed,
        message: 'Model belum dimuat',
      );
      expect(error.status, DetectionStatus.error);
      expect(error.errorType, DetectionErrorType.modelLoadFailed);
    });
  });
}
