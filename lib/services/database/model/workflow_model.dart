import 'package:project_x/services/database/model/step_model.dart';

class WorkflowDatabaseModel {
  int? id;
  String? name;
  String? description;
  int? userId;

  WorkflowDatabaseModel({
    this.id,
    this.name,
    this.description,
    this.userId,
  });

  factory WorkflowDatabaseModel.fromMap(Map<String, dynamic> map) {
    return WorkflowDatabaseModel(
      id: map['atr_id'],
      name: map['atr_name'],
      description: map['atr_description'],
      userId: map['tb_user_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_name': name,
      'atr_description': description,
      'tb_user_atr_id': userId,
    };
  }

  WorkflowDatabaseModel copy() {
    return WorkflowDatabaseModel(
      id: this.id,
      name: this.name,
      description: this.description,
      userId: this.userId,
    );
  }
}

class WorkflowLogicalModel {
  WorkflowDatabaseModel? model;
  List<StepLogicalModel?>? steps;

  WorkflowLogicalModel({this.model, this.steps});

  WorkflowLogicalModel copy() {
    return WorkflowLogicalModel(
      model: this.model?.copy(),
      steps: this.steps?.map((step) {
        return step?.copy();
      }).toList(),
    );
  }
}
