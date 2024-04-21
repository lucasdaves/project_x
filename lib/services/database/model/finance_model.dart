import 'package:project_x/services/database/model/finance_operation_model.dart';

class FinanceDatabaseModel {
  int? id;
  String? name;
  String? description;
  int? status;
  int? userId;

  FinanceDatabaseModel({
    this.id,
    this.name,
    this.description,
    this.status,
    this.userId,
  });

  factory FinanceDatabaseModel.fromMap(Map<String, dynamic> map) {
    return FinanceDatabaseModel(
      id: map['atr_id'],
      name: map['atr_name'],
      description: map['atr_description'],
      status: map['atr_status'],
      userId: map['tb_user_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_name': name,
      'atr_description': description,
      'atr_status': status,
      'tb_user_atr_id': userId,
    };
  }

  FinanceDatabaseModel copy() {
    return FinanceDatabaseModel(
      id: this.id,
      name: this.name,
      description: this.description,
      status: this.status,
      userId: this.userId,
    );
  }
}

class FinanceLogicalModel {
  FinanceDatabaseModel? model;
  List<FinanceOperationLogicalModel?>? operations;

  FinanceLogicalModel({this.model, this.operations});

  FinanceLogicalModel copy() {
    return FinanceLogicalModel(
      model: this.model?.copy(),
      operations:
          this.operations?.map((operation) => operation?.copy()).toList(),
    );
  }

  List<FinanceOperationLogicalModel?> getType({required int type}) {
    return operations
            ?.where((operation) => operation?.model?.type == type)
            .toList() ??
        [];
  }

  double getInitialAmount() {
    List<FinanceOperationLogicalModel?> list = getType(type: 0);
    return double.tryParse(list.first?.model?.amount ?? "0.0") ?? 0.0;
  }

  double getParcelsAmount() {
    List<FinanceOperationLogicalModel?> list = getType(type: 1);
    double sum = list.fold(0.0, (previousValue, element) {
      double amount = double.tryParse(element?.model?.amount ?? "0.0") ?? 0.0;
      return previousValue + amount;
    });
    return sum;
  }

  double getAditiveAmount() {
    List<FinanceOperationLogicalModel?> list = getType(type: 2);
    double sum = list.fold(0.0, (previousValue, element) {
      double amount = double.tryParse(element?.model?.amount ?? "0.0") ?? 0.0;
      return previousValue + amount;
    });
    return sum;
  }

  double getCostAmount() {
    List<FinanceOperationLogicalModel?> list = getType(type: 3);
    double sum = list.fold(0.0, (previousValue, element) {
      double amount = double.tryParse(element?.model?.amount ?? "0.0") ?? 0.0;
      return previousValue + amount;
    });
    return sum;
  }

  double getTotalAmount() {
    return getInitialAmount() + getAditiveAmount() - getCostAmount();
  }

  double getRelationAmount({required int type, bool? isPaid, bool? isLate}) {
    List<FinanceOperationLogicalModel?> list = getType(type: type);
    double sum = list.fold(0.0, (previousValue, element) {
      double amount = 0.0;
      if (isLate != null) {
        bool condition = isLate
            ? (element?.model?.expiresAt != null &&
                element?.model?.expiresAt != "")
            : (element?.model?.expiresAt == null &&
                element?.model?.expiresAt == "");
        if (condition) {
          DateTime now = DateTime.now();
          DateTime expiresAt = element?.model?.expiresAt ?? now;
          if (expiresAt.isBefore(now)) {
            amount = double.tryParse(element?.model?.amount ?? "0.0") ?? 0.0;
          }
        }
      } else if (isPaid != null) {
        bool condition = isPaid
            ? (element?.model?.paidAt != null && element?.model?.paidAt != "")
            : (element?.model?.paidAt == null || element?.model?.paidAt == "");
        if (condition) {
          amount = double.tryParse(element?.model?.amount ?? "0.0") ?? 0.0;
        }
      }
      return previousValue + amount;
    });
    return sum;
  }

  String getRelationPaid() {
    List<FinanceOperationLogicalModel?> list = getType(type: 1);
    int sum = list.fold(0, (previousValue, element) {
      bool isPaid =
          element?.model?.paidAt != null && element?.model?.paidAt != "";
      int amount = isPaid ? 1 : 0;
      return previousValue + amount;
    });
    return "$sum/${list.length}";
  }

  DateTime? getParcelDate({required bool isLast}) {
    List<FinanceOperationLogicalModel?> list = getType(type: 1);
    list.sort((a, b) {
      return (isLast)
          ? b?.model?.expiresAt
                  ?.compareTo(a?.model?.expiresAt ?? DateTime.now()) ??
              0
          : a?.model?.expiresAt
                  ?.compareTo(b?.model?.expiresAt ?? DateTime.now()) ??
              0;
    });
    return list.first?.model?.expiresAt;
  }

  int getParcelQuantity() {
    List<FinanceOperationLogicalModel?> list = getType(type: 1);
    return list.length;
  }

  bool canIncreaseParcel({required double plus, double minus = 0.0}) {
    double initialValue = getInitialAmount();
    double parcelsValue = getParcelsAmount() + plus - minus;
    return parcelsValue <= initialValue;
  }
}
