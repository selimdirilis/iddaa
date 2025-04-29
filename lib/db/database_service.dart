import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  Database? _db;
  List<String> selectedColumns = [];

  Future<void> loadDatabase(String path) async {
    _db = await openDatabase(path);
  }

  Future<List<String>> fetchColumns() async {
    final result = await _db!.rawQuery('PRAGMA table_info(matches)');
    return result.map((e) => e['name'] as String).toList()..remove('id');
  }

  Future<Map<String, dynamic>?> findClosestMatch(Map<String, double> inputs) async {
    final List<Map<String, dynamic>> matches = await _db!.query('matches');

    Map<String, dynamic>? closest;
    double minDiff = double.infinity;

    for (var match in matches) {
      double diff = 0;
      for (var entry in inputs.entries) {
        final dbValue = double.tryParse(match[entry.key]?.toString() ?? '') ?? 0;
        diff += (dbValue - entry.value).abs();
      }

      if (diff < minDiff) {
        minDiff = diff;
        closest = match;
      }
    }

    return closest;
  }
}
