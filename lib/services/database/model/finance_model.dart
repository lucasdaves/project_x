import 'package:flutter/material.dart';
import 'package:project_x/controller/system_controller.dart';
import 'package:project_x/services/database/model/finance_operation_model.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_extension.dart';
import 'package:screenshot/screenshot.dart';

class FinanceDatabaseModel {
  int? id;
  String? name;
  String? description;
  String? status;
  int? userId;

  FinanceDatabaseModel({
    this.id,
    this.name,
    this.description,
    this.status,
    this.userId,
  });

  static Map<int, String> statusMap = {
    0: "A pagar",
    1: "Pago",
  };

  factory FinanceDatabaseModel.fromMap(Map<String, dynamic> map) {
    return FinanceDatabaseModel(
      id: map['atr_id'],
      name: map['atr_name'],
      description: map['atr_description'],
      status: statusMap[map['atr_status']],
      userId: map['tb_user_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_name': name,
      'atr_description': description,
      'atr_status': statusMap.values.toList().indexWhere((e) => e == status),
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

  Map<String, double> getInitialAmount() {
    Map<String, double> map = {};
    List<FinanceOperationLogicalModel?> list = getType(type: 0);
    double sum = double.tryParse(list.first?.model?.amount ?? "0.0") ?? 0.0;
    if (sum < 0) sum = 0;
    map["Inicial"] = sum.toPrecision(2);
    return map;
  }

  Map<String, double> getParcelsAmount() {
    Map<String, double> map = {};
    List<FinanceOperationLogicalModel?> list = getType(type: 1);
    double sum = list.fold(0.0, (previousValue, element) {
      double amount = double.tryParse(element?.model?.amount ?? "0.0") ?? 0.0;
      return previousValue + amount;
    });
    if (sum < 0) sum = 0;
    map["Parcelas"] = sum.toPrecision(2);
    return map;
  }

  Map<String, double> getAditiveAmount() {
    Map<String, double> map = {};
    List<FinanceOperationLogicalModel?> list = getType(type: 2);
    double sum = list.fold(0.0, (previousValue, element) {
      double amount = double.tryParse(element?.model?.amount ?? "0.0") ?? 0.0;
      return previousValue + amount;
    });
    if (sum < 0) sum = 0;
    map["Adicionais"] = sum.toPrecision(2);
    return map;
  }

  Map<String, double> getCostAmount() {
    Map<String, double> map = {};
    List<FinanceOperationLogicalModel?> list = getType(type: 3);
    double sum = list.fold(0.0, (previousValue, element) {
      double amount = double.tryParse(element?.model?.amount ?? "0.0") ?? 0.0;
      return previousValue + amount;
    });
    if (sum < 0) sum = 0;
    map["Custos"] = sum.toPrecision(2);
    return map;
  }

  Map<String, double> getTotalAmount() {
    Map<String, double> map = {};
    double sum = (getInitialAmount().entries.first.value +
        getAditiveAmount().entries.first.value -
        getCostAmount().entries.first.value);
    if (sum < 0) sum = 0;
    map["Total"] = sum.toPrecision(2);
    return map;
  }

  Map<String, double> getToPayAmount() {
    Map<String, double> map = {};
    double sum = getInitialAmount().entries.first.value -
        getPaidAmount().entries.first.value -
        getLateAmount().entries.first.value;
    if (sum < 0) sum = 0;
    map[FinanceDatabaseModel.statusMap[0]!] = sum.toPrecision(2);
    return map;
  }

  Map<String, double> getLateAmount() {
    Map<String, double> map = {};
    List<FinanceOperationLogicalModel?> list = getType(type: 1);
    double sum = list.fold(0.0, (previousValue, element) {
      double amount = 0;
      DateTime? expiration = element?.model?.expiresAt;
      if (expiration != null) {
        if (DateTime.now().isAfter(expiration)) {
          amount = double.tryParse(element?.model?.amount ?? "0.0") ?? 0.0;
        }
      }
      return previousValue + amount;
    });
    if (sum < 0) sum = 0;
    map["Atrasado"] = sum.toPrecision(2);
    return map;
  }

  Map<String, double> getPaidAmount() {
    Map<String, double> map = {};
    List<FinanceOperationLogicalModel?> list = getType(type: 1);
    double sum = list.fold(0.0, (previousValue, element) {
      double amount = 0;
      if (FinanceDatabaseModel.statusMap[1] == element?.model?.status) {
        amount = double.tryParse(element?.model?.amount ?? "0.0") ?? 0.0;
      }
      return previousValue + amount;
    });
    if (sum < 0) sum = 0;
    map[FinanceDatabaseModel.statusMap[1]!] = sum.toPrecision(2);
    return map;
  }

  Map<String, Color> getStatus() {
    final map = <String, Color>{};

    final financeOperations = getType(type: 1);

    for (FinanceOperationLogicalModel? operation in financeOperations) {
      final expiration = operation?.model?.expiresAt;
      final reminderDate = int.tryParse(SystemController
              .instance.stream.value.system?.model?.financeReminderDate ??
          "");

      if (expiration != null) {
        if (DateTime.now().isAfter(expiration)) {
          map["Atrasado (${expiration.formatString()})"] =
              AppColor.colorNegativeStatus;
          return map;
        } else if (reminderDate != null) {
          final difference = expiration.difference(DateTime.now());
          final daysDifference = difference.inDays;
          if (daysDifference <= reminderDate) {
            map["Em alerta (${expiration.formatString()})"] =
                AppColor.colorAlertStatus;
            return map;
          }
        }
      }
    }

    final isConcluded = financeOperations.every((element) =>
        element?.model?.status == FinanceOperationDatabaseModel.statusMap[1]);
    final isPaid =
        (getInitialAmount().values.first - getPaidAmount().values.first) <= 0;

    if (financeOperations.isEmpty) {
      map["A iniciar"] = AppColor.colorOpcionalStatus;
    } else if (isConcluded && isPaid) {
      map["Pago"] = AppColor.colorPositiveStatus;
    } else if (isConcluded && !isPaid) {
      map["Parcialmente Pago"] = AppColor.colorNeutralStatus;
    } else {
      map["Andamento"] = AppColor.colorNeutralStatus;
    }

    return map;
  }

  String getRelationPaid() {
    List<FinanceOperationLogicalModel?> list = getType(type: 1);
    int sum = list.fold(0, (previousValue, element) {
      bool isPaid = (element?.model?.status != null &&
          FinanceOperationDatabaseModel.statusMap[1] ==
              element?.model?.status!);
      int amount = isPaid ? 1 : 0;
      return previousValue + amount;
    });
    return "$sum/${list.length}";
  }

  DateTime? getParcelDate() {
    List<FinanceOperationLogicalModel?> list = getType(type: 1);

    list.sort((a, b) {
      return a?.model?.expiresAt
              ?.compareTo(b?.model?.expiresAt ?? DateTime.now()) ??
          0;
    });

    for (FinanceOperationLogicalModel? operation in list) {
      DateTime? expiration = operation?.model?.expiresAt;
      int? reminderDate = int.tryParse(SystemController
              .instance.stream.value.system?.model?.financeReminderDate ??
          "");

      if (expiration != null) {
        Duration difference = expiration.difference(DateTime.now());
        int daysDifference = difference.inDays;

        if (DateTime.now().isAfter(expiration)) {
          return expiration;
        } else if (reminderDate != null && (daysDifference <= reminderDate)) {
          return expiration;
        } else {
          return expiration;
        }
      }
    }

    return null;
  }

  bool canIncreaseParcel({required double plus, double minus = 0.0}) {
    double initialValue = getInitialAmount().entries.first.value;
    double parcelsValue = getParcelsAmount().entries.first.value + plus - minus;
    return parcelsValue.toPrecision(2) <= initialValue.toPrecision(2);
  }
}
