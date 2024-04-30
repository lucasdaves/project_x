import 'package:project_x/controller/association_controller.dart';
import 'package:project_x/services/database/model/project_finance_client_model.dart';
import 'package:project_x/services/database/model/project_model.dart';
import 'package:project_x/utils/app_enum.dart';

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
}
