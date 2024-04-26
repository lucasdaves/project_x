import 'package:flutter/material.dart';
import 'package:project_x/controller/system_controller.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_extension.dart';

class FinanceOperationDatabaseModel {
  int? id;
  int? type;
  String? description;
  String? status;
  String? amount;
  DateTime? expiresAt;
  int? financeId;

  FinanceOperationDatabaseModel({
    this.id,
    this.type,
    this.description,
    this.status,
    this.amount,
    this.expiresAt,
    this.financeId,
  });

  static Map<int, String> statusMap = {
    0: "A pagar",
    1: "Pago",
  };

  factory FinanceOperationDatabaseModel.fromMap(Map<String, dynamic> map) {
    return FinanceOperationDatabaseModel(
      id: map['atr_id'],
      type: map['atr_type'],
      description: map['atr_description'],
      status: statusMap[map['atr_status']],
      amount: map['atr_amount'],
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
      'atr_status': statusMap.values.toList().indexWhere((e) => e == status),
      'atr_amount': amount,
      'atr_expires_at': expiresAt?.toIso8601String(),
      'tb_finance_atr_id': financeId,
    };
  }

  FinanceOperationDatabaseModel copy() {
    return FinanceOperationDatabaseModel(
      id: this.id,
      type: this.type,
      description: this.description,
      status: this.status,
      amount: this.amount,
      expiresAt: this.expiresAt,
      financeId: this.financeId,
    );
  }
}

class FinanceOperationLogicalModel {
  FinanceOperationDatabaseModel? model;

  FinanceOperationLogicalModel({this.model});

  FinanceOperationLogicalModel copy() {
    return FinanceOperationLogicalModel(
      model: this.model?.copy(),
    );
  }

  Map<String, Color> getStatus() {
    Map<String, Color> map = {};

    DateTime? expiration = model?.expiresAt;
    int? reminderDate = int.tryParse(SystemController
            .instance.stream.value.system?.model?.financeReminderDate ??
        "");

    if (FinanceOperationDatabaseModel.statusMap[1] == model?.status) {
      map["Pago"] = AppColor.colorPositiveStatus;
      return map;
    }

    if (expiration != null) {
      Duration difference = expiration.difference(DateTime.now());
      int daysDifference = difference.inDays;

      if (DateTime.now().isAfter(expiration)) {
        map["Atrasado (${expiration.formatString()})"] =
            AppColor.colorNegativeStatus;
        return map;
      } else if (reminderDate != null && (daysDifference <= reminderDate)) {
        map["Em alerta (${expiration.formatString()})"] =
            AppColor.colorAlertStatus;
        return map;
      } else {
        map["Andamento (${expiration.formatString()})"] =
            AppColor.colorNeutralStatus;
        return map;
      }
    }

    map["Não informado"] = AppColor.text_1;
    return map;
  }
}
