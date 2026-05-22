import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pemilih_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.228:3000/api'; // IP Wi-Fi

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('id_pendata', data['data']['id']);
          await prefs.setString('nama_lengkap', data['data']['nama_lengkap']);
        }
        return data;
      } else {
        try {
          return jsonDecode(response.body);
        } catch (e) {
          return {'success': false, 'message': 'Terjadi kesalahan pada server.'};
        }
      }
    } catch (e) {
      return {'success': false, 'message': 'Gagal terhubung ke server. Periksa koneksi atau IP Address.'};
    }
  }

  Future<Map<String, dynamic>> syncData(List<PemilihModel> data) async {
    final prefs = await SharedPreferences.getInstance();
    final idPendata = prefs.getInt('id_pendata');

    if (idPendata == null) {
      return {'success': false, 'message': 'Petugas belum login.'};
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sync'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_pendata': idPendata,
          'data': data.map((e) => e.toMap()).toList(),
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        try {
          return jsonDecode(response.body);
        } catch (e) {
          return {'success': false, 'message': 'Gagal sinkronisasi data.'};
        }
      }
    } catch (e) {
      return {'success': false, 'message': 'Gagal terhubung ke server. Periksa koneksi jaringan Anda.'};
    }
  }
}
