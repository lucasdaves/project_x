class SystemDatabaseModel {
  int? id;
  int? language;
  DateTime? reminderDate;

  int? userId;

  SystemDatabaseModel({
    this.id,
    this.language,
    this.reminderDate,
    this.userId,
  });

  factory SystemDatabaseModel.fromMap(Map<String, dynamic> map) {
    return SystemDatabaseModel(
      id: map['atr_id'],
      language: map['atr_language'],
      reminderDate: map['atr_reminder_date'] != null
          ? DateTime.parse(map['atr_reminder_date'])
          : null,
      userId: map['tb_user_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_language': language,
      'atr_reminder_date': reminderDate?.toIso8601String(),
      'tb_user_atr_id': userId,
    };
  }

  SystemDatabaseModel copy() {
    return SystemDatabaseModel(
      id: this.id,
      language: this.language,
      reminderDate: this.reminderDate,
      userId: this.userId,
    );
  }
}

class SystemLogicalModel {
  SystemDatabaseModel? model;

  SystemLogicalModel({this.model});

  SystemLogicalModel copy() {
    return SystemLogicalModel(model: this.model?.copy());
  }
}
