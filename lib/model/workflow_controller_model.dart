import 'package:project_x/services/database/model/workflow_model.dart';
import 'package:project_x/utils/app_enum.dart';

class WorkflowStreamModel {
  EntityStatus status;
  List<WorkflowLogicalModel?>? workflows;

  WorkflowStreamModel({this.status = EntityStatus.Idle, this.workflows});

  WorkflowStreamModel copy() {
    return WorkflowStreamModel(
      status: this.status,
      workflows: this.workflows?.map((workflow) {
        return workflow?.copy();
      }).toList(),
    );
  }

  List<WorkflowLogicalModel?> getAll({bool removeCopy = false}) {
    WorkflowStreamModel aux = copy();
    if (removeCopy) {
      return (aux.workflows ?? [])
          .where((element) => element?.model?.isCopy != true)
          .toList();
    } else {
      return aux.workflows ?? [];
    }
  }

  WorkflowLogicalModel? getOne({int? id, String? name}) {
    WorkflowStreamModel aux = copy();
    for (WorkflowLogicalModel? entity in aux.workflows ?? []) {
      if (id != null && entity?.model?.id == id) {
        return entity;
      } else if (name != null && entity?.model?.name == name) {
        return entity;
      }
    }
    return null;
  }

  Map<int, String> getMap() {
    WorkflowStreamModel aux = copy();
    Map<int, String> map = {};
    for (WorkflowLogicalModel? entity in aux.workflows ?? []) {
      map.addAll({entity!.model!.id!: entity.model!.name!});
    }
    return map;
  }
}
