import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class SqlitePersistence {
  static const DatabaseName = 'cinephile.db';
  static const MoviesWatchedTableName = 'movieswatched';
  Database db;

  SqlitePersistence._(this.db);

  static Future<SqlitePersistence> create() async => null;

  Future<List<Map<String, dynamic>>> getUniqueObjects() async {
    return null;
  }

  Future<List<Map<String, dynamic>>> findObjects(String query) async {
    return null;
  }

  void createOrUpdateObject(int key, Map<String, dynamic> object) async {}

  Future<void> removeObject(int key) async {
    return;
  }
}
