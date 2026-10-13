import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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

  /// Mengambil data foto yang mungkin hilang jika sistem Android menutup aktivitas
  /// utama saat aplikasi kamera sistem sedang berada di latar depan.
  Future<PickResult?> retrieveLostData() async {
    if (kIsWeb || !Platform.isAndroid) return null;

    try {
      final LostDataResponse response = await _picker.retrieveLostData();
      if (response.isEmpty) {
        return null;
      }

      final file = response.file;
      if (file != null) {
        final localFile = File(file.path);
        if (await localFile.exists() && await localFile.length() > 0) {
          return PickResult.success(file.path);
        } else {
          return PickResult.fileError(
            'Foto yang dipulihkan dari kamera sistem rusak atau berukuran 0 byte.',
          );
        }
      }

      if (response.exception != null) {
        final exc = response.exception!;
        if (exc.code == 'camera_access_denied') {
          return PickResult.permissionDenied(
            'Izin kamera ditolak saat pemulihan sesi kamera.',
          );
        }
        return PickResult.fileError(
          'Gagal memulihkan foto kamera (${exc.code}): ${exc.message ?? ''}',
        );
      }
    } catch (e) {
      // Abaikan jika pemulihan tidak menghasilkan data
    }
    return null;
  }

  Future<PickResult> pickFromCamera() async {
    try {
      // Periksa status izin kamera sebelum memanggil intent sistem
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        var cameraStatus = await Permission.camera.status;
        if (!cameraStatus.isGranted && !cameraStatus.isLimited) {
          cameraStatus = await Permission.camera.request();
        }

        if (cameraStatus.isPermanentlyDenied ||
            cameraStatus.isDenied ||
            cameraStatus.isRestricted) {
          return PickResult.permissionDenied(
            'Izin kamera diperlukan untuk mengambil foto daun padi secara langsung. Silakan aktifkan izin kamera pada pengaturan aplikasi.',
          );
        }
      }

      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
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
    } on PlatformException catch (e) {
      if (e.code == 'camera_access_denied') {
        return PickResult.permissionDenied(
          'Akses kamera ditolak oleh sistem perangkat. Silakan berikan izin kamera di pengaturan.',
        );
      }
      return PickResult.fileError(
        'Kendala platform saat mengakses kamera (${e.code}): ${e.message ?? 'Aplikasi kamera tidak dapat dibuka.'}',
      );
    } catch (e) {
      return PickResult.fileError(
        'Terjadi kendala saat mengakses kamera: ${e.toString()}',
      );
    }
  }

  Future<PickResult> pickFromGallery() async {
    try {
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
    } on PlatformException catch (e) {
      return PickResult.fileError(
        'Kendala platform saat mengakses galeri (${e.code}): ${e.message ?? 'Galeri tidak dapat dibuka.'}',
      );
    } catch (e) {
      return PickResult.fileError(
        'Gagal memuat berkas foto dari galeri: ${e.toString()}',
      );
    }
  }
}
