class RecoverDatabaseModel {
  int? id;
  String? question;
  String? response;
  String code;

  RecoverDatabaseModel({
    this.id,
    this.question,
    this.response,
    required this.code,
  });

  factory RecoverDatabaseModel.fromMap(Map<String, dynamic> map) {
    return RecoverDatabaseModel(
      id: map['atr_id'],
      question: map['atr_question'],
      response: map['atr_response'],
      code: map['atr_code'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_question': question,
      'atr_response': response,
      'atr_code': code,
    };
  }

  RecoverDatabaseModel copy() {
    return RecoverDatabaseModel(
      id: this.id,
      question: this.question,
      response: this.response,
      code: this.code,
    );
  }
}

class RecoverLogicalModel {
  RecoverDatabaseModel? model;

  RecoverLogicalModel({this.model});

  RecoverLogicalModel copy() {
    return RecoverLogicalModel(
      model: this.model?.copy(),
    );
  }
}
