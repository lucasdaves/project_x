class Client {
  int? id;
  int? personalId;
  int userId;

  Client({
    this.id,
    this.personalId,
    required this.userId,
  });

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['atr_id'],
      personalId: map['tb_personal_atr_id'],
      userId: map['tb_user_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tb_personal_atr_id': personalId,
      'tb_user_atr_id': userId,
    };
  }
}
