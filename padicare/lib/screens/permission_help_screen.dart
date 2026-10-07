import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme/app_theme.dart';

class PermissionHelpScreen extends StatelessWidget {
  const PermissionHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan Izin Akses'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AgroColors.warningBg,
                          shape: BoxShape.circle,
                          border: Border.all(color: AgroColors.warningBorder),
                        ),
                        child: const Icon(
                          Icons.security,
                          size: 36,
                          color: AgroColors.warning,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Izin Akses Kamera & Galeri Diperlukan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AgroColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Untuk memeriksa foto daun padi secara offline, PadiCare memerlukan izin akses kamera saat mengambil foto langsung atau izin media saat memilih gambar dari galeri.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AgroColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Cara Mengaktifkan Izin di Android:',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AgroColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildStep(
                      step: '1',
                      title: 'Tekan tombol "Buka Pengaturan Aplikasi" di bawah.',
                      desc: 'Anda akan dialihkan ke halaman info aplikasi PadiCare di sistem Android.',
                    ),
                    const SizedBox(height: 10),
                    _buildStep(
                      step: '2',
                      title: 'Pilih menu "Izin" atau "Permissions".',
                      desc: 'Cari kategori Kamera dan Foto/Media.',
                    ),
                    const SizedBox(height: 10),
                    _buildStep(
                      step: '3',
                      title: 'Ubah status menjadi "Izinkan" atau "Allow".',
                      desc: 'Setelah diizinkan, kembali ke aplikasi PadiCare dan coba ambil foto kembali.',
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => openAppSettings(),
                icon: const Icon(Icons.settings),
                label: const Text('Buka Pengaturan Aplikasi'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required String step,
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AgroColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AgroColors.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: AgroColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AgroColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AgroColors.textSecondary,
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
