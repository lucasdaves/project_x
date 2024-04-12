import 'package:project_x/services/database/model/finance_operation_model.dart';

class FinanceDatabaseModel {
  int? id;
  String? name;
  String? description;
  bool? status;
  int? userId;

  FinanceDatabaseModel({
    this.id,
    this.name,
    this.description,
    this.status,
    this.userId,
  });

  factory FinanceDatabaseModel.fromMap(Map<String, dynamic> map) {
    return FinanceDatabaseModel(
      id: map['atr_id'],
      name: map['atr_name'],
      description: map['atr_description'],
      status: map['atr_status'] == 1 ? true : false,
      userId: map['tb_user_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_name': name,
      'atr_description': description,
      'atr_status': (status ?? false) ? 1 : 0,
      'tb_user_atr_id': userId,
    };
  }
}

class FinanceLogicalModel {
  FinanceDatabaseModel? model;
  List<FinanceOperationLogicalModel?>? operations;

  FinanceLogicalModel({this.model, this.operations});
}
