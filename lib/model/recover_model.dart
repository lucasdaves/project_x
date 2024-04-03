class Recover {
  int? id;
  String? question;
  String? response;
  String code;
  int userId;

  Recover({
    this.id,
    this.question,
    this.response,
    required this.code,
    required this.userId,
  });

  factory Recover.fromMap(Map<String, dynamic> map) {
    return Recover(
      id: map['atr_id'],
      question: map['atr_question'],
      response: map['atr_response'],
      code: map['atr_code'],
      userId: map['tb_user_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_question': question,
      'atr_response': response,
      'atr_code': code,
      'tb_user_atr_id': userId,
    };
  }
}
