import 'package:flutter/material.dart';
import '../models/detection_result.dart';
import '../services/classifier_service.dart';
import '../services/image_picker_service.dart';
import '../theme/app_theme.dart';
import '../widgets/error_view.dart';
import '../widgets/offline_badge.dart';
import '../widgets/source_picker_sheet.dart';
import 'about_screen.dart';
import 'disease_info_screen.dart';
import 'permission_help_screen.dart';
import 'photo_guide_screen.dart';
import 'preview_screen.dart';

class HomeScreen extends StatefulWidget {
  final ClassifierService classifierService;

  const HomeScreen({
    super.key,
    required this.classifierService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePickerService _pickerService = ImagePickerService();
  bool _isLoading = false;

  Future<void> _handleStartDetection() async {
    final choice = await SourcePickerSheet.show(context);
    if (choice == null) return;

    setState(() => _isLoading = true);

    final PickResult result = choice == PhotoSourceChoice.camera
        ? await _pickerService.pickFromCamera()
        : await _pickerService.pickFromGallery();

    setState(() => _isLoading = false);

    if (!mounted) return;

    switch (result.status) {
      case PickResultStatus.success:
        if (result.filePath != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PreviewScreen(
                initialImagePath: result.filePath!,
                classifierService: widget.classifierService,
              ),
            ),
          );
        }
        break;

      case PickResultStatus.permissionDenied:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const PermissionHelpScreen(),
          ),
        );
        break;

      case PickResultStatus.fileError:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ErrorView(
              errorType: DetectionErrorType.imageReadFailed,
              customMessage: result.errorMessage,
              onRetry: _handleStartDetection,
              onBack: () => Navigator.of(context).pop(),
            ),
          ),
        );
        break;

      case PickResultStatus.cancelled:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AgroColors.secondaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.eco,
                color: AgroColors.onSecondaryContainer,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text('PadiCare'),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(child: OfflineBadge()),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Banner / Title Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AgroColors.cardSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AgroColors.outline),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AgroColors.secondaryContainer.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.energy_savings_leaf,
                        size: 38,
                        color: AgroColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'PadiCare',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AgroColors.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: AgroColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.eco, size: 14, color: AgroColors.secondary),
                          SizedBox(width: 6),
                          Text(
                            'Pemeriksaan Awal Gejala Daun Padi',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AgroColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Aplikasi bantu untuk deteksi dini gejala visual bercak pada satu foto daun padi secara langsung di ponsel tanpa koneksi internet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: AgroColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Mulai Deteksi Utama
              ElevatedButton(
                onPressed: _isLoading ? null : _handleStartDetection,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo_camera, size: 22),
                          SizedBox(width: 10),
                          Text(
                            'Mulai Deteksi Daun',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 12),

              // Grid Menu Bantuan: Panduan Foto, Informasi Penyakit & Tentang PadiCare
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PhotoGuideScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      ),
                      icon: const Icon(Icons.menu_book, size: 18),
                      label: const Text('Panduan Foto'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DiseaseInfoScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      ),
                      icon: const Icon(Icons.coronavirus_outlined, size: 18),
                      label: const Text('Info Penyakit'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.info_outline, size: 18),
                label: const Text('Tentang PadiCare & Batasan'),
              ),
              const SizedBox(height: 20),

              // Catatan Pemeriksaan Awal (Disclaimer PRD)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AgroColors.surfaceVariant.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AgroColors.outline),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info, size: 20, color: AgroColors.primary),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Catatan Pemeriksaan Awal',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AgroColors.primary,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Hasil analisis merupakan pemeriksaan awal mandiri di lapangan, bukan diagnosis pasti. Konsultasikan kondisi tanaman dengan Petugas Penyuluh Lapangan (PPL).',
                            style: TextStyle(
                              fontSize: 12,
                              color: AgroColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
