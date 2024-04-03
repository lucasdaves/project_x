class Substep {
  int? id;
  String? name;
  String? description;
  bool? mandatory;

  //* DATABASE RELATED *//

  int? stepId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Substep({
    this.id,
    this.name,
    this.description,
    this.mandatory,
    this.stepId,
    this.createdAt,
    this.updatedAt,
  });

  factory Substep.fromMap(Map<String, dynamic> map) {
    return Substep(
      id: map['atr_id'],
      name: map['atr_name'],
      description: map['atr_description'],
      mandatory: map['atr_mandatory'] == 1,
      stepId: map['tb_step_atr_id'],
      createdAt: DateTime.tryParse(map['atr_created_at'] ?? ''),
      updatedAt: DateTime.tryParse(map['atr_updated_at'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_name': name,
      'atr_description': description,
      'atr_mandatory': mandatory == true ? 1 : 0,
      'tb_step_atr_id': stepId,
      'atr_created_at': createdAt?.toIso8601String(),
      'atr_updated_at': updatedAt?.toIso8601String(),
    };
  }
}
