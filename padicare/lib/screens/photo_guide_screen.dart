import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PhotoGuideScreen extends StatelessWidget {
  const PhotoGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panduan Foto Daun'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AgroColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AgroColors.outline),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AgroColors.secondaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.lightbulb_outline,
                            color: AgroColors.onSecondaryContainer,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kualitas Foto Menentukan Hasil',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AgroColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Model MobileNetV3 bekerja optimal pada citra dengan fokus tajam dan warna daun yang tampak alami.',
                                style: TextStyle(
                                  fontSize: 13,
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
                  const SizedBox(height: 20),
                  const Text(
                    '4 Langkah Pengambilan Foto yang Tepat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AgroColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildGuideItem(
                    number: '1',
                    title: 'Fokus pada Satu Helai Daun',
                    description:
                        'Arahkan kamera pada satu helai daun padi yang memperlihatkan gejala bercak atau perubahan warna paling jelas.',
                    icon: Icons.filter_center_focus,
                  ),
                  const SizedBox(height: 12),
                  _buildGuideItem(
                    number: '2',
                    title: 'Pencahayaan Terang & Merata',
                    description:
                        'Ambil foto di bawah cahaya alami terbuka. Hindari bayangan badan atau silau pantulan air sawah.',
                    icon: Icons.wb_sunny_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildGuideItem(
                    number: '3',
                    title: 'Jaga Kamera Stabil & Tidak Buram',
                    description:
                        'Tahan helai daun perlahan bila tertiup angin sawah. Pastikan kamera tidak buram (out-of-focus) saat memotret.',
                    icon: Icons.camera_alt_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildGuideItem(
                    number: '4',
                    title: 'Latar Belakang Tidak Menutupi Bercak',
                    description:
                        'Hindari jari tangan, sarung tangan, atau banyak daun lain saling bertumpuk menutupi bagian bercak tanaman.',
                    icon: Icons.layers_clear_outlined,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AgroColors.cardSurface,
                border: Border(top: BorderSide(color: AgroColors.outline)),
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Saya Paham, Siap Ambil Foto'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideItem({
    required String number,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AgroColors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AgroColors.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AgroColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AgroColors.textPrimary,
                        ),
                      ),
                    ),
                    Icon(icon, size: 18, color: AgroColors.secondary),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
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
    );
  }
}
