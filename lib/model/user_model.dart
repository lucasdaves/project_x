class User {
  int? id;
  int type;
  String login;
  String password;
  int? personalId;

  User({
    this.id,
    required this.type,
    required this.login,
    required this.password,
    this.personalId,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['atr_id'],
      type: map['atr_type'],
      login: map['atr_login'],
      password: map['atr_password'],
      personalId: map['tb_personal_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_type': type,
      'atr_login': login,
      'atr_password': password,
      'tb_personal_atr_id': personalId,
    };
  }
}
