import 'dart:io';
import 'package:flutter/material.dart';
import '../models/detection_result.dart';
import '../models/disease_info.dart';
import '../services/classifier_service.dart';
import '../theme/app_theme.dart';
import '../widgets/status_badge.dart';
import 'disease_info_screen.dart';

class ResultScreen extends StatelessWidget {
  final DetectionResult result;
  final ClassifierService classifierService;

  const ResultScreen({
    super.key,
    required this.result,
    required this.classifierService,
  });

  @override
  Widget build(BuildContext context) {
    final bool isHealthy = result.status == DetectionStatus.healthy;
    final bool isUncertain = result.status == DetectionStatus.uncertain;
    final bool isDisease = result.status == DetectionStatus.diseaseDetected;

    final diseaseInfo = result.labelId != null
        ? DiseaseInfo.getById(result.labelId!)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dugaan Hasil Pemeriksaan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Pratinjau Foto yang Diperiksa
                  if (result.imagePath != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 220,
                        width: double.infinity,
                        color: Colors.black12,
                        child: Image.file(
                          File(result.imagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: AgroColors.surfaceVariant,
                            child: const Center(
                              child: Icon(Icons.broken_image, size: 40, color: AgroColors.textMuted),
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Status Badge & Dugaan Hasil
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderBadge(isHealthy, isUncertain, isDisease),
                      if (result.confidence != null && !isUncertain)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AgroColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AgroColors.outline),
                          ),
                          child: Text(
                            'Skor Model: ${(result.confidence! * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AgroColors.textPrimary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Judul Penyakit / Status
                  Text(
                    result.displayName ?? 'Pemeriksaan Daun Padi',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: isHealthy
                          ? AgroColors.healthy
                          : (isUncertain ? AgroColors.uncertain : AgroColors.warning),
                    ),
                  ),
                  if (diseaseInfo != null && diseaseInfo.scientificName.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        diseaseInfo.scientificName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: AgroColors.textMuted,
                        ),
                      ),
                    ),
                  const SizedBox(height: 14),

                  // Deskripsi Hasil
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AgroColors.cardSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AgroColors.outline),
                    ),
                    child: Text(
                      result.description ?? '',
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: AgroColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Petunjuk Tindak Lanjut Awal
                  if (isDisease && diseaseInfo != null)
                    _buildFollowUpCard(diseaseInfo)
                  else if (isHealthy)
                    _buildHealthyCareCard()
                  else if (isUncertain)
                    _buildUncertainGuideCard(),

                  const SizedBox(height: 14),

                  // Peringatan Batasan Diagnosis
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AgroColors.uncertainBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AgroColors.uncertainBorder),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, size: 18, color: AgroColors.uncertain),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Catatan: Hasil analisis ini merupakan bantuan pemeriksaan awal mandiri di perangkat dan bukan diagnosis agronomis pasti. Konsultasikan perkembangan tanaman dengan Petugas Penyuluh Lapangan (PPL).',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AgroColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Bagian Tombol Aksi Bawah
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AgroColors.cardSurface,
                border: Border(top: BorderSide(color: AgroColors.outline)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isDisease && diseaseInfo != null) ...[
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DiseaseInfoScreen(
                              initialDiseaseId: diseaseInfo.id,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.menu_book),
                      label: const Text('Pelajari Informasi Penyakit'),
                    ),
                    const SizedBox(height: 10),
                  ],
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    icon: const Icon(Icons.add_a_photo_outlined),
                    label: Text(
                      isUncertain ? 'Ambil Foto Ulang Sekarang' : 'Periksa Foto Lain',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBadge(bool isHealthy, bool isUncertain, bool isDisease) {
    if (isHealthy) {
      return const StatusBadge(
        label: 'Daun Tampak Sehat',
        icon: Icons.check_circle,
        variant: BadgeVariant.healthy,
      );
    } else if (isUncertain) {
      return const StatusBadge(
        label: 'Perlu Verifikasi Ulang',
        icon: Icons.help_outline,
        variant: BadgeVariant.uncertain,
      );
    } else {
      return const StatusBadge(
        label: 'Dugaan Gejala Penyakit',
        icon: Icons.warning_amber_rounded,
        variant: BadgeVariant.warning,
      );
    }
  }

  Widget _buildFollowUpCard(DiseaseInfo info) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AgroColors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AgroColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.checklist, size: 18, color: AgroColors.primary),
              SizedBox(width: 8),
              Text(
                'Langkah Pengamatan Awal Lapangan:',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AgroColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...info.followUpSteps.take(3).map(
                (step) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: AgroColors.primary, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Text(
                          step,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AgroColors.textSecondary,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildHealthyCareCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AgroColors.healthyBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AgroColors.healthyBorder),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.eco, size: 18, color: AgroColors.healthy),
              SizedBox(width: 8),
              Text(
                'Anjuran Perawatan Pencegahan:',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AgroColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '• Lakukan monitoring rutin berkala seminggu sekali pada petak sawah.\n• Pertahankan pengairan berselang dan pemupukan N-P-K berimbang.\n• Jaga sanitasi pematang sawah dari gulma yang berpotensi menjadi sarang hama.',
            style: TextStyle(
              fontSize: 12.5,
              color: AgroColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUncertainGuideCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AgroColors.uncertainBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AgroColors.uncertainBorder),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tips_and_updates_outlined, size: 18, color: AgroColors.uncertain),
              SizedBox(width: 8),
              Text(
                'Saran Pengambilan Foto Ulang:',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AgroColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '1. Dekatkan kamera pada satu helai daun yang paling jelas menunjukkan bercak.\n2. Pastikan pencahayaan cukup terang dan daun tidak bergoyang.\n3. Hindari memotret daun yang tertutup bayangan atau banyak daun bertumpuk.',
            style: TextStyle(
              fontSize: 12.5,
              color: AgroColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
