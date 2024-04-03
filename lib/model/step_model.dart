import 'package:project_x/model/substep_model.dart';

class Step {
  int? id;
  String? name;
  String? description;

  List<Substep?>? substeps;

  //* DATABASE RELATED *//

  int? workflowId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Step({
    this.id,
    this.name,
    this.description,
    this.workflowId,
    this.createdAt,
    this.updatedAt,
  });

  factory Step.fromMap(Map<String, dynamic> map) {
    return Step(
      id: map['atr_id'],
      name: map['atr_name'],
      description: map['atr_description'],
      workflowId: map['tb_workflow_atr_id'],
      createdAt: DateTime.tryParse(map['atr_created_at'] ?? ''),
      updatedAt: DateTime.tryParse(map['atr_updated_at'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_name': name,
      'atr_description': description,
      'tb_workflow_atr_id': workflowId,
      'atr_created_at': createdAt?.toIso8601String(),
      'atr_updated_at': updatedAt?.toIso8601String(),
    };
  }
}
