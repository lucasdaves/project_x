class ProfessionModel {
  int? id;
  String? name;
  String? document;
  int? personalId;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProfessionModel({
    this.id,
    this.name,
    this.document,
    this.personalId,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfessionModel.fromMap(Map<String, dynamic> map) {
    return ProfessionModel(
      id: map['atr_id'],
      name: map['atr_name'],
      document: map['atr_document'],
      personalId: map['tb_personal_atr_id'],
      createdAt: DateTime.tryParse(map['atr_created_at'] ?? ''),
      updatedAt: DateTime.tryParse(map['atr_updated_at'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_name': name,
      'atr_document': document,
      'tb_personal_atr_id': personalId,
      'atr_created_at': createdAt?.toIso8601String(),
      'atr_updated_at': updatedAt?.toIso8601String(),
    };
  }
}
