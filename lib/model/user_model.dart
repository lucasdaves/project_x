class UserModel {
  int? id;
  int? type;
  String? login;
  String? password;
  int? personalId;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.id,
    this.type,
    this.login,
    this.password,
    this.personalId,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['atr_id'],
      type: map['atr_type'],
      login: map['atr_login'],
      password: map['atr_password'],
      personalId: map['tb_personal_atr_id'],
      createdAt: DateTime.tryParse(map['atr_created_at'] ?? ''),
      updatedAt: DateTime.tryParse(map['atr_updated_at'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_type': type,
      'atr_login': login,
      'atr_password': password,
      'tb_personal_atr_id': personalId,
      'atr_created_at': createdAt?.toIso8601String(),
      'atr_updated_at': updatedAt?.toIso8601String(),
    };
  }
}
