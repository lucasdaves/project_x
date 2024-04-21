import 'package:project_x/services/database/model/substep_model.dart';

class StepDatabaseModel {
  int? id;
  String name;
  String? description;
  int status;
  bool mandatory;
  DateTime? expiresAt;
  DateTime? concludedAt;
  int? workflowId;

  StepDatabaseModel({
    this.id,
    required this.name,
    this.description,
    required this.status,
    required this.mandatory,
    this.expiresAt,
    this.concludedAt,
    this.workflowId,
  });

  factory StepDatabaseModel.fromMap(Map<String, dynamic> map) {
    return StepDatabaseModel(
      id: map['atr_id'],
      name: map['atr_name'],
      description: map['atr_description'],
      status: map['atr_status'],
      mandatory: map['atr_mandatory'] == 1 ? true : false,
      expiresAt: map['atr_expires_at'] != null
          ? DateTime.parse(map['atr_expires_at'])
          : null,
      concludedAt: map['atr_concluded_at'] != null
          ? DateTime.parse(map['atr_concluded_at'])
          : null,
      workflowId: map['tb_workflow_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_name': name,
      'atr_description': description,
      'atr_status': status,
      'atr_mandatory': mandatory ? 1 : 0,
      'atr_expires_at': expiresAt?.toIso8601String(),
      'atr_concluded_at': concludedAt?.toIso8601String(),
      'tb_workflow_atr_id': workflowId,
    };
  }

  StepDatabaseModel copy() {
    return StepDatabaseModel(
      id: this.id,
      name: this.name,
      description: this.description,
      status: this.status,
      mandatory: this.mandatory,
      expiresAt: this.expiresAt,
      concludedAt: this.concludedAt,
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
