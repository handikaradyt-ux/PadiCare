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
        'Gunakan benih sehat dan varietis tahan pada musim tanam berikutnya sesuai anjuran PPL.',
      ],
      agriculturalSource: 'Pedoman Diagnosis Penyakit Padi IRRI & Balitpa Kementan',
    ),
    DiseaseInfo(
      id: 'leaf_blast',
      name: 'Blas Daun (Leaf Blast)',
      scientificName: 'Pyricularia oryzae / Magnaporthe oryzae',
      summary:
          'Penyakit jamur berbahaya pada padi yang menyerang daun pada fase vegetatif, dipicu oleh kelembapan tinggi, embun malam yang lama, serta pemupukan N tinggi.',
      visualSymptoms: [
        'Lesi khas berbentuk belah ketupat atau kumparan (spindle-shaped) dengan kedua ujung meruncing.',
        'Bagian tengah bercak berwarna abu-abu keputihan dengan batas tepi coklat kemerahan atau coklat gelap.',
        'Pada serangan parah, lesi saling menyatu menyebabkan daun tampak terbakar dan mengering.',
      ],
      followUpSteps: [
        'Gunakan varietas tahan blas yang adaptif setempat (misal varietas Inpari spesifik anjuran).',
        'Atur jarak tanam lebih renggang (seperti pola jajar legowo) untuk sirkulasi udara optimal.',
        'Kurangi dosis pupuk nitrogen dan imbangi dengan pemupukan fosfat dan kalium yang cukup.',
        'Konsultasikan aplikasi fungisida anjuran dengan Petugas Penyuluh Lapangan (PPL) jika gejala meluas.',
      ],
      agriculturalSource: 'Pedoman Teknis Pengendalian Blas Padi Balitpa Kementan RI & IRRI',
    ),
    DiseaseInfo(
      id: 'normal',
      name: 'Daun Tampak Sehat',
      scientificName: 'Oryza sativa (Sehat)',
      summary:
          'Daun padi berada dalam kondisi visual normal tanpa gejala bercak nekrotik, hawar, blas, atau luka khas patogen jamur/bakteri utama.',
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
    DiseaseInfo(
      id: 'tungro',
      name: 'Penyakit Tungro',
      scientificName: 'Rice Tungro Spherical & Bacilliform Virus',
      summary:
          'Penyakit virus penting pada tanaman padi yang ditularkan oleh vektor wereng daun hijau (Nephotettix virescens), menimbulkan daun kuning kejinggaan dan kekerdilan.',
      visualSymptoms: [
        'Perubahan warna daun menjadi kuning hingga jingga-oranye dimulai dari ujung daun muda.',
        'Pertumbuhan tanaman kerdil (stunted) dengan jumlah anakan berkurang secara signifikan.',
        'Permukaan helai daun kadang tampak berbintik klorotik atau sedikit terpuntir.',
      ],
      followUpSteps: [
        'Terapkan tanam serempak dalam satu hamparan untuk memutus siklus hidup vektor dan virus.',
        'Kendalikan populasi wereng hijau sejak dini sesuai panduan ambang kendali dari penyuluh.',
        'Cabut dan musnahkan (eradikasi selektif) tanaman yang terinfeksi berat untuk mencegah penyebaran.',
        'Gunakan varietas tahan tungro yang direkomendasikan dinas pertanian setempat.',
      ],
      agriculturalSource: 'Buku Pedoman Pengendalian Tungro Balitpa Kementan & IRRI',
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
