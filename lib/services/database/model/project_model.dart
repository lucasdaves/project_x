class ProjectDatabaseModel {
  int? id;
  String? name;
  String? description;
  int? status;
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

  factory ProjectDatabaseModel.fromMap(Map<String, dynamic> map) {
    return ProjectDatabaseModel(
      id: map['atr_id'],
      name: map['atr_name'],
      description: map['atr_description'],
      status: map['atr_status'],
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
      'atr_status': status,
      'tb_user_atr_id': userId,
      'tb_address_atr_id': addressId,
      'tb_workflow_atr_id': workflowId,
    };
  }
}

class ProjectLogicalModel {
  ProjectDatabaseModel? model;

  ProjectLogicalModel({this.model});
}
