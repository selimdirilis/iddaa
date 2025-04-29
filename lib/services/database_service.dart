import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:iddaa/models/match_model.dart';

class DatabaseService {
  DatabaseService._privateConstructor();
  static final DatabaseService instance = DatabaseService._privateConstructor();

  Database? _database;

  Future<void> loadDatabase(String path) async {
    _database = await openDatabase(path);
  }

  // database_service.dart

  Future<List<String>> getColumns(String tableName) async {
    final db = _database;
    if (db == null) return [];

    final result = await db.query(
      tableName,
      limit: 1,  // Sadece 1 satır getiriyoruz
    );

    if (result.isNotEmpty) {
      return result.first.keys.toList(); // Sütun adları
    } else {
      return [];
    }
  }


  Future<List<MatchModel>> fetchAllMatches() async {
    final db = _database;
    if (db == null) throw Exception('Veritabanı yüklü değil');
    final result = await db.query('matches');
    return result.map((row) => MatchModel.fromMap(row)).toList();
  }
}
