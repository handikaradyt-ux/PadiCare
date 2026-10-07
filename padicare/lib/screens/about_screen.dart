import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang PadiCare'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AgroColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.eco,
                  size: 44,
                  color: AgroColors.onSecondaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'PadiCare',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AgroColors.textPrimary,
                ),
              ),
            ),
            const Center(
              child: Text(
                'Versi 1.0.0 (MVP Akademis)',
                style: TextStyle(
                  fontSize: 13,
                  color: AgroColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionCard(
              icon: Icons.school_outlined,
              title: 'Latar Belakang Proyek',
              content:
                  'PadiCare dikembangkan sebagai luaran mata kuliah Mobile Programming. Bertujuan mendemonstrasikan implementasi klasifikasi citra di perangkat (on-device machine learning) menggunakan arsitektur MobileNetV3 dan TensorFlow Lite pada platform Flutter Android.',
            ),
            const SizedBox(height: 14),
            _buildSectionCard(
              icon: Icons.phonelink_lock,
              title: 'Privasi & Pemrosesan Lokal',
              content:
                  'Seluruh proses inferensi citra berlangsung secara offline di dalam ponsel pengguna tanpa transmisi data ke server luar (cloud). Berkas foto kamera atau galeri hanya disimpan sementara di penyimpanan lokal perangkat untuk keperluan analisis visual.',
            ),
            const SizedBox(height: 14),
            _buildSectionCard(
              icon: Icons.warning_amber_rounded,
              title: 'Batasan Penting Model AI',
              iconColor: AgroColors.warning,
              content:
                  'Model AI hanya dilatih untuk mengenali kelas tertentu (Bercak Coklat, Hawar Daun Bakteri, dan Daun Sehat). Foto di luar kelas latih atau foto bukan daun padi dapat menghasilkan prediksi keliru. Hasil analisis merupakan dugaan awal mandiri, bukan diagnosis agronomis mutlak.',
            ),
            const SizedBox(height: 14),
            _buildSectionCard(
              icon: Icons.support_agent,
              title: 'Rujukan & Pendampingan Lapangan',
              content:
                  'Untuk kepastian gejala penyakit, penentuan ambang ekonomi, dan tindakan pengendalian hama/penyakit terpadu, petani dianjurkan berkonsultasi langsung dengan Petugas Penyuluh Lapangan (PPL) atau Balai Penyuluhan Pertanian (BPP) setempat.',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required String content,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AgroColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AgroColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: iconColor ?? AgroColors.secondary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AgroColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              color: AgroColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
