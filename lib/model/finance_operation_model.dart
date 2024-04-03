class FinanceOperation {
  int? id;
  int type;
  String description;
  String amount;
  DateTime? paidAt;
  DateTime? expiresAt;
  int financeId;

  FinanceOperation({
    this.id,
    required this.type,
    required this.description,
    required this.amount,
    this.paidAt,
    this.expiresAt,
    required this.financeId,
  });

  factory FinanceOperation.fromMap(Map<String, dynamic> map) {
    return FinanceOperation(
      id: map['atr_id'],
      type: map['atr_type'],
      description: map['atr_description'],
      amount: map['atr_amount'],
      paidAt: map['atr_paid_at'] != null
          ? DateTime.parse(map['atr_paid_at'])
          : null,
      expiresAt: map['atr_expires_at'] != null
          ? DateTime.parse(map['atr_expires_at'])
          : null,
      financeId: map['tb_finance_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_type': type,
      'atr_description': description,
      'atr_amount': amount,
      'atr_paid_at': paidAt?.toIso8601String(),
      'atr_expires_at': expiresAt?.toIso8601String(),
      'tb_finance_atr_id': financeId,
    };
  }
}
