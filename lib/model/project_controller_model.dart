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
}
