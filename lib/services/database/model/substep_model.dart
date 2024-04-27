import 'package:flutter/material.dart';
import 'package:project_x/controller/system_controller.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_extension.dart';

class SubstepDatabaseModel {
  int? id;
  String name;
  String? description;
  String? status;
  DateTime? expiresAt;
  DateTime? concludedAt;
  int? stepId;

  SubstepDatabaseModel({
    this.id,
    required this.name,
    this.description,
    required this.status,
    this.expiresAt,
    this.concludedAt,
    this.stepId,
  });

  static Map<int, String> statusMap = {
    0: "A iniciar",
    1: "Em andamento",
    2: "Concluido",
  };

  factory SubstepDatabaseModel.fromMap(Map<String, dynamic> map) {
    return SubstepDatabaseModel(
      id: map['atr_id'],
      name: map['atr_name'],
      description: map['atr_description'],
      status: statusMap[map['atr_status']],
      expiresAt: map['atr_expires_at'] != null
          ? DateTime.parse(map['atr_expires_at'])
          : null,
      concludedAt: map['atr_concluded_at'] != null
          ? DateTime.parse(map['atr_concluded_at'])
          : null,
      stepId: map['tb_step_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_name': name,
      'atr_description': description,
      'atr_status': statusMap.values.toList().indexWhere((e) => e == status),
      'atr_expires_at': expiresAt?.toIso8601String(),
      'atr_concluded_at': concludedAt?.toIso8601String(),
      'tb_step_atr_id': stepId,
    };
  }

  SubstepDatabaseModel copy() {
    return SubstepDatabaseModel(
      id: this.id,
      name: this.name,
      description: this.description,
      status: this.status,
      expiresAt: this.expiresAt,
      concludedAt: this.concludedAt,
      stepId: this.stepId,
    );
  }
}

class SubstepLogicalModel {
  SubstepDatabaseModel? model;

  SubstepLogicalModel({this.model});

  SubstepLogicalModel copy() {
    return SubstepLogicalModel(
      model: this.model?.copy(),
    );
  }

  Map<String, Color> getStatus() {
    Map<String, Color> map = {};

    DateTime? expiration = model?.expiresAt;
    String? workflowReminderDate = SystemController
        .instance.stream.value.system?.model?.workflowReminderDate;
    int? reminderDate = workflowReminderDate != null
        ? int.tryParse(workflowReminderDate)
        : null;

    if (expiration != null && DateTime.now().isAfter(expiration)) {
      map["Atrasado ${expiration.formatString()}"] =
          AppColor.colorNegativeStatus;
    } else if (expiration != null &&
        reminderDate != null &&
        expiration.difference(DateTime.now()).inDays <= reminderDate) {
      map["Em alerta ${expiration.formatString()}"] = AppColor.colorAlertStatus;
    } else if (SubstepDatabaseModel.statusMap[2] == model?.status) {
      map[SubstepDatabaseModel.statusMap[2]!] = AppColor.colorPositiveStatus;
    } else if (SubstepDatabaseModel.statusMap[1] == model?.status) {
      if (expiration != null) {
        map["${SubstepDatabaseModel.statusMap[1]!} ${expiration.formatString()}"] =
            AppColor.colorNeutralStatus;
      } else {
        map[SubstepDatabaseModel.statusMap[1]!] = AppColor.colorNeutralStatus;
      }
    } else {
      map[SubstepDatabaseModel.statusMap[0]!] = AppColor.colorOpcionalStatus;
    }

    return map;
  }
}
