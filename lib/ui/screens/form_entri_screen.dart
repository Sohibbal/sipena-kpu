import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import '../../data/local/database_helper.dart';
import '../../data/models/pemilih_model.dart';
import 'package:flutter/services.dart';

class FormEntriScreen extends StatefulWidget {
  final PemilihModel? pemilihToEdit;

  const FormEntriScreen({Key? key, this.pemilihToEdit}) : super(key: key);

  @override
  State<FormEntriScreen> createState() => _FormEntriScreenState();
}

class _FormEntriScreenState extends State<FormEntriScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _namaController = TextEditingController();
  final _noHpController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    if (widget.pemilihToEdit != null) {
      _nikController.text = widget.pemilihToEdit!.nik;
      _namaController.text = widget.pemilihToEdit!.namaLengkap;
      _noHpController.text = widget.pemilihToEdit!.noHp;
      _jenisKelamin = widget.pemilihToEdit!.jenisKelamin;
      _alamat = widget.pemilihToEdit!.alamat;
      _latitude = widget.pemilihToEdit!.latitude;
      _longitude = widget.pemilihToEdit!.longitude;
      if (widget.pemilihToEdit!.fotoPath != null) {
        _image = File(widget.pemilihToEdit!.fotoPath!);
      }
    }
  }
  
  String _jenisKelamin = 'Laki-laki';
  String _alamat = '';
  double? _latitude;
  double? _longitude;
  File? _image;
  bool _isLoadingLocation = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _getLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Layanan lokasi dinonaktifkan.')),
      );
      setState(() => _isLoadingLocation = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Izin lokasi ditolak.')),
        );
        setState(() => _isLoadingLocation = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Izin lokasi ditolak permanen.')),
      );
      setState(() => _isLoadingLocation = false);
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          _alamat = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}';
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mendapatkan lokasi.')),
      );
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _takePicture() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (photo != null) {
      setState(() {
        _image = File(photo.path);
      });
    }
  }

  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      if (_latitude == null || _longitude == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan dapatkan lokasi terlebih dahulu.')),
        );
        return;
      }
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan ambil foto pemilih/lokasi.')),
        );
        return;
      }

      final now = DateTime.now();
      final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      final formattedDate = formatter.format(now);

      final pemilih = PemilihModel(
        nik: _nikController.text,
        namaLengkap: _namaController.text,
        noHp: _noHpController.text,
        jenisKelamin: _jenisKelamin,
        tanggalPendataan: formattedDate,
        alamat: _alamat,
        latitude: _latitude,
        longitude: _longitude,
        fotoPath: _image!.path,
        statusSync: 0,
      );

      try {
        if (widget.pemilihToEdit != null) {
          // Update Mode
          pemilih.id = widget.pemilihToEdit!.id;
          await DatabaseHelper().updatePemilih(pemilih);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data berhasil diperbarui!')),
          );
        } else {
          // Insert Mode
          await DatabaseHelper().insertPemilih(pemilih);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data berhasil disimpan!')),
          );
        }
        
        Navigator.pop(context, true); // Return true to refresh list
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan data (NIK mungkin duplikat).')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text('Si-Pena KPU', style: TextStyle(color: Color(0xFFB71C1C), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFB71C1C)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              widget.pemilihToEdit != null ? 'Edit Data Pemilih' : 'Form Entri Data Pemilih',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              widget.pemilihToEdit != null
                  ? 'Perbarui data pemilih di bawah ini.'
                  : 'Silakan lengkapi formulir pendataan pemilih di bawah ini dengan benar.',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputLabel('NIK (Nomor Induk Kependudukan)'),
                  TextFormField(
                    controller: _nikController,
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: _inputDecoration('Contoh: 3171012345678901'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'NIK wajib diisi';
                      }
                      if (value.length != 16) {
                        return 'NIK harus 16 digit';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildInputLabel('Nama Lengkap'),
                  TextFormField(
                    controller: _namaController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    ],
                    decoration: _inputDecoration('Masukkan nama sesuai KTP'),
                    validator: (value) => value!.isEmpty ? 'Nama wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildInputLabel('Nomor Handphone'),
                  TextFormField(
                    controller: _noHpController,
                    keyboardType: TextInputType.phone,
                    maxLength: 13,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: _inputDecoration('0812xxxx'),
                    validator: (value) => value!.isEmpty ? 'No HP wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildInputLabel('Jenis Kelamin'),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Laki-laki',
                        groupValue: _jenisKelamin,
                        activeColor: const Color(0xFFB71C1C),
                        onChanged: (value) => setState(() => _jenisKelamin = value!),
                      ),
                      const Text('Laki-laki'),
                      const SizedBox(width: 20),
                      Radio<String>(
                        value: 'Perempuan',
                        groupValue: _jenisKelamin,
                        activeColor: const Color(0xFFB71C1C),
                        onChanged: (value) => setState(() => _jenisKelamin = value!),
                      ),
                      const Text('Perempuan'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInputLabel('Lokasi / Alamat Rumah'),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _latitude != null
                          ? 'Lat: $_latitude\nLon: $_longitude\n$_alamat'
                          : 'Alamat lengkap domisili',
                      style: TextStyle(color: _latitude != null ? Colors.black87 : Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isLoadingLocation ? null : _getLocation,
                      icon: _isLoadingLocation
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.location_on, color: Colors.black54),
                      label: const Text('Cek Lokasi (LBS)', style: TextStyle(color: Colors.black87)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[400]!),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInputLabel('Gambar / Dokumentasi'),
                  InkWell(
                    onTap: _takePicture,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5F5),
                        border: Border.all(color: const Color(0xFFE57373), style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          _image == null
                              ? const Column(
                                  children: [
                                    Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text('Unggah foto bukti pendataan lapangan', style: TextStyle(color: Colors.black54)),
                                  ],
                                )
                              : Image.file(_image!, height: 150, fit: BoxFit.cover),
                          if (_image == null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[700],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('Unggah Foto', style: TextStyle(color: Colors.white)),
                            )
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _saveData,
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text(
                  'SUBMIT',
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB71C1C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40), // Ruang ekstra agar tidak tertutup navigasi OS
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Color(0xFFB71C1C)),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
