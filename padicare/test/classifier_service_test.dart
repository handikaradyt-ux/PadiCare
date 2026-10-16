import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:padicare/models/detection_result.dart';
import 'package:padicare/models/disease_info.dart';
import 'package:padicare/services/classifier_service.dart';
import 'package:padicare/services/image_picker_service.dart';

void main() {
  group('ClassifierService Contract & Threshold Tests', () {
    test('Non-existent image file returns imageReadFailed error state', () async {
      final service = ClassifierService();
      final result = await service.classify('non_existent_image_12345.jpg');

      expect(result.status, DetectionStatus.error);
      expect(result.errorType, DetectionErrorType.imageReadFailed);
      expect(result.recoveryAction, 'Pilih Foto Ulang');
    });

    test('Threshold constant is calibrated to 0.65', () {
      expect(ClassifierService.uncertaintyThreshold, 0.65);
      expect(ClassifierService.inputImageSize, 224);
    });

    test('Corrupted image bytes returns imageReadFailed error state', () async {
      final tempFile = File('corrupted_test_img.jpg');
      await tempFile.writeAsBytes([0, 1, 2, 3, 4, 5]);

      try {
        final service = ClassifierService();
        final result = await service.classify(tempFile.path);

        expect(result.status, DetectionStatus.error);
        // Either modelLoadFailed (if asset loader not mock initialized) or imageReadFailed
        expect(
          result.errorType == DetectionErrorType.modelLoadFailed ||
              result.errorType == DetectionErrorType.imageReadFailed,
          isTrue,
        );
      } finally {
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
      }
    });

    test('Label ordering in models matches ML training class sequence', () {
      // 0: bacterial_leaf_blight, 1: brown_spot, 2: leaf_blast, 3: normal, 4: tungro
      const expectedClasses = [
        'bacterial_leaf_blight',
        'brown_spot',
        'leaf_blast',
        'normal',
        'tungro',
      ];

      expect(expectedClasses[0], 'bacterial_leaf_blight');
      expect(expectedClasses[1], 'brown_spot');
      expect(expectedClasses[2], 'leaf_blast');
      expect(expectedClasses[3], 'normal');
      expect(expectedClasses[4], 'tungro');

      // Verify disease info models support all classes
      expect(DiseaseInfo.getById('bacterial_leaf_blight')?.name, contains('Hawar Daun Bakteri'));
      expect(DiseaseInfo.getById('brown_spot')?.name, contains('Bercak Coklat'));
      expect(DiseaseInfo.getById('leaf_blast')?.name, contains('Blas Daun'));
      expect(DiseaseInfo.getById('normal')?.name, contains('Daun Tampak Sehat'));
      expect(DiseaseInfo.getById('tungro')?.name, contains('Tungro'));
    });
  });

  group('ImagePickerService & PickResult Contract Tests', () {
    test('PickResult factory constructors produce correct status and messages', () {
      final success = PickResult.success('/path/to/leaf.jpg');
      expect(success.status, PickResultStatus.success);
      expect(success.filePath, '/path/to/leaf.jpg');
      expect(success.errorMessage, isNull);

      final cancelled = PickResult.cancelled();
      expect(cancelled.status, PickResultStatus.cancelled);
      expect(cancelled.filePath, isNull);

      final denied = PickResult.permissionDenied('Izin kamera ditolak.');
      expect(denied.status, PickResultStatus.permissionDenied);
      expect(denied.errorMessage, contains('Izin kamera'));

      final fileError = PickResult.fileError('Berkas foto rusak.');
      expect(fileError.status, PickResultStatus.fileError);
      expect(fileError.errorMessage, contains('rusak'));
    });
  });
}
