class Finance {
  int? id;
  String name;
  String description;
  bool status;
  int userId;

  Finance({
    this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.userId,
  });

  factory Finance.fromMap(Map<String, dynamic> map) {
    return Finance(
      id: map['atr_id'],
      name: map['atr_name'],
      description: map['atr_description'],
      status: map['atr_status'] == 1 ? true : false,
      userId: map['tb_user_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_name': name,
      'atr_description': description,
      'atr_status': status ? 1 : 0,
      'tb_user_atr_id': userId,
    };
  }
}
