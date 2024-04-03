import 'package:project_x/model/step_model.dart';

class Workflow {
  int? id;
  String? name;
  String? description;

  List<Step?>? steps;

  //* DATABASE RELATED *//

  int? userId;
  int? parentId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Workflow({
    this.id,
    this.name,
    this.description,
    this.userId,
    this.parentId,
    this.createdAt,
    this.updatedAt,
  });

  factory Workflow.fromMap(Map<String, dynamic> map) {
    return Workflow(
      id: map['atr_id'],
      name: map['atr_name'],
      description: map['atr_description'],
      userId: map['tb_user_atr_id'],
      parentId: map['tb_workflow_atr_id'],
      createdAt: DateTime.tryParse(map['atr_created_at'] ?? ''),
      updatedAt: DateTime.tryParse(map['atr_updated_at'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_name': name,
      'atr_description': description,
      'tb_user_atr_id': userId,
      'tb_workflow_atr_id': parentId,
      'atr_created_at': createdAt?.toIso8601String(),
      'atr_updated_at': updatedAt?.toIso8601String(),
    };
  }
}
