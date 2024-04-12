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
}
