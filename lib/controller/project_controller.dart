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

  final service = DatabaseService.instance;
  final methods = DatabaseMethods.instance;
  final consts = DatabaseConsts.instance;

  //* CONTROLLER INSTANCES *//

  final userController = UserController.instance;

  //* STREAMS *//

  final projectStream = BehaviorSubject<ProjectStreamModel>();

  //* DISPOSE *//

  void dispose() {
    projectStream.close();
  }

  //* METHODS *//

  Future<bool> createProject({required ProjectLogicalModel model}) async {
    try {
      int? userId = await userController.getUserId();
      if (userId == null) throw "O id do usuário é nulo";
      if (model.model == null) throw "O modelo do projeto é nulo";

      model.model!.userId = userId;

      int? projectId = await methods.create(
        consts.project,
        map: model.model!.toMap(),
      );

      if (projectId == null) throw "Projeto não criado";

      await readProject();

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }

  Future<bool> readProject({int? id, int? userId}) async {
    try {
      if (userId == null) throw "Usuário ainda não logado";

      ProjectStreamModel model = ProjectStreamModel();

      List<Map<String, Object?>>? mapA = await methods.read(consts.project);

      model.projects = mapA!.map((a) {
        return ProjectLogicalModel(model: ProjectDatabaseModel.fromMap(a));
      }).toList();

      projectStream.sink.add(model);

      log(projectStream.value.toString());

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }

  Future<bool> updateProject({required ProjectLogicalModel model}) async {
    try {
      int? userId = await userController.getUserId();

      if (userId == null) throw "Usuário ainda não logado";

      if (model.model == null) {
        throw "O modelo do projeto é nulo";
      }

      await methods.update(consts.project,
          map: model.model!.toMap(), id: model.model!.id!);

      await readProject();

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }

  Future<bool> deleteProject({required ProjectLogicalModel model}) async {
    try {
      int? userId = await userController.getUserId();

      if (userId == null) throw "Usuário ainda não logado";

      if (model.model == null) throw "O modelo do projeto é nulo";

      await methods.delete(consts.project, id: model.model?.id);

      await readProject();

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }
}
