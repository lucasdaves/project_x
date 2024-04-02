import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseMethods {
  static final DatabaseMethods instance = DatabaseMethods._();
  DatabaseMethods._();

  Future<int> create(
    Database db,
    String table, {
    required Map<String, dynamic> map,
  }) async {
    int res = await db.insert(table, map);
    return res;
  }

  Future<List<Map<String, Object?>>> read(
    Database db,
    String table, {
    int? id,
  }) async {
    List<Map<String, Object?>> res = await db.query(
      table,
      where: (id != null) ? 'atr_id = ?' : null,
      whereArgs: (id != null) ? [id] : null,
    );
    return res;
  }

  Future<int> update(
    Database db,
    String table, {
    required Map<String, dynamic> map,
    int? id,
  }) async {
    int res = await db.update(
      table,
      map,
      where: (id != null) ? 'atr_id = ?' : null,
      whereArgs: (id != null) ? [id] : null,
    );
    return res;
  }

  Future<int> delete(
    Database db,
    String table, {
    int? id,
  }) async {
    int res = await db.delete(
      table,
      where: (id != null) ? 'atr_id = ?' : null,
      whereArgs: (id != null) ? [id] : null,
    );
    return res;
  }
}
