import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/local/database_helper.dart';
import 'form_entri_screen.dart';
import 'list_data_screen.dart';
import 'login_screen.dart';
import 'info_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _namaPetugas = '';

  @override
  void initState() {
    super.initState();
    _loadDataPetugas();
  }

  Future<void> _loadDataPetugas() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _namaPetugas = prefs.getString('nama_lengkap') ?? 'Petugas';
    });
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _onMenuLihatDataClicked() async {
    final count = await DatabaseHelper().getPemilihCount();
    if (!mounted) return;

    if (count == 0) {
      // Munculkan Alert/Modal Profesional dan Force Redirect
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blueAccent),
              SizedBox(width: 10),
              Text('Informasi Sistem'),
            ],
          ),
          content: const Text(
            'Sistem mendeteksi belum ada rekaman data pemilih di perangkat ini. Silakan mulai entri data pertama Anda.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FormEntriScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text(
                'Mengerti',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ListDataScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          'Si-Pena KPU',
          style: TextStyle(
            color: Color(0xFFB71C1C),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFB71C1C)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner Merah
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFD32F2F), // Merah mockup
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang,\n$_namaPetugas',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Pantau dan kelola data pemilih wilayah Anda hari ini.',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Layanan Utama',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildMenuCard(
              icon: Icons.info_outline,
              title: 'Informasi Aplikasi',
              description: 'Panduan prosedur penggunaan aplikasi.',
              iconColor: const Color(0xFFB71C1C),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InfoScreen()),
                );
              },
            ),
            const SizedBox(height: 16),

            _buildMenuCard(
              icon: Icons.edit_document,
              title: 'Form Entri Data Pemilih',
              description: 'Input data calon pemilih baru',
              iconColor: const Color(0xFFB71C1C),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FormEntriScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildMenuCard(
              icon: Icons.list_alt,
              title: 'Lihat Data Pemilih',
              description: 'Lihat data pemilih yang sudah diinput.',
              iconColor: const Color(0xFFB71C1C),
              onTap: _onMenuLihatDataClicked,
            ),
            const SizedBox(height: 16),
            _buildMenuCard(
              icon: Icons.exit_to_app,
              title: 'Keluar',
              description: 'Selesaikan sesi petugas.',
              iconColor: const Color(0xFFB71C1C),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String description,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: title == 'Keluar'
                          ? const Color(0xFFB71C1C)
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}
