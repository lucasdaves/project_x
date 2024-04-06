import 'dart:developer';
import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/model/workflow_controller_model.dart';
import 'package:project_x/services/database/model/step_model.dart';
import 'package:project_x/services/database/model/substep_model.dart';
import 'package:project_x/services/database/model/workflow_model.dart';
import 'package:project_x/services/database/database_files.dart';
import 'package:rxdart/rxdart.dart';

class WorkflowController {
  static final WorkflowController instance = WorkflowController._();
  WorkflowController._();

  //* DATABASE INSTANCES *//

  final service = DatabaseService.instance;
  final methods = DatabaseMethods.instance;
  final consts = DatabaseConsts.instance;

  //* CONTROLLER INSTANCES *//

  final userController = UserController.instance;

  //* STREAMS *//

  final workflowStream = BehaviorSubject<WorkflowStreamModel>();

  //* DISPOSE *//

  void dispose() {
    workflowStream.close();
  }

  //* METHODS *//

  Future<bool> createWorkflow({required WorkflowLogicalModel model}) async {
    try {
      int? userId = await userController.getUserId();
      if (userId == null) throw "Usuário ainda não logado";

      int? workflowId = await methods.create(
        consts.workflow,
        map: model.model!.toMap(),
      );

      await Future.wait(model.steps!.map((step) async {
        step!.model!.workflowId = workflowId;
        int? stepId = await methods.create(
          consts.step,
          map: step.model!.toMap(),
        );

        await Future.wait(step.substeps!.map((substep) async {
          substep!.model!.stepId = stepId;
          await methods.create(
            consts.substep,
            map: substep.model!.toMap(),
          );
        }));
      }));

      await readWorkflow();

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }

  Future<bool> readWorkflow({int? id, int? userId}) async {
    try {
      int? userId = await userController.getUserId();
      if (userId == null) throw "Usuário ainda não logado";

      WorkflowStreamModel model = WorkflowStreamModel();
      List<Map<String, Object?>>? mapA = await methods.read(consts.workflow);

      model.workflows = await Future.wait(mapA!.map((a) async {
        WorkflowDatabaseModel auxA = WorkflowDatabaseModel.fromMap(a);
        List<Map<String, Object?>>? mapB = await methods.rawRead(
            query:
                "SELECT * FROM tb_step WHERE tb_workflow_atr_id = ${auxA.id}");

        List<StepLogicalModel?>? steps = await Future.wait(mapB!.map((b) async {
          StepDatabaseModel auxB = StepDatabaseModel.fromMap(b);
          List<Map<String, Object?>>? mapC = await methods.rawRead(
              query:
                  "SELECT * FROM tb_substep WHERE tb_step_atr_id = ${auxB.id}");

          List<SubstepLogicalModel?>? substeps = mapC!.map((c) {
            SubstepDatabaseModel auxC = SubstepDatabaseModel.fromMap(c);
            return SubstepLogicalModel(model: auxC);
          }).toList();

          return StepLogicalModel(model: auxB, substeps: substeps);
        }));

        return WorkflowLogicalModel(model: auxA, steps: steps);
      }));

      workflowStream.sink.add(model);

      log(workflowStream.value.toString());

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }

  Future<bool> updateWorkflow({required WorkflowLogicalModel model}) async {
    try {
      int? userId = await userController.getUserId();
      if (userId == null) throw "Usuário ainda não logado";

      await methods.update(consts.workflow,
          map: model.model!.toMap(), id: model.model!.id!);

      await Future.wait(model.steps!.map((step) async {
        await methods.update(consts.step,
            map: step!.model!.toMap(), id: step.model!.id!);

        await Future.wait(step.substeps!.map((substep) async {
          await methods.update(consts.substep,
              map: substep!.model!.toMap(), id: substep.model!.id!);
        }));
      }));

      await readWorkflow();

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }

  Future<bool> deleteWorkflow({required WorkflowLogicalModel model}) async {
    try {
      int? userId = await userController.getUserId();
      if (userId == null) throw "Usuário ainda não logado";

      await Future.wait(model.steps!.map((step) async {
        await Future.wait(step!.substeps!.map((substep) async {
          await methods.delete(consts.substep, id: substep!.model?.id);
        }));
      }));

      await Future.wait(model.steps!.map((step) async {
        await methods.delete(consts.step, id: step!.model?.id);
      }));

      await methods.delete(consts.workflow, id: model.model?.id);

      await readWorkflow();

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }
}
