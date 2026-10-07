import 'dart:io';
import 'package:flutter/material.dart';
import '../models/detection_result.dart';
import '../services/classifier_service.dart';
import '../services/image_picker_service.dart';
import '../theme/app_theme.dart';
import '../widgets/error_view.dart';
import '../widgets/source_picker_sheet.dart';
import '../widgets/status_badge.dart';
import 'result_screen.dart';

class PreviewScreen extends StatefulWidget {
  final String initialImagePath;
  final ClassifierService classifierService;

  const PreviewScreen({
    super.key,
    required this.initialImagePath,
    required this.classifierService,
  });

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late String _currentImagePath;
  bool _isAnalyzing = false;
  DetectionResult? _errorResult;

  final ImagePickerService _pickerService = ImagePickerService();

  @override
  void initState() {
    super.initState();
    _currentImagePath = widget.initialImagePath;
  }

  Future<void> _changePhoto() async {
    final choice = await SourcePickerSheet.show(context);
    if (choice == null) return;

    final PickResult result = choice == PhotoSourceChoice.camera
        ? await _pickerService.pickFromCamera()
        : await _pickerService.pickFromGallery();

    if (result.status == PickResultStatus.success && result.filePath != null) {
      setState(() {
        _currentImagePath = result.filePath!;
        _errorResult = null;
      });
    } else if (result.status == PickResultStatus.permissionDenied) {
      setState(() {
        _errorResult = DetectionResult.error(
          errorType: DetectionErrorType.permissionDenied,
          message: result.errorMessage ?? 'Izin kamera ditolak.',
        );
      });
    } else if (result.status == PickResultStatus.fileError) {
      setState(() {
        _errorResult = DetectionResult.error(
          errorType: DetectionErrorType.imageReadFailed,
          message: result.errorMessage ?? 'Berkas foto tidak dapat dibaca.',
        );
      });
    }
  }

  Future<void> _startAnalysis() async {
    setState(() {
      _isAnalyzing = true;
      _errorResult = null;
    });

    try {
      // Tunggu simulasi singkat / proses inferensi TFLite
      final result = await widget.classifierService.classify(_currentImagePath);

      if (!mounted) return;

      if (result.status == DetectionStatus.error) {
        setState(() {
          _isAnalyzing = false;
          _errorResult = result;
        });
      } else {
        setState(() {
          _isAnalyzing = false;
        });

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              result: result,
              classifierService: widget.classifierService,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isAnalyzing = false;
        _errorResult = DetectionResult.error(
          errorType: DetectionErrorType.inferenceFailed,
          message: 'Terjadi kendala teknis saat memproses foto: ${e.toString()}',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorResult != null) {
      return ErrorView(
        errorType: _errorResult!.errorType,
        customMessage: _errorResult!.errorMessage,
        onRetry: () {
          setState(() {
            _errorResult = null;
          });
          _startAnalysis();
        },
        onBack: () => Navigator.of(context).pop(),
      );
    }

    if (_isAnalyzing) {
      return _buildAnalyzingState(); // Layar 6: Proses Analisis Offline
    }

    return _buildPreviewState(); // Layar 5: Pratinjau Foto
  }

  Widget _buildPreviewState() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pratinjau Foto Daun'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Ganti Foto',
            onPressed: _changePhoto,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 380,
                            width: double.infinity,
                            color: Colors.black12,
                            child: Image.file(
                              File(_currentImagePath),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AgroColors.surfaceVariant,
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.broken_image, size: 48, color: AgroColors.error),
                                        SizedBox(height: 8),
                                        Text('Berkas foto tidak dapat dimuat'),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: 14,
                          left: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle, size: 14, color: AgroColors.secondaryContainer),
                                SizedBox(width: 5),
                                Text(
                                  'Foto dipilih',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AgroColors.cardSurface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AgroColors.outline),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, size: 20, color: AgroColors.secondary),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Pastikan satu helai daun padi terlihat fokus dan tidak terpotong sebelum memulai analisis.',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: AgroColors.textSecondary,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AgroColors.cardSurface,
                border: Border(top: BorderSide(color: AgroColors.outline)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: _startAnalysis,
                    icon: const Icon(Icons.psychology_outlined),
                    label: const Text('Analisis Foto Daun'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: _changePhoto,
                    icon: const Icon(Icons.cameraswitch_outlined),
                    label: const Text('Ganti / Ambil Ulang Foto'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzingState() {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AgroColors.secondaryContainer.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(AgroColors.secondary),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Menganalisis Gejala Daun...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AgroColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Memproses citra daun padi menggunakan model MobileNetV3 secara offline di perangkat Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AgroColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              const StatusBadge(
                label: 'Inferensi 100% Offline di Perangkat',
                icon: Icons.cloud_off,
                variant: BadgeVariant.healthy,
              ),
              const Spacer(),
              const Text(
                'Tidak ada data foto yang diunggah ke internet.',
                style: TextStyle(
                  fontSize: 12,
                  color: AgroColors.textMuted,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
