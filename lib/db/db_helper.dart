// lib/db/db_helper.dart
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const _dbName = 'userdb.db';
  static Database? _db;

  /// Kopyalanmış DB dosyasının yolunu döner
  static Future<String> get _localPath async {
    final docsDir = await getApplicationDocumentsDirectory();
    return join(docsDir.path, _dbName);
  }

  /// Uygulama açılışında, eğer daha önce import edilmiş DB varsa aç
  static Future<void> openImportedDb() async {
    final path = await _localPath;
    _db = await openDatabase(path, readOnly: false);
  }

  /// Kullanıcının daha önce bir DB seçip seçmediğini kontrol eder
  static Future<bool> isDbImported() async {
    final path = await _localPath;
    return File(path).exists();
  }

  /// Kullanıcının seçtiği .db dosyasını kopyalar ve açar
  static Future<void> importDb(String sourcePath) async {
    final destPath = await _localPath;
    final destFile = File(destPath);
    if (await destFile.exists()) {
      await destFile.delete();
    }
    await File(sourcePath).copy(destPath);
    _db = await openDatabase(destPath, readOnly: false);
  }

  static Database get _database {
    if (_db == null) throw Exception('DB henüz açılmadı!');
    return _db!;
  }

  /// Tüm tablo isimlerini döner
  static Future<List<String>> getTables() async {
    final res = await _database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';"
    );
    return res.map((r) => r['name'] as String).toList();
  }

  /// Sayfalı olarak veri çeker
  static Future<List<Map<String, dynamic>>> getTableDataPaged(
      String table, {
        required int limit,
        required int offset,
      }) async {
    return _database.query(table, limit: limit, offset: offset);
  }

  /// Tablonun sütun adlarını döner (PRAGMA table_info)
  static Future<List<String>> getTableColumns(String table) async {
    final res = await _database.rawQuery('PRAGMA table_info("$table")');
    // 'name' alanı sütun adını içerir
    return res.map((r) => r['name'] as String).toList();
  }

  /// WHERE + args ile sorgulama yapar
  static Future<List<Map<String, dynamic>>> queryWhere(
      String table, {
        required String where,
        required List<dynamic> whereArgs,
      }) async {
    return _database.query(table, where: where, whereArgs: whereArgs);
  }
}
