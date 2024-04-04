class WorkflowDatabaseModel {
  int? id;
  String name;
  String description;
  int? userId;

  WorkflowDatabaseModel({
    this.id,
    required this.name,
    required this.description,
    this.userId,
  });

  factory WorkflowDatabaseModel.fromMap(Map<String, dynamic> map) {
    return WorkflowDatabaseModel(
      id: map['atr_id'],
      name: map['atr_name'],
      description: map['atr_description'],
      userId: map['tb_user_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_name': name,
      'atr_description': description,
      'tb_user_atr_id': userId,
    };
  }
}
