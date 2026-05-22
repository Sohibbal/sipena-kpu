import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/models/pemilih_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'form_entri_screen.dart';

class DetailPemilihScreen extends StatelessWidget {
  final PemilihModel pemilih;

  const DetailPemilihScreen({Key? key, required this.pemilih}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Data Pemilih', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFC62828), // Warna merah KPU
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (pemilih.statusSync == 0)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Data',
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormEntriScreen(pemilihToEdit: pemilih),
                  ),
                );
                // Jika data berhasil diupdate, kembali ke list (pop layar detail ini)
                if (result == true) {
                  if (context.mounted) {
                    Navigator.pop(context, true); 
                  }
                }
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  image: pemilih.fotoPath != null
                      ? DecorationImage(
                          image: FileImage(File(pemilih.fotoPath!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: pemilih.fotoPath == null
                    ? const Icon(Icons.person, size: 80, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            
            // Status Sinkronisasi
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: pemilih.statusSync == 1 ? Colors.green[100] : Colors.orange[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  pemilih.statusSync == 1 ? '✅ Terverifikasi (Tersinkronisasi)' : '⏳ Menunggu Sinkronisasi',
                  style: TextStyle(
                    color: pemilih.statusSync == 1 ? Colors.green[800] : Colors.orange[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Informasi Data
            const Text('Informasi Pribadi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            _buildInfoRow('NIK', pemilih.nik),
            _buildInfoRow('Nama Lengkap', pemilih.namaLengkap),
            _buildInfoRow('Jenis Kelamin', pemilih.jenisKelamin),
            _buildInfoRow('Nomor HP', pemilih.noHp),
            
            const SizedBox(height: 20),
            const Text('Informasi Pendataan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            _buildInfoRow('Waktu Pendataan', pemilih.tanggalPendataan),
            _buildInfoRow('Alamat', pemilih.alamat),
            
            const SizedBox(height: 30),
            
            // Tombol Peta
            if (pemilih.latitude != null && pemilih.longitude != null)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${pemilih.latitude},${pemilih.longitude}');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tidak dapat membuka peta.')),
                      );
                    }
                  },
                  icon: const Icon(Icons.map, color: Colors.white),
                  label: const Text('Buka Lokasi di Peta', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            const SizedBox(height: 40), // Ruang ekstra bawah
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
