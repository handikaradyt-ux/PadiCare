import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

enum PickResultStatus {
  success,
  cancelled,
  permissionDenied,
  fileError,
}

class PickResult {
  final PickResultStatus status;
  final String? filePath;
  final String? errorMessage;

  const PickResult({
    required this.status,
    this.filePath,
    this.errorMessage,
  });

  factory PickResult.success(String path) => PickResult(
        status: PickResultStatus.success,
        filePath: path,
      );

  factory PickResult.cancelled() => const PickResult(
        status: PickResultStatus.cancelled,
      );

  factory PickResult.permissionDenied(String message) => PickResult(
        status: PickResultStatus.permissionDenied,
        errorMessage: message,
      );

  factory PickResult.fileError(String message) => PickResult(
        status: PickResultStatus.fileError,
        errorMessage: message,
      );
}

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<PickResult> pickFromCamera() async {
    try {
      // Periksa izin kamera pada platform bergerak
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        final cameraStatus = await Permission.camera.request();
        if (cameraStatus.isPermanentlyDenied || cameraStatus.isDenied) {
          return PickResult.permissionDenied(
            'Izin kamera diperlukan untuk mengambil foto daun padi secara langsung. Silakan aktifkan izin kamera pada pengaturan aplikasi.',
          );
        }
      }

      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 90,
      );

      if (pickedFile == null) {
        return PickResult.cancelled();
      }

      final file = File(pickedFile.path);
      if (!await file.exists() || await file.length() == 0) {
        return PickResult.fileError(
          'Berkas foto tidak dapat dibaca atau rusak dari kamera. Silakan coba ambil foto ulang.',
        );
      }

      return PickResult.success(pickedFile.path);
    } catch (e) {
      return PickResult.fileError(
        'Terjadi kendala saat mengakses kamera: ${e.toString()}',
      );
    }
  }

  Future<PickResult> pickFromGallery() async {
    try {
      // Ambil berkas dari galeri perangkat
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 90,
      );

      if (pickedFile == null) {
        return PickResult.cancelled();
      }

      final file = File(pickedFile.path);
      if (!await file.exists() || await file.length() == 0) {
        return PickResult.fileError(
          'Berkas foto yang dipilih dari galeri tidak valid atau berukuran kosong.',
        );
      }

      return PickResult.success(pickedFile.path);
    } catch (e) {
      return PickResult.fileError(
        'Gagal memuat berkas foto dari galeri: ${e.toString()}',
      );
    }
  }
}
