import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';

class ProjectDatabaseModel {
  int? id;
  String? name;
  String? description;
  String? status;
  int? userId;
  int? addressId;
  int? workflowId;

  ProjectDatabaseModel({
    this.id,
    this.name,
    this.description,
    this.status,
    this.userId,
    this.addressId,
    this.workflowId,
  });

  static Map<int, String> statusMap = {
    0: "Em Aberto",
    1: "Concluído",
    2: "Recisão de Contrato"
  };

  factory ProjectDatabaseModel.fromMap(Map<String, dynamic> map) {
    return ProjectDatabaseModel(
      id: map['atr_id'],
      name: map['atr_name'],
      description: map['atr_description'],
      status: statusMap[map['atr_status']],
      userId: map['tb_user_atr_id'],
      addressId: map['tb_address_atr_id'],
      workflowId: map['tb_workflow_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_name': name,
      'atr_description': description,
      'atr_status': statusMap.values.toList().indexWhere((e) => e == status),
      'tb_user_atr_id': userId,
      'tb_address_atr_id': addressId,
      'tb_workflow_atr_id': workflowId,
    };
  }

  ProjectDatabaseModel copy() {
    return ProjectDatabaseModel(
      id: this.id,
      name: this.name,
      description: this.description,
      status: this.status,
      userId: this.userId,
      addressId: this.addressId,
      workflowId: this.workflowId,
    );
  }
}

class ProjectLogicalModel {
  ProjectDatabaseModel? model;

  ProjectLogicalModel({this.model});

  ProjectLogicalModel copy() {
    return ProjectLogicalModel(model: this.model?.copy());
  }

  Map<Map<String, bool>, Color> getStatus() {
    Map<Map<String, bool>, Color> map = {};
    if (ProjectDatabaseModel.statusMap[0] == model?.status) {
      map[{model!.status!: true}] = AppColor.colorNeutralStatus;
    } else if (ProjectDatabaseModel.statusMap[1] == model?.status) {
      map[{model!.status!: false}] = AppColor.colorPositiveStatus;
    } else {
      map[{model!.status!: false}] = AppColor.colorOpcionalStatus;
    }
    return map;
  }
}
