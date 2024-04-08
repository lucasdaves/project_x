import 'dart:developer';
import 'package:project_x/model/system_controller_model.dart';
import 'package:project_x/services/database/database_files.dart';
import 'package:project_x/services/database/model/system_model.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:rxdart/rxdart.dart';

class SystemController {
  static final SystemController instance = SystemController._();
  SystemController._();

  //* APP INSTANCES *//

  final responsive = AppResponsive.instance;

  //* DATABASE INSTANCES *//

  final service = DatabaseService.instance;
  final methods = DatabaseMethods.instance;
  final consts = DatabaseConsts.instance;

  //* STREAMS *//

  final systemStream = BehaviorSubject<SystemStreamModel>();

  //* DISPOSE *//

  void dispose() {
    systemStream.close();
  }

  //* METHODS *//

  Future<bool> createSystem({required SystemLogicalModel model}) async {
    try {
      if (model.model == null) throw "O modelo do sistema é nulo";

      int? createSystem =
          await methods.create(consts.system, map: model.model!.toMap());

      if (createSystem == null) {
        throw "Sistema não criado";
      }

      await readSystem();

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }

  Future<bool> readSystem({int? id, int? userId}) async {
    try {
      List<Map<String, Object?>>? map =
          await methods.read(consts.system, userId: userId);

      if (map == null || map.isEmpty) throw "Sistema não encontrado";

      Map<String, Object?> systemMap = map.first;

      SystemLogicalModel systemModel = SystemLogicalModel(
        model: SystemDatabaseModel.fromMap(systemMap),
      );

      SystemStreamModel systemStreamModel =
          SystemStreamModel(system: systemModel);

      systemStream.sink.add(systemStreamModel);

      log(systemStream.value.toString());

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }

  Future<bool> updateSystem({required SystemLogicalModel model}) async {
    try {
      if (model.model == null) throw "O modelo do sistema é nulo";

      await methods.update(consts.system,
          map: model.model!.toMap(), id: model.model!.id!);

      await readSystem();

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }
}