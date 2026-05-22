class PemilihModel {
  int? id;
  String nik;
  String namaLengkap;
  String noHp;
  String jenisKelamin;
  String tanggalPendataan;
  String alamat;
  double? latitude;
  double? longitude;
  String? fotoPath;
  int statusSync;

  PemilihModel({
    this.id,
    required this.nik,
    required this.namaLengkap,
    required this.noHp,
    required this.jenisKelamin,
    required this.tanggalPendataan,
    required this.alamat,
    this.latitude,
    this.longitude,
    this.fotoPath,
    this.statusSync = 0, // 0 = not synced, 1 = synced
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nik': nik,
      'nama_lengkap': namaLengkap,
      'no_hp': noHp,
      'jenis_kelamin': jenisKelamin,
      'tanggal_pendataan': tanggalPendataan,
      'alamat': alamat,
      'latitude': latitude,
      'longitude': longitude,
      'foto_path': fotoPath,
      'status_sync': statusSync,
    };
  }

  factory PemilihModel.fromMap(Map<String, dynamic> map) {
    return PemilihModel(
      id: map['id'],
      nik: map['nik'],
      namaLengkap: map['nama_lengkap'],
      noHp: map['no_hp'],
      jenisKelamin: map['jenis_kelamin'],
      tanggalPendataan: map['tanggal_pendataan'],
      alamat: map['alamat'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      fotoPath: map['foto_path'],
      statusSync: map['status_sync'] ?? 0,
    );
  }
}
