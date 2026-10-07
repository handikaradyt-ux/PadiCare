import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/detection_result.dart';
import '../theme/app_theme.dart';

class ErrorView extends StatelessWidget {
  final DetectionErrorType errorType;
  final String? customMessage;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  const ErrorView({
    super.key,
    required this.errorType,
    this.customMessage,
    required this.onRetry,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(errorType);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kendala Pemeriksaan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AgroColors.errorBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: AgroColors.errorBorder, width: 2),
                  ),
                  child: Icon(
                    config.icon,
                    size: 40,
                    color: AgroColors.error,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                config.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AgroColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                customMessage ?? config.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AgroColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  if (errorType == DetectionErrorType.permissionDenied) {
                    openAppSettings();
                  } else {
                    onRetry();
                  }
                },
                icon: Icon(
                  errorType == DetectionErrorType.permissionDenied
                      ? Icons.settings
                      : Icons.refresh,
                ),
                label: Text(
                  errorType == DetectionErrorType.permissionDenied
                      ? 'Buka Pengaturan Izin'
                      : config.primaryActionLabel,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onBack,
                child: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _ErrorConfig _getConfig(DetectionErrorType type) {
    switch (type) {
      case DetectionErrorType.permissionDenied:
        return _ErrorConfig(
          title: 'Izin Akses Kamera Ditolak',
          description:
              'Aplikasi memerlukan izin kamera untuk mengambil foto daun padi di lahan. Aktifkan izin pada pengaturan aplikasi di ponsel Anda.',
          icon: Icons.no_photography_outlined,
          primaryActionLabel: 'Buka Pengaturan Izin',
        );
      case DetectionErrorType.imageReadFailed:
        return _ErrorConfig(
          title: 'Berkas Foto Tidak Terbaca',
          description:
              'Foto yang dipilih rusak, kosong, atau tidak dapat dimuat dari memori. Silakan coba ambil atau pilih foto lain.',
          icon: Icons.broken_image_outlined,
          primaryActionLabel: 'Pilih Foto Ulang',
        );
      case DetectionErrorType.modelLoadFailed:
        return _ErrorConfig(
          title: 'Model Belum Tersedia di Perangkat',
          description:
              'Berkas model TensorFlow Lite MobileNetV3 belum dimuat ke memori perangkat. Pemeriksaan model offline belum dapat diproses.',
          icon: Icons.memory_outlined,
          primaryActionLabel: 'Coba Muat Ulang Model',
        );
      case DetectionErrorType.inferenceFailed:
      case DetectionErrorType.none:
        return _ErrorConfig(
          title: 'Analisis Citra Gagal Diproses',
          description:
              'Terjadi kendala saat memproses tensor citra daun pada prosesor perangkat. Pastikan foto berfokus jelas pada daun padi.',
          icon: Icons.error_outline,
          primaryActionLabel: 'Coba Analisis Ulang',
        );
    }
  }
}

class _ErrorConfig {
  final String title;
  final String description;
  final IconData icon;
  final String primaryActionLabel;

  _ErrorConfig({
    required this.title,
    required this.description,
    required this.icon,
    required this.primaryActionLabel,
  });
}
