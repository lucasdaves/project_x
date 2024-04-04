import 'dart:developer';
import 'package:project_x/model/system_controller_model.dart';
import 'package:project_x/services/database/database_files.dart';
import 'package:project_x/services/database/model/system_model.dart';
import 'package:rxdart/rxdart.dart';

class SystemController {
  static final SystemController instance = SystemController._();
  SystemController._();

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

  Future<bool> readSystem({int? userId}) async {
    try {
      List<Map<String, Object?>>? map = await methods.read(consts.system);

      if (map == null || map.isEmpty) {
        throw "Sistema não encontrado";
      }

      if (userId != null) {
        bool systemFound = map.any(
          (element) => SystemDatabaseModel.fromMap(element).userId == userId,
        );
        if (!systemFound) {
          throw "Não há um sistema associado ao usuário";
        }
      }

      Map<String, Object?> systemMap;
      if (userId != null) {
        systemMap = map.firstWhere(
          (element) => SystemDatabaseModel.fromMap(element).userId == userId,
        );
      } else {
        systemMap = map.first;
      }
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
