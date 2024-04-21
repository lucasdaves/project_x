import 'dart:developer';
import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/model/workflow_controller_model.dart';
import 'package:project_x/services/database/model/step_model.dart';
import 'package:project_x/services/database/model/substep_model.dart';
import 'package:project_x/services/database/model/workflow_model.dart';
import 'package:project_x/services/database/database_files.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:rxdart/rxdart.dart';

class WorkflowController {
  static final WorkflowController instance = WorkflowController._();
  WorkflowController._();

  //* DATABASE INSTANCES *//

  final methods = DatabaseMethods.instance;
  final consts = DatabaseConsts.instance;

  //* STREAMS *//

  final stream = BehaviorSubject<WorkflowStreamModel>();

  //* DISPOSE *//

  void dispose() {
    stream.close();
  }

  //* METHODS *//

  Future<bool> createWorkflow({required WorkflowLogicalModel model}) async {
    try {
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "O id do usuário é nulo";
      if (model.model == null) throw "O modelo do projeto é nulo";

      model.model!.userId = userId;

      //* WORKFLOW *//
      int? workflowId;
      if (model.model != null) {
        model.model!.id = null;
        workflowId = await methods.create(
          consts.workflow,
          map: model.model!.toMap(),
        );
      }

      if (workflowId == null) throw "Erro ao criar workflow";

      model.model?.id = workflowId;

      //* STEPS *//
      for (StepLogicalModel? step in model.steps ?? []) {
        if (step?.model != null) {
          step!.model!.id = null;
          step.model!.workflowId = workflowId;
          int? stepId = await methods.create(
            consts.step,
            map: step.model!.toMap(),
          );

          //* SUBSTEPS *//
          for (SubstepLogicalModel? substep in step.substeps ?? []) {
            if (substep?.model != null) {
              substep!.model!.id = null;
              substep.model!.stepId = stepId;
              await methods.create(
                consts.substep,
                map: substep.model!.toMap(),
              );
            }
          }
        }
      }

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    } finally {
      await readWorkflow();
    }
  }

  Future<bool> readWorkflow() async {
    try {
      stream.sink.add(WorkflowStreamModel(status: EntityStatus.Loading));
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "Usuário ainda não logado";

      WorkflowStreamModel model = WorkflowStreamModel();

      //* WORKFLOW *//
      Map<String, dynamic> argsA = {};
      argsA['tb_user_atr_id'] = userId;

      List<Map<String, Object?>>? mapA =
          await methods.read(consts.workflow, args: argsA);

      if (mapA == null || mapA.isEmpty) {
        throw "Workflow não encontrada";
      }

      model.workflows = mapA.map((a) {
        return WorkflowLogicalModel(model: WorkflowDatabaseModel.fromMap(a));
      }).toList();

      for (WorkflowLogicalModel? workflow in model.workflows ?? []) {
        if (workflow?.model != null) {
          //* STEPS *//
          Map<String, dynamic> argsB = {};
          argsB['tb_workflow_atr_id'] = workflow!.model!.id;

          List<Map<String, Object?>>? mapB =
              await methods.read(consts.step, args: argsB);

          if (mapB != null && mapB.isNotEmpty) {
            workflow.steps = mapB.map((b) {
              return StepLogicalModel(model: StepDatabaseModel.fromMap(b));
            }).toList();

            //* SUBSTEPS *//
            for (StepLogicalModel? step in workflow.steps ?? []) {
              if (step?.model != null) {
                Map<String, dynamic> argsC = {};
                argsC['tb_step_atr_id'] = step!.model!.id;

                List<Map<String, Object?>>? mapC =
                    await methods.read(consts.substep, args: argsC);

                if (mapC != null && mapC.isNotEmpty) {
                  step.substeps = mapC.map((c) {
                    return SubstepLogicalModel(
                        model: SubstepDatabaseModel.fromMap(c));
                  }).toList();
                }
              }
            }
          }
        }
      }

      model.status = EntityStatus.Completed;
      stream.sink.add(model);

      return true;
    } catch (error) {
      stream.sink.add(WorkflowStreamModel(status: EntityStatus.Completed));
      log(error.toString());
      return false;
    }
  }

  Future<bool> updateWorkflow({required WorkflowLogicalModel model}) async {
    try {
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "Usuário ainda não logado";
      if (model.model == null) throw "O modelo do workflow é nulo";

      model.model!.userId = userId;

      Map<String, dynamic> argsA = {'atr_id': model.model!.id};

      if (model.model!.id == null) {
        model.model!.id =
            await methods.create(consts.workflow, map: model.model!.toMap());
      } else {
        await methods.update(consts.workflow,
            map: model.model!.toMap(), args: argsA);
      }

      for (StepLogicalModel? step in model.steps ?? []) {
        if (step?.model != null) {
          Map<String, dynamic> argsB = {'atr_id': step!.model!.id};

          if (step.model!.id == null) {
            step.model!.workflowId = model.model!.id;
            step.model!.id = await methods.create(
              consts.step,
              map: step.model!.toMap(),
            );
          } else {
            await methods.update(consts.step,
                map: step.model!.toMap(), args: argsB);
          }

          for (SubstepLogicalModel? substep in step.substeps ?? []) {
            if (substep?.model != null) {
              Map<String, dynamic> argsC = {'atr_id': substep!.model!.id};

              if (substep.model!.id == null) {
                substep.model!.stepId = step.model!.id;
                substep.model!.id = await methods.create(
                  consts.substep,
                  map: substep.model!.toMap(),
                );
              } else {
                await methods.update(consts.substep,
                    map: substep.model!.toMap(), args: argsC);
              }
            }
          }
        }
      }

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    } finally {
      await readWorkflow();
    }
  }

  Future<bool> deleteWorkflow({required WorkflowLogicalModel model}) async {
    try {
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "Usuário ainda não logado";
      if (model.model == null) throw "O modelo do workflow é nulo";

      //* WORKFLOW *//
      if (model.model != null) {
        Map<String, dynamic> argsA = {};
        argsA['atr_id'] = model.model!.id;

        await methods.delete(consts.workflow, args: argsA);
      }

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    } finally {
      await readWorkflow();
    }
  }
}
