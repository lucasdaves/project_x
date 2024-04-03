class System {
  int? id;
  int? language;
  DateTime? reminderDate;

  int? userId;

  System({
    this.id,
    this.language,
    this.reminderDate,
    this.userId,
  });

  factory System.fromMap(Map<String, dynamic> map) {
    return System(
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
}
