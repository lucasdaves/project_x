import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:project_x/controller/association_controller.dart';
import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/controller/workflow_controller.dart';
import 'package:project_x/model/project_controller_model.dart';
import 'package:project_x/services/database/model/project_model.dart';
import 'package:project_x/services/database/database_files.dart';
import 'package:project_x/services/database/model/workflow_model.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:rxdart/rxdart.dart';

class ProjectController {
  static final ProjectController instance = ProjectController._();
  ProjectController._();

  //* DATABASE INSTANCES *//

  final methods = DatabaseMethods.instance;
  final consts = DatabaseConsts.instance;

  //* STREAMS *//

  final stream = BehaviorSubject<ProjectStreamModel>();

  //* VARIABLES *//

  TextEditingController search = TextEditingController();

  //* DISPOSE *//

  void dispose() {
    stream.close();
  }

  //* METHODS *//

  Future<bool> createProject({
    required ProjectLogicalModel projectModel,
    required WorkflowLogicalModel workflowModel,
  }) async {
    try {
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "O id do usuário é nulo";
      if (projectModel.model == null) throw "O modelo do projeto é nulo";

      projectModel.model!.userId = userId;

      //* WORKFLOW *//
      if (projectModel.model?.workflowId != null) {
        workflowModel.model?.name =
            "${workflowModel.model?.name} - ${projectModel.model?.name}";
        workflowModel.model?.isCopy = true;
        await WorkflowController.instance.createWorkflow(
          model: workflowModel,
        );
      }

      if (workflowModel.model?.id == null) throw "Workflow não criada";

      //* PROJECT *//
      int? projectId;
      if (projectModel.model != null) {
        projectModel.model?.status = ProjectDatabaseModel.statusMap[0];
        projectModel.model?.workflowId = workflowModel.model?.id;
        projectId = await methods.create(
          consts.project,
          map: projectModel.model!.toMap(),
        );
      }

      if (projectId == null) throw "Projeto não criado";

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    } finally {
      await readProject();
    }
  }

  Future<bool> readProject() async {
    try {
      stream.sink.add(ProjectStreamModel(status: EntityStatus.Loading));
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

      model.status = EntityStatus.Completed;
      stream.sink.add(model);

      return true;
    } catch (error) {
      stream.sink.add(ProjectStreamModel(status: EntityStatus.Completed));
      log(error.toString());
      return false;
    }
  }

  Future<bool> updateProject({
    required ProjectLogicalModel projectModel,
    required WorkflowLogicalModel workflowModel,
  }) async {
    try {
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "O id do usuário é nulo";
      if (projectModel.model == null) throw "O modelo do projeto é nulo";

      projectModel.model!.userId = userId;

      //* WORKFLOW *//
      if (workflowModel.model != null) {
        workflowModel.model?.isCopy = true;
        await WorkflowController.instance.updateWorkflow(
          model: workflowModel,
        );
      }

      //* PROJECT *//
      if (projectModel.model != null) {
        Map<String, dynamic> argsA = {};
        argsA['atr_id'] = projectModel.model!.id;

        await methods.update(consts.project,
            map: projectModel.model!.toMap(), args: argsA);
      }

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    } finally {
      await readProject();
    }
  }

  Future<bool> deleteProject({
    required ProjectLogicalModel projectModel,
    required WorkflowLogicalModel workflowModel,
  }) async {
    try {
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "O id do usuário é nulo";
      if (projectModel.model == null) throw "O modelo do projeto é nulo";

      //* PROJECT *//
      if (projectModel.model != null) {
        Map<String, dynamic> argsA = {};
        argsA['atr_id'] = projectModel.model!.id;

        await methods.delete(consts.project, args: argsA);
      }

      //* WORKFLOW *//
      if (workflowModel.model != null) {
        await WorkflowController.instance.deleteWorkflow(
          model: workflowModel,
        );
      }

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    } finally {
      await readProject();
      await AssociationController.instance.readAssociation();
    }
  }

  void reloadStream() {
    stream.sink.add(stream.value);
  }
}
