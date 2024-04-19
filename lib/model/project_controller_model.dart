import 'package:project_x/services/database/model/project_model.dart';
import 'package:project_x/utils/app_enum.dart';

class ProjectStreamModel {
  EntityStatus status;
  List<ProjectLogicalModel?>? projects;

  ProjectStreamModel({this.status = EntityStatus.Idle, this.projects});

  ProjectStreamModel copy() {
    return ProjectStreamModel(
      projects: projects?.map((project) {
        return ProjectLogicalModel(model: project?.model);
      }).toList(),
    );
  }

  List<ProjectLogicalModel?> getAll() {
    return projects ?? [];
  }

  ProjectLogicalModel? getOne({int? id, String? name}) {
    for (ProjectLogicalModel? entity in projects ?? []) {
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
    for (ProjectLogicalModel? entity in projects ?? []) {
      map.addAll({entity!.model!.id!: entity.model!.name!});
    }
    return map;
  }
}
