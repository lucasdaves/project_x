class PersonalModel {
  int? id;
  String? name;
  String? document;
  String? email;
  String? phone;
  int? gender;
  DateTime? birth;
  String? annotation;
  int? addressId;
  DateTime? createdAt;
  DateTime? updatedAt;

  PersonalModel({
    this.id,
    this.name,
    this.document,
    this.email,
    this.phone,
    this.gender,
    this.birth,
    this.annotation,
    this.addressId,
    this.createdAt,
    this.updatedAt,
  });

  factory PersonalModel.fromMap(Map<String, dynamic> map) {
    return PersonalModel(
      id: map['atr_id'],
      name: map['atr_name'],
      document: map['atr_document'],
      email: map['atr_email'],
      phone: map['atr_phone'],
      gender: map['atr_gender'],
      birth: DateTime.tryParse(map['atr_birth'] ?? ''),
      annotation: map['atr_annotation'],
      addressId: map['tb_address_atr_id'],
      createdAt: DateTime.tryParse(map['atr_created_at'] ?? ''),
      updatedAt: DateTime.tryParse(map['atr_updated_at'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_name': name,
      'atr_document': document,
      'atr_email': email,
      'atr_phone': phone,
      'atr_gender': gender,
      'atr_birth': birth?.toIso8601String(),
      'atr_annotation': annotation,
      'tb_address_atr_id': addressId,
      'atr_created_at': createdAt?.toIso8601String(),
      'atr_updated_at': updatedAt?.toIso8601String(),
    };
  }
}
