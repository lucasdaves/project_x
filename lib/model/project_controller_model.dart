import 'package:project_x/services/database/model/project_model.dart';

class ProjectStreamModel {
  List<ProjectLogicalModel?>? projects;

  ProjectStreamModel({this.projects});

  ProjectStreamModel copy() {
    return ProjectStreamModel(
      projects: projects?.map((project) {
        return ProjectLogicalModel(model: project?.model);
      }).toList(),
    );
  }
}
