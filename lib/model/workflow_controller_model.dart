import 'package:project_x/services/database/model/step_model.dart';
import 'package:project_x/services/database/model/substep_model.dart';
import 'package:project_x/services/database/model/workflow_model.dart';

class WorkflowStreamModel {
  List<WorkflowLogicalModel?>? workflows;

  WorkflowStreamModel({this.workflows});

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
}

class WorkflowLogicalModel {
  WorkflowDatabaseModel? model;
  List<StepLogicalModel?>? steps;

  WorkflowLogicalModel({this.model, this.steps});
}

class StepLogicalModel {
  StepDatabaseModel? model;
  List<SubstepLogicalModel?>? substeps;

  StepLogicalModel({this.model, this.substeps});
}

class SubstepLogicalModel {
  SubstepDatabaseModel? model;

  SubstepLogicalModel({this.model});
}
