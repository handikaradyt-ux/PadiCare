import 'package:flutter/material.dart';
import '../models/disease_info.dart';
import '../theme/app_theme.dart';

class DiseaseInfoScreen extends StatelessWidget {
  final String? initialDiseaseId;

  const DiseaseInfoScreen({super.key, this.initialDiseaseId});

  @override
  Widget build(BuildContext context) {
    final diseases = DiseaseInfo.allDiseases;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Penyakit Padi'),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: diseases.length,
          itemBuilder: (context, index) {
            final item = diseases[index];
            final isHighlighted = item.id == initialDiseaseId;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AgroColors.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isHighlighted ? AgroColors.primary : AgroColors.outline,
                  width: isHighlighted ? 2 : 1,
                ),
                boxShadow: isHighlighted
                    ? [
                        BoxShadow(
                          color: AgroColors.primary.withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: item.id == 'normal'
                                ? AgroColors.healthyBg
                                : AgroColors.warningBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            item.id == 'normal'
                                ? Icons.check_circle_outline
                                : Icons.coronavirus_outlined,
                            color: item.id == 'normal'
                                ? AgroColors.healthy
                                : AgroColors.warning,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AgroColors.textPrimary,
                                ),
                              ),
                              Text(
                                item.scientificName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: AgroColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.summary,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AgroColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Ciri Gejala Visual:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AgroColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...item.visualSymptoms.map(
                      (s) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(color: AgroColors.secondary, fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Text(
                                s,
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
                    const SizedBox(height: 12),
                    const Text(
                      'Langkah Pemeriksaan & Tindak Lanjut:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AgroColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...item.followUpSteps.map(
                      (step) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('✓ ', style: TextStyle(color: AgroColors.primary, fontWeight: FontWeight.bold)),
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
                    const Divider(height: 24, color: AgroColors.outline),
                    Row(
                      children: [
                        const Icon(Icons.source_outlined, size: 14, color: AgroColors.textMuted),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Sumber: ${item.agriculturalSource}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AgroColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
