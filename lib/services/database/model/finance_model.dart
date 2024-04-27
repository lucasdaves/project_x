import 'package:flutter/material.dart';
import 'package:project_x/controller/system_controller.dart';
import 'package:project_x/services/database/model/finance_operation_model.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_extension.dart';

class FinanceDatabaseModel {
  int? id;
  String? name;
  String? description;
  String? status;
  int? userId;
  int? clientId;

  FinanceDatabaseModel({
    this.id,
    this.name,
    this.description,
    this.status,
    this.userId,
    this.clientId,
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
      clientId: map['tb_client_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_name': name,
      'atr_description': description,
      'atr_status': statusMap.values.toList().indexWhere((e) => e == status),
      'tb_user_atr_id': userId,
      'tb_client_atr_id': clientId,
    };
  }

  FinanceDatabaseModel copy() {
    return FinanceDatabaseModel(
      id: this.id,
      name: this.name,
      description: this.description,
      status: this.status,
      userId: this.userId,
      clientId: this.clientId,
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
    map["Inicial"] = double.tryParse(list.first?.model?.amount ?? "0.0") ?? 0.0;
    return map;
  }

  Map<String, double> getParcelsAmount() {
    Map<String, double> map = {};
    List<FinanceOperationLogicalModel?> list = getType(type: 1);
    double sum = list.fold(0.0, (previousValue, element) {
      double amount = double.tryParse(element?.model?.amount ?? "0.0") ?? 0.0;
      return previousValue + amount;
    });
    map["Parcelas"] = sum;
    return map;
  }

  Map<String, double> getAditiveAmount() {
    Map<String, double> map = {};
    List<FinanceOperationLogicalModel?> list = getType(type: 2);
    double sum = list.fold(0.0, (previousValue, element) {
      double amount = double.tryParse(element?.model?.amount ?? "0.0") ?? 0.0;
      return previousValue + amount;
    });
    map["Adicionais"] = sum;
    return map;
  }

  Map<String, double> getCostAmount() {
    Map<String, double> map = {};
    List<FinanceOperationLogicalModel?> list = getType(type: 3);
    double sum = list.fold(0.0, (previousValue, element) {
      double amount = double.tryParse(element?.model?.amount ?? "0.0") ?? 0.0;
      return previousValue + amount;
    });
    map["Custos"] = sum;
    return map;
  }

  Map<String, double> getTotalAmount() {
    Map<String, double> map = {};
    map["Total"] = (getInitialAmount().entries.first.value +
        getAditiveAmount().entries.first.value -
        getCostAmount().entries.first.value);
    return map;
  }

  Map<String, double> getToPayAmount() {
    Map<String, double> map = {};
    double sum = getInitialAmount().entries.first.value -
        getPaidAmount().entries.first.value -
        getLateAmount().entries.first.value;
    map[FinanceDatabaseModel.statusMap[0]!] = sum;
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
    map["Atrasado"] = sum;
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
    map[FinanceDatabaseModel.statusMap[1]!] = sum;
    return map;
  }

  Map<String, Color> getStatus() {
    Map<String, Color> map = {};
    bool isConcluded = true;

    for (FinanceOperationLogicalModel? operation in getType(type: 1)) {
      DateTime? expiration = operation?.model?.expiresAt;
      int? reminderDate = int.tryParse(SystemController
              .instance.stream.value.system?.model?.financeReminderDate ??
          "");

      if (expiration != null) {
        if (DateTime.now().isAfter(expiration)) {
          map["Atrasado (${expiration.formatString()})"] =
              AppColor.colorNegativeStatus;
          return map;
        } else if (reminderDate != null) {
          Duration difference = expiration.difference(DateTime.now());
          int daysDifference = difference.inDays;
          if (daysDifference <= reminderDate) {
            map["Em alerta (${expiration.formatString()})"] =
                AppColor.colorAlertStatus;
            return map;
          }
        }
      }

      if (FinanceOperationDatabaseModel.statusMap[1] !=
          operation?.model?.status!) {
        isConcluded = false;
      }
    }

    if (getType(type: 1).isEmpty) {
      map["A iniciar"] = AppColor.colorOpcionalStatus;
      return map;
    } else if (isConcluded) {
      map["Concluído"] = AppColor.colorPositiveStatus;
      return map;
    } else {
      map["Andamento"] = AppColor.colorNeutralStatus;
      return map;
    }
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
    return parcelsValue <= initialValue;
  }
}
