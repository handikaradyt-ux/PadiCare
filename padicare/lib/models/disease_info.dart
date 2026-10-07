class DiseaseInfo {
  final String id;
  final String name;
  final String scientificName;
  final String summary;
  final List<String> visualSymptoms;
  final List<String> followUpSteps;
  final String agriculturalSource;

  const DiseaseInfo({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.summary,
    required this.visualSymptoms,
    required this.followUpSteps,
    required this.agriculturalSource,
  });

  static const List<DiseaseInfo> allDiseases = [
    DiseaseInfo(
      id: 'brown_spot',
      name: 'Bercak Coklat',
      scientificName: 'Bipolaris oryzae / Drechslera oryzae',
      summary:
          'Penyakit jamur yang umumnya muncul pada tanaman padi yang mengalami defisiensi hara (terutama kalium) atau kondisi tanah yang kurang subur.',
      visualSymptoms: [
        'Bercak oval atau bulat berukuran 1-3 mm pada helai daun.',
        'Pusat bercak berwarna coklat muda atau abu-abu dengan tepi coklat kemerahan.',
        'Bercak dapat membesar dan bergabung pada serangan berat sehingga daun mengering.',
      ],
      followUpSteps: [
        'Periksa status pemupukan tanaman; pastikan pemupukan kalium (K) seimbang dengan nitrogen.',
        'Lakukan sanitasi sisa tanaman dan jerami yang terinfeksi setelah panen.',
        'Atur tata kelola air agar lahan tidak mengalami kekeringan ekstrem.',
        'Konsultasikan pengamatan gejala dengan Petugas Penyuluh Lapangan (PPL) setempat.',
      ],
      agriculturalSource: 'Pedoman Diagnosis Penyakit Padi IRRI & BPTP',
    ),
    DiseaseInfo(
      id: 'bacterial_leaf_blight',
      name: 'Hawar Daun Bakteri (Kresek)',
      scientificName: 'Xanthomonas oryzae pv. oryzae',
      summary:
          'Penyakit bakteri penting pada padi yang menyerang helai daun, sering berkembang cepat pada kondisi lembap, basah, dan angin kencang.',
      visualSymptoms: [
        'Garis kebasahan (water-soaked) bermula dari ujung atau tepi daun.',
        'Lesi meluas ke bawah dan berubah menjadi kuning bergelombang, lalu memutih kekeringan.',
        'Pada pagi hari, kadang tampak tetesan eksudat bakteri kuning seperti embun di tepi luka.',
      ],
      followUpSteps: [
        'Hindari penggunaan pupuk nitrogen (Urea) secara berlebihan pada awal serangan.',
        'Terapkan pengairan berselang (intermittent irrigation) dan hindari genangan tinggi berkelanjutan.',
        'Bersihkan gulma pematang sawah yang dapat menjadi inang alternatif bakteri.',
        'Gunakan benih sehat dan varietas tahan pada musim tanam berikutnya sesuai anjuran PPL.',
      ],
      agriculturalSource: 'Pedoman Diagnosis Penyakit Padi IRRI & Balitpa Kementan',
    ),
    DiseaseInfo(
      id: 'normal',
      name: 'Daun Tampak Sehat',
      scientificName: 'Oryza sativa (Sehat)',
      summary:
          'Daun padi berada dalam kondisi visual normal tanpa gejala bercak nekrotik, hawar, atau luka khas patogen jamur/bakteri utama.',
      visualSymptoms: [
        'Warna hijau merata sesuai fase vegetatif atau generatif tanaman.',
        'Tepi dan permukaan daun utuh tanpa lesi kering atau tepi kuning terpotong.',
        'Tulang daun kokoh dan permukaan tidak bernoda coklat terkonsentrasi.',
      ],
      followUpSteps: [
        'Lakukan pengamatan berkala seminggu sekali untuk pemantauan dini.',
        'Pertahankan pemupukan berimbang spesifik lokasi sesuai panduan penyuluh.',
        'Jaga kebersihan pematang sawah dan sirkulasi air sawah.',
      ],
      agriculturalSource: 'Buku Saku Budidaya Padi Berkelanjutan Kementan RI',
    ),
  ];

  static DiseaseInfo? getById(String id) {
    try {
      return allDiseases.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }
}
