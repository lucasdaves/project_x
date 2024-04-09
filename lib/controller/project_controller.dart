import 'dart:developer';
import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/model/project_controller_model.dart';
import 'package:project_x/services/database/model/project_model.dart';
import 'package:project_x/services/database/database_files.dart';
import 'package:rxdart/rxdart.dart';

class ProjectController {
  static final ProjectController instance = ProjectController._();
  ProjectController._();

  //* DATABASE INSTANCES *//

  final methods = DatabaseMethods.instance;
  final consts = DatabaseConsts.instance;

  //* STREAMS *//

  final projectStream = BehaviorSubject<ProjectStreamModel>();

  //* DISPOSE *//

  void dispose() {
    projectStream.close();
  }

  //* METHODS *//

  Future<bool> createProject({required ProjectLogicalModel model}) async {
    try {
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "O id do usuário é nulo";
      if (model.model == null) throw "O modelo do projeto é nulo";

      model.model!.userId = userId;

      //* PROJECT *//
      int? projectId;
      if (model.model != null) {
        projectId = await methods.create(
          consts.project,
          map: model.model!.toMap(),
        );
      }

      if (projectId == null) throw "Projeto não criado";

      await readProject();

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> readProject() async {
    try {
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "O id do usuário é nulo";

      ProjectStreamModel model = ProjectStreamModel();

      //* PROJECT *//
      Map<String, dynamic> argsA = {};
      argsA['tb_user_atr_id'] = userId;

      List<Map<String, Object?>>? mapA =
          await methods.read(consts.project, args: argsA);

      if (mapA == null || mapA.isEmpty) {
        throw "Projeto não encontrado";
      }

      model.projects = mapA.map((a) {
        return ProjectLogicalModel(model: ProjectDatabaseModel.fromMap(a));
      }).toList();

      projectStream.sink.add(model);

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> updateProject({required ProjectLogicalModel model}) async {
    try {
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "O id do usuário é nulo";
      if (model.model == null) throw "O modelo do projeto é nulo";

      model.model!.userId = userId;

      //* PROJECT *//
      if (model.model != null) {
        Map<String, dynamic> argsA = {};
        argsA['atr_id'] = model.model!.id;

        await methods.update(consts.project,
            map: model.model!.toMap(), args: argsA);
      }

      await readProject();

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> deleteProject({required ProjectLogicalModel model}) async {
    try {
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "O id do usuário é nulo";
      if (model.model == null) throw "O modelo do projeto é nulo";

      //* PROJECT *//
      if (model.model != null) {
        Map<String, dynamic> argsA = {};
        argsA['atr_id'] = model.model!.id;

        await methods.delete(consts.project, args: argsA);
      }

      await readProject();

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }
}
