import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/local/database_helper.dart';
import '../../data/models/pemilih_model.dart';
import '../../data/api/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'detail_pemilih_screen.dart';
class ListDataScreen extends StatefulWidget {
  const ListDataScreen({Key? key}) : super(key: key);

  @override
  State<ListDataScreen> createState() => _ListDataScreenState();
}

class _ListDataScreenState extends State<ListDataScreen> {
  List<PemilihModel> _pemilihList = [];
  bool _isLoading = true;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    final list = await DatabaseHelper().getPemilihList();
    setState(() {
      _pemilihList = list;
      _isLoading = false;
    });
  }

  Future<void> _syncData() async {
    setState(() {
      _isSyncing = true;
    });

    // Ambil data yang belum di-sync (status_sync == 0)
    final unSyncedData = _pemilihList.where((p) => p.statusSync == 0).toList();

    if (unSyncedData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua data sudah tersinkronisasi.')),
      );
      setState(() => _isSyncing = false);
      return;
    }

    // Call API Service
    final response = await ApiService().syncData(unSyncedData);

    if (response['success'] == true) {
      // Update SQLite status
      for (var p in unSyncedData) {
        await DatabaseHelper().updateStatusSync(p.id!, 1);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sinkronisasi berhasil!')),
      );
      _loadData(); // Refresh list
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Sinkronisasi gagal')),
      );
    }

    setState(() {
      _isSyncing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pemilih', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.red),
        actions: [
          IconButton(
            icon: _isSyncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.red, strokeWidth: 2),
                  )
                : const Icon(Icons.cloud_upload),
            onPressed: _isSyncing ? null : _syncData,
            tooltip: 'Sinkronisasi ke Server',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pemilihList.isEmpty
              ? const Center(child: Text('Belum ada data pemilih.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _pemilihList.length,
                  itemBuilder: (context, index) {
                    final p = _pemilihList[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPemilihScreen(pemilih: p),
                            ),
                          );
                          if (result == true) {
                            _loadData();
                          }
                        },
                        leading: CircleAvatar(
                          backgroundImage: p.fotoPath != null
                              ? FileImage(File(p.fotoPath!))
                              : null,
                          child: p.fotoPath == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(p.namaLengkap, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('NIK: ${p.nik}'),
                            Text(
                              p.statusSync == 1 ? 'Sudah tersinkronisasi' : 'Belum tersinkronisasi',
                              style: TextStyle(
                                color: p.statusSync == 1 ? Colors.green : Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
    );
  }
}
