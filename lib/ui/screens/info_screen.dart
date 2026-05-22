import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text('Informasi Aplikasi', style: TextStyle(color: Color(0xFFB71C1C), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFB71C1C)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Tujuan Sistem',
              icon: Icons.flag,
              content: 'Si-Pena KPU ini dirancang khusus untuk memudahkan petugas lapangan dalam mendata calon pemilih secara digital. Data yang tersimpan dijamin keamanannya dan dapat disinkronisasikan ke server pusat KPU.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Prosedur Penggunaan',
              icon: Icons.rule,
              content: '1. Pastikan Anda telah login menggunakan kredensial petugas yang sah.\n'
                       '2. Gunakan menu "Form Entri Data" saat bertemu warga di lapangan.\n'
                       '3. Isi NIK (16 digit angka) dan lengkapi data diri sesuai KTP.\n'
                       '4. Klik "Get Lokasi" untuk merekam koordinat rumah pemilih.\n'
                       '5. Ambil foto wajah/bukti melalui kamera secara langsung.\n'
                       '6. Submit data untuk menyimpan secara offline (tanpa kuota internet).',
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Panduan Sinkronisasi',
              icon: Icons.cloud_sync,
              content: 'Sistem ini dapat bekerja 100% tanpa jaringan internet. Namun, di akhir hari kerja, petugas wajib:\n\n'
                       '• Membuka menu "Data Pemilih".\n'
                       '• Menghubungkan HP ke jaringan internet aktif (Wi-Fi/Seluler).\n'
                       '• Menekan ikon Awan (Upload) di kanan atas layar untuk mentransfer seluruh data lokal ke server KPU Pusat.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Pusat Bantuan',
              icon: Icons.support_agent,
              content: 'Jika Anda menemukan kendala seperti gagal sinkronisasi atau aplikasi tertutup tiba-tiba, segera hubungi koordinator IT kecamatan atau email ke support@kpu.go.id.',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFD32F2F),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: const Column(
        children: [
          Icon(Icons.how_to_vote, size: 60, color: Colors.white),
          SizedBox(height: 16),
          Text(
            'KPU PENDATA',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
          ),
          SizedBox(height: 8),
          Text(
            'Versi 1.0.0 (Build 01)',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required IconData icon, required String content}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFB71C1C)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
          ),
        ],
      ),
    );
  }
}
