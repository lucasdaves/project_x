class RecoverDatabaseModel {
  int? id;
  String? question;
  String? response;
  String code;
  int? userId;

  RecoverDatabaseModel({
    this.id,
    this.question,
    this.response,
    required this.code,
    this.userId,
  });

  factory RecoverDatabaseModel.fromMap(Map<String, dynamic> map) {
    return RecoverDatabaseModel(
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

class RecoverLogicalModel {
  RecoverDatabaseModel? model;

  RecoverLogicalModel({this.model});
}
