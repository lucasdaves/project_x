import 'package:project_x/model/personal_model.dart';
import 'package:project_x/model/profession_model.dart';
import 'package:project_x/model/user_model.dart';
import 'package:project_x/services/database/utils/database_consts.dart';
import 'package:project_x/services/database/utils/database_methods.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseQuery {
  static final DatabaseQuery instance = DatabaseQuery._();
  DatabaseQuery._();

  final DatabaseMethods methods = DatabaseMethods.instance;
  final DatabaseConsts consts = DatabaseConsts.instance;

  //* CORE QUERYS *//

  Future<int> createUser(
    Database db, {
    required UserModel model,
  }) async {
    Map<String, dynamic> map = model.toMap();
    int id = await methods.create(db, consts.user, map: map);
    return id;
  }

  Future<int> updateUser(
    Database db, {
    required UserModel model,
    required int id,
  }) async {
    Map<String, dynamic> map = model.toMap();
    int count = await methods.update(db, consts.user, map: map, id: id);
    return count;
  }

  Future<UserModel?> readUser(
    Database db, {
    int? id,
  }) async {
    var resp = await methods.read(db, consts.user, id: id);
    if (resp.isNotEmpty) {
      final Map<String, dynamic> data = resp.first;
      return UserModel.fromMap(data);
    } else {
      return null;
    }
  }

  Future<int> createPersonal(
    Database db, {
    required PersonalModel model,
  }) async {
    Map<String, dynamic> map = model.toMap();
    int id = await methods.create(db, consts.personal, map: map);
    return id;
  }

  Future<PersonalModel?> readPersonal(
    Database db, {
    int? id,
  }) async {
    var resp = await methods.read(db, consts.personal, id: id);
    if (resp.isNotEmpty) {
      final Map<String, dynamic> data = resp.first;
      return PersonalModel.fromMap(data);
    } else {
      return null;
    }
  }

  Future<int> createProfession(
    Database db, {
    required ProfessionModel model,
  }) async {
    Map<String, dynamic> map = model.toMap();
    int id = await methods.create(db, consts.profession, map: map);
    return id;
  }
}
