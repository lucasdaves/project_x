class SubstepDatabaseModel {
  int? id;
  String name;
  String? description;
  int status;
  bool mandatory;
  DateTime? expiresAt;
  DateTime? concludedAt;
  int? stepId;

  SubstepDatabaseModel({
    this.id,
    required this.name,
    this.description,
    required this.status,
    required this.mandatory,
    this.expiresAt,
    this.concludedAt,
    this.stepId,
  });

  factory SubstepDatabaseModel.fromMap(Map<String, dynamic> map) {
    return SubstepDatabaseModel(
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
      stepId: map['tb_step_atr_id'],
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
      'tb_step_atr_id': stepId,
    };
  }

  SubstepDatabaseModel copy() {
    return SubstepDatabaseModel(
      id: this.id,
      name: this.name,
      description: this.description,
      status: this.status,
      mandatory: this.mandatory,
      expiresAt: this.expiresAt,
      concludedAt: this.concludedAt,
      stepId: this.stepId,
    );
  }
}

class SubstepLogicalModel {
  SubstepDatabaseModel? model;

  SubstepLogicalModel({this.model});

  SubstepLogicalModel copy() {
    return SubstepLogicalModel(
      model: this.model?.copy(),
    );
  }
}
