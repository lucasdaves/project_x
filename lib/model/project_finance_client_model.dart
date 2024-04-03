class ProjectFinanceClient {
  int? id;
  int userId;
  int? clientId;
  int? financeId;
  int? projectId;

  ProjectFinanceClient({
    this.id,
    required this.userId,
    this.clientId,
    this.financeId,
    this.projectId,
  });

  factory ProjectFinanceClient.fromMap(Map<String, dynamic> map) {
    return ProjectFinanceClient(
      id: map['atr_id'],
      userId: map['tb_user_atr_id'],
      clientId: map['tb_client_atr_id'],
      financeId: map['tb_finance_atr_id'],
      projectId: map['tb_project_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'tb_user_atr_id': userId,
      'tb_client_atr_id': clientId,
      'tb_finance_atr_id': financeId,
      'tb_project_atr_id': projectId,
    };
  }
}
