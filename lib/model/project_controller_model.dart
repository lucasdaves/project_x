import 'package:project_x/controller/association_controller.dart';
import 'package:project_x/controller/project_controller.dart';
import 'package:project_x/controller/workflow_controller.dart';
import 'package:project_x/services/database/model/project_finance_client_model.dart';
import 'package:project_x/services/database/model/project_model.dart';
import 'package:project_x/services/database/model/workflow_model.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_extension.dart';

class ProjectStreamModel {
  EntityStatus status;
  List<ProjectLogicalModel?>? projects;

  ProjectStreamModel({this.status = EntityStatus.Idle, this.projects});

  ProjectStreamModel copy() {
    return ProjectStreamModel(
      status: this.status,
      projects: this.projects?.map((project) {
        return ProjectLogicalModel(model: project?.model?.copy());
      }).toList(),
    );
  }

  List<ProjectLogicalModel?> getAll() {
    ProjectStreamModel aux = copy();
    return aux.projects ?? [];
  }

  List<ProjectLogicalModel?> getAllAssociation({int? associationIndex}) {
    ProjectStreamModel aux = copy();

    aux.projects?.removeWhere((element) {
      for (AssociationLogicalModel? association
          in AssociationController.instance.stream.value.getAll()) {
        if (associationIndex != null &&
            associationIndex == element?.model?.id) {
          return false;
        }
        if (association?.model?.projectId == element?.model?.id) {
          return true;
        }
      }
      return false;
    });

    return aux.projects ?? [];
  }

  ProjectLogicalModel? getOne({int? id, String? name}) {
    ProjectStreamModel aux = copy();
    for (ProjectLogicalModel? entity in aux.projects ?? []) {
      if (id != null && entity?.model?.id == id) {
        return entity;
      } else if (name != null && entity?.model?.name == name) {
        return entity;
      }
    }
    return null;
  }

  Map<int, String> getMap() {
    ProjectStreamModel aux = copy();
    Map<int, String> map = {};
    for (ProjectLogicalModel? entity in aux.projects ?? []) {
      map.addAll({entity!.model!.id!: entity.model!.name!});
    }
    return map;
  }

  void filter() {
    if (this.projects != null) {
      this.projects!.sort((a, b) {
        WorkflowLogicalModel? wkModelA = WorkflowController
            .instance.stream.value
            .getOne(id: a?.model?.workflowId);
        WorkflowLogicalModel? wkModelB = WorkflowController
            .instance.stream.value
            .getOne(id: b?.model?.workflowId);

        if (wkModelA != null && wkModelB != null) {
          DateTime? actionA = wkModelA.getLastActionDate().formatDatetime();
          DateTime? actionB = wkModelB.getLastActionDate().formatDatetime();

          if (actionA == null) return 1;
          if (actionB == null) return -1;

          return actionA.compareTo(actionB);
        }
        return 0;
      });
    }
  }

  List<ProjectLogicalModel?>? getSearched() {
    List<ProjectLogicalModel?>? filtered = (this.projects ?? []).where(
      (element) {
        String modelValue = element!.model!.name!.toLowerCase();
        String searchValue =
            ProjectController.instance.search.text.toLowerCase();
        return modelValue.contains(searchValue);
      },
    ).toList();
    return filtered;
  }

  List<ProjectLogicalModel?>? getAssociated(int index) {
    ProjectStreamModel aux = copy();
    List<AssociationLogicalModel?> associations =
        AssociationController.instance.stream.value.getAllClient(index);
    aux.projects?.removeWhere((element) => !associations
        .map((e) => e?.model?.projectId)
        .contains(element?.model?.id));
    return aux.projects;
  }
}
