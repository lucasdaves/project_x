import 'package:project_x/services/database/model/step_model.dart';
import 'package:project_x/services/database/model/substep_model.dart';
import 'package:project_x/services/database/model/workflow_model.dart';
import 'package:project_x/utils/app_enum.dart';

class WorkflowStreamModel {
  EntityStatus status;
  List<WorkflowLogicalModel?>? workflows;

  WorkflowStreamModel({this.status = EntityStatus.Idle, this.workflows});

  WorkflowStreamModel copy() {
    return WorkflowStreamModel(
      workflows: workflows?.map((workflow) {
        return WorkflowLogicalModel(
          model: workflow?.model,
          steps: workflow?.steps?.map((step) {
            return StepLogicalModel(
              model: step?.model,
              substeps: step?.substeps?.map((substep) {
                return SubstepLogicalModel(model: substep?.model);
              }).toList(),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  List<WorkflowLogicalModel?> getAll() {
    return workflows ?? [];
  }

  WorkflowLogicalModel? getOne({int? id, String? name}) {
    for (WorkflowLogicalModel? entity in workflows ?? []) {
      if (id != null && entity?.model?.id == id) {
        return entity;
      } else if (name != null && entity?.model?.name == name) {
        return entity;
      }
    }
    return null;
  }

  Map<int, String> getMap() {
    Map<int, String> map = {};
    for (WorkflowLogicalModel? entity in workflows ?? []) {
      map.addAll({entity!.model!.id!: entity.model!.name!});
    }
    return map;
  }
}
