import 'package:project_x/services/database/model/substep_model.dart';

class StepDatabaseModel {
  int? id;
  String name;
  String? description;
  int? workflowId;

  StepDatabaseModel({
    this.id,
    required this.name,
    this.description,
    this.workflowId,
  });

  factory StepDatabaseModel.fromMap(Map<String, dynamic> map) {
    return StepDatabaseModel(
      id: map['atr_id'],
      name: map['atr_name'],
      description: map['atr_description'],
      workflowId: map['tb_workflow_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_name': name,
      'atr_description': description,
      'tb_workflow_atr_id': workflowId,
    };
  }

  StepDatabaseModel copy() {
    return StepDatabaseModel(
      id: this.id,
      name: this.name,
      description: this.description,
      workflowId: this.workflowId,
    );
  }
}

class StepLogicalModel {
  StepDatabaseModel? model;
  List<SubstepLogicalModel?>? substeps;

  StepLogicalModel({this.model, this.substeps});

  StepLogicalModel copy() {
    return StepLogicalModel(
      model: this.model?.copy(),
      substeps: this.substeps?.map((substep) {
        return substep?.copy();
      }).toList(),
    );
  }
}
