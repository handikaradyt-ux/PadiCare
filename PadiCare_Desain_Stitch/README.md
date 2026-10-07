# Paket desain PadiCare dari Stitch

Sumber: https://stitch.withgoogle.com/projects/3614904139363343705

Folder ini memuat ekspor asli Stitch (`export_asli_stitch.zip`), 12 rancangan layar atau status dalam `stitch_padicare_flutter_app_ui_design/`, ringkasan gaya dalam `agrosawah_material_system/DESIGN.md`, dan prompt implementasi untuk Antigravity. Setiap folder layar memiliki `code.html` dan `screen.png`. HTML adalah referensi visual, **bukan** kode Flutter yang siap pakai.

| No. | Folder layar | Peran dalam aplikasi |
|---|---|---|
| 1 | `1._beranda_padicare` | Beranda sederhana versi terbaru; gunakan sebagai acuan utama. |
| 2 | `2._modal_pilih_sumber_foto` | Modal kamera atau galeri. Abaikan beranda lama yang terlihat di belakang modal. |
| 3 | `3._bantuan_izin_akses` | Bantuan ketika izin akses ditolak. |
| 4 | `4._panduan_foto_daun` | Panduan mengambil satu foto daun yang jelas. |
| 5 | `5._pratinjau_foto_daun` | Pratinjau dan penggantian foto. |
| 6 | `6._proses_analisis_offline` | Status saat inferensi berlangsung. |
| 7 | `7._dugaan_penyakit_brown_spot` | Contoh tampilan hasil penyakit; label dan skor harus berasal dari model final. |
| 8 | `8._daun_tampak_sehat` | Contoh tampilan hasil daun sehat; skor `0.94` hanya contoh desain. |
| 9 | `9._hasil_belum_meyakinkan` | Hasil yang memerlukan pemeriksaan ulang. |
| 10 | `10._varian_kendala_dan_solusi` | Empat pola pesan error; menu simulasi bukan fitur pengguna. |
| 11 | `11._informasi_penyakit_padi` | Informasi untuk kelas yang benar-benar didukung model dan telah diperiksa sumbernya. |
| 12 | `12._tentang_padicare_batasan` | Tujuan, privasi, cakupan model, dan batasan. |

## Catatan integritas ekspor

Stitch mengirim `screen.png` berisi pesan `<FIFE Image failed to fetch>` untuk layar 2, 4, dan 9. Berkas gagal tersebut disimpan sebagai `screen_export_gagal.txt`; `screen.png` pada tiga folder itu dibuat ulang dari `code.html` melalui browser lokal pada lebar 390 px. Sembilan `screen.png` lainnya berasal langsung dari ZIP Stitch. Dengan demikian, semua 12 layar mempunyai HTML dan pratinjau PNG yang valid, tetapi tiga PNG hasil render ulang dapat sedikit berbeda dari tangkapan layar asli Stitch.

HTML memakai font, ikon, Tailwind, atau gambar dari URL luar. Aplikasi Flutter harus memakai aset lokal yang sah dan tidak bergantung pada URL tersebut untuk fungsi offline. Jangan menyalin klaim dalam contoh UI sebagai fakta produk. Lihat aturan koreksi di `PROMPT_ANTIGRAVITY_PADICARE.md`.
