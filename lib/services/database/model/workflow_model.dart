import 'package:flutter/material.dart';
import 'package:project_x/controller/system_controller.dart';
import 'package:project_x/services/database/model/step_model.dart';
import 'package:project_x/services/database/model/substep_model.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_extension.dart';

class WorkflowDatabaseModel {
  int? id;
  String? name;
  String? description;
  bool isCopy;
  int? userId;

  WorkflowDatabaseModel({
    this.id,
    this.name,
    this.description,
    required this.isCopy,
    this.userId,
  });

  factory WorkflowDatabaseModel.fromMap(Map<String, dynamic> map) {
    return WorkflowDatabaseModel(
      id: map['atr_id'],
      name: map['atr_name'],
      description: map['atr_description'],
      isCopy: map['atr_copy'] == 1 ? true : false,
      userId: map['tb_user_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_name': name,
      'atr_description': description,
      'atr_copy': isCopy ? 1 : 0,
      'tb_user_atr_id': userId,
    };
  }

  WorkflowDatabaseModel copy() {
    return WorkflowDatabaseModel(
      id: this.id,
      name: this.name,
      description: this.description,
      isCopy: this.isCopy,
      userId: this.userId,
    );
  }
}

class WorkflowLogicalModel {
  WorkflowDatabaseModel? model;
  List<StepLogicalModel?>? steps;

  WorkflowLogicalModel({this.model, this.steps});

  WorkflowLogicalModel copy() {
    return WorkflowLogicalModel(
      model: this.model?.copy(),
      steps: this.steps?.map((step) {
        return step?.copy();
      }).toList(),
    );
  }

  List<int> getRelation() {
    List<int> list = [];
    int total = 0;
    int delivered = 0;
    int started = 0;
    int idle = 0;

    for (StepLogicalModel? step in steps ?? []) {
      for (SubstepLogicalModel? substep in step?.substeps ?? []) {
        String status = substep?.model?.status ?? "";

        switch (SubstepDatabaseModel.statusMap.values
            .toList()
            .indexWhere((e) => e == status)) {
          case 0:
            idle++;
            total++;
            break;
          case 1:
            started++;
            total++;
            break;
          case 2:
            delivered++;
            total++;
            break;
        }
      }
    }

    list = [total, idle, started, delivered];

    return list;
  }

  Map<String, double> getConcludedAmount() {
    Map<String, double> map = {};
    List<int> list = getRelation();
    map[SubstepDatabaseModel.statusMap[2]!] = list[3].toDouble();
    return map;
  }

  Map<String, double> getDoingAmount() {
    Map<String, double> map = {};
    List<int> list = getRelation();
    map[SubstepDatabaseModel.statusMap[1]!] = list[2].toDouble();
    return map;
  }

  Map<String, double> getToDoAmount() {
    Map<String, double> map = {};
    List<int> list = getRelation();
    map[SubstepDatabaseModel.statusMap[0]!] = list[1].toDouble();
    return map;
  }

  Map<String, double> getTotalAmount() {
    Map<String, double> map = {};
    List<int> list = getRelation();
    map["Total"] = list[0].toDouble();
    return map;
  }

  String getRelationConcluded() {
    List<int> list = getRelation();
    return "${list[3]}/${list[0]}";
  }

  Map<String, Color> getStatus() {
    Map<String, Color> map = {};
    bool isConcluded = true;

    for (StepLogicalModel? step in steps ?? []) {
      for (SubstepLogicalModel? substep in step?.substeps ?? []) {
        DateTime? expiration = substep?.model?.expiresAt;
        int? reminderDate = int.tryParse(SystemController
                .instance.stream.value.system?.model?.workflowReminderDate ??
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

        if (SubstepDatabaseModel.statusMap[2] != substep?.model?.status) {
          isConcluded = false;
        }
      }
    }

    if (isConcluded) {
      map["Concluído"] = AppColor.colorPositiveStatus;
      return map;
    } else {
      map["Andamento"] = AppColor.colorNeutralStatus;
      return map;
    }
  }
}
