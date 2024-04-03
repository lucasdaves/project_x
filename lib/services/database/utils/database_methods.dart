import 'package:project_x/services/database/datavase_files.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseMethods {
  static final DatabaseMethods instance = DatabaseMethods._();
  DatabaseMethods._();

  final databaseService = DatabaseService.instance;

  //* CORE METHODS *//

  Future<int?> create(
    String table, {
    required Map<String, dynamic> map,
  }) async {
    Database? database = DatabaseService.instance.databaseModel.database;
    if (database != null) {
      map["atr_created_at"] = DateTime.now().toIso8601String();
      int res = await database.insert(table, map);
      return res;
    }
    return null;
  }

  Future<List<Map<String, Object?>>?> read(
    String table, {
    int? id,
  }) async {
    Database? database = DatabaseService.instance.databaseModel.database;
    if (database != null) {
      List<Map<String, Object?>> res = await database.query(
        table,
        where: (id != null) ? 'atr_id = ?' : null,
        whereArgs: (id != null) ? [id] : null,
      );
      return res;
    }
    return null;
  }

  Future<int?> update(
    String table, {
    required Map<String, dynamic> map,
    int? id,
  }) async {
    Database? database = DatabaseService.instance.databaseModel.database;
    if (database != null) {
      map["atr_updated_at"] = DateTime.now().toIso8601String();
      int res = await database.update(
        table,
        map,
        where: (id != null) ? 'atr_id = ?' : null,
        whereArgs: (id != null) ? [id] : null,
      );
      return res;
    }
    return null;
  }

  Future<int?> delete(
    String table, {
    int? id,
  }) async {
    Database? database = DatabaseService.instance.databaseModel.database;
    if (database != null) {
      int res = await database.delete(
        table,
        where: (id != null) ? 'atr_id = ?' : null,
        whereArgs: (id != null) ? [id] : null,
      );
      return res;
    }
    return null;
  }

  //* RAW METHODS *//

  Future<int?> rawCreate({
    required String query,
  }) async {
    Database? database = DatabaseService.instance.databaseModel.database;
    if (database != null) {
      int res = await database.rawInsert(query);
      return res;
    }
    return null;
  }

  Future<List<Map<String, Object?>>?> rawRead({
    required String query,
  }) async {
    Database? database = DatabaseService.instance.databaseModel.database;
    if (database != null) {
      List<Map<String, Object?>> res = await database.rawQuery(query);
      return res;
    }
    return null;
  }

  Future<int?> rawUpdate({
    required String query,
  }) async {
    Database? database = DatabaseService.instance.databaseModel.database;
    if (database != null) {
      int res = await database.rawUpdate(query);
      return res;
    }
    return null;
  }

  Future<int?> rawDelete({
    required String query,
  }) async {
    Database? database = DatabaseService.instance.databaseModel.database;
    if (database != null) {
      int res = await database.rawDelete(query);
      return res;
    }
    return null;
  }
}
