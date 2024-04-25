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
    0: "A iniciar",
    1: "Em andamento",
    2: "Concluido",
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
}
