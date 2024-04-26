class SystemDatabaseModel {
  int? id;
  String? financeReminderDate;
  String? workflowReminderDate;
  int? userId;

  SystemDatabaseModel({
    this.id,
    this.financeReminderDate,
    this.workflowReminderDate,
    this.userId,
  });

  factory SystemDatabaseModel.fromMap(Map<String, dynamic> map) {
    return SystemDatabaseModel(
      id: map['atr_id'],
      financeReminderDate: map['atr_finance_reminder_date'],
      workflowReminderDate: map['atr_workflow_reminder_date'],
      userId: map['tb_user_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_finance_reminder_date': financeReminderDate,
      'atr_workflow_reminder_date': workflowReminderDate,
      'tb_user_atr_id': userId,
    };
  }

  SystemDatabaseModel copy() {
    return SystemDatabaseModel(
      id: this.id,
      financeReminderDate: this.financeReminderDate,
      workflowReminderDate: this.workflowReminderDate,
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
