import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum PhotoSourceChoice {
  camera,
  gallery,
}

class SourcePickerSheet extends StatelessWidget {
  const SourcePickerSheet({super.key});

  static Future<PhotoSourceChoice?> show(BuildContext context) {
    return showModalBottomSheet<PhotoSourceChoice>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const SourcePickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AgroColors.cardSurface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x28000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AgroColors.outlineDark,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Pilih Sumber Foto',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AgroColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Ambil foto satu daun padi di lahan atau pilih berkas citra yang sudah ada di galeri.',
                style: TextStyle(
                  fontSize: 13,
                  color: AgroColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              _buildOptionCard(
                context: context,
                icon: Icons.photo_camera,
                iconBg: AgroColors.secondaryContainer,
                iconColor: AgroColors.onSecondaryContainer,
                title: 'Kamera Perangkat',
                description: 'Potret satu daun padi secara langsung di bawah cahaya merata.',
                onTap: () => Navigator.of(context).pop(PhotoSourceChoice.camera),
              ),
              const SizedBox(height: 12),
              _buildOptionCard(
                context: context,
                icon: Icons.photo_library_outlined,
                iconBg: AgroColors.surfaceVariant,
                iconColor: AgroColors.primary,
                title: 'Galeri Foto',
                description: 'Pilih foto daun padi yang sudah tersimpan di penyimpanan perangkat.',
                onTap: () => Navigator.of(context).pop(PhotoSourceChoice.gallery),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: AgroColors.outline),
                ),
                child: const Text(
                  'Batal',
                  style: TextStyle(
                    color: AgroColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AgroColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AgroColors.outline, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AgroColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AgroColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AgroColors.textSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
