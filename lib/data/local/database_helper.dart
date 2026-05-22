import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/pemilih_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'kpu_pemilih.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pemilih (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nik TEXT UNIQUE,
        nama_lengkap TEXT,
        no_hp TEXT,
        jenis_kelamin TEXT,
        tanggal_pendataan TEXT,
        alamat TEXT,
        latitude REAL,
        longitude REAL,
        foto_path TEXT,
        status_sync INTEGER DEFAULT 0
      )
    ''');
  }

  Future<int> insertPemilih(PemilihModel pemilih) async {
    Database db = await database;
    return await db.insert('pemilih', pemilih.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<PemilihModel>> getPemilihList() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pemilih',
      orderBy: "tanggal_pendataan DESC"
      );
    return List.generate(maps.length, (i) {
      return PemilihModel.fromMap(maps[i]);
    });
  }

  Future<int> updateStatusSync(int id, int status) async {
    Database db = await database;
    return await db.update(
      'pemilih',
      {'status_sync': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updatePemilih(PemilihModel pemilih) async {
    Database db = await database;
    return await db.update(
      'pemilih',
      pemilih.toMap(),
      where: 'id = ?',
      whereArgs: [pemilih.id],
    );
  }

  Future<int> getPemilihCount() async {
    Database db = await database;
    int? count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM pemilih'));
    return count ?? 0;
  }
}
