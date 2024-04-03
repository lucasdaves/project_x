class Workflow {
  int? id;
  String name;
  String description;

  int userId;

  Workflow({
    this.id,
    required this.name,
    required this.description,
    required this.userId,
  });

  factory Workflow.fromMap(Map<String, dynamic> map) {
    return Workflow(
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
