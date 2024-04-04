class SubstepDatabaseModel {
  int? id;
  String name;
  String? description;
  bool status;
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
      status: map['atr_status'] == 1 ? true : false,
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
      'atr_status': status ? 1 : 0,
      'atr_mandatory': mandatory ? 1 : 0,
      'atr_expires_at': expiresAt?.toIso8601String(),
      'atr_concluded_at': concludedAt?.toIso8601String(),
      'tb_step_atr_id': stepId,
    };
  }
}
