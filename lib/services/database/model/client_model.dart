import 'package:project_x/services/database/model/personal_model.dart';

class ClientDatabaseModel {
  int? id;
  int? personalId;
  int userId;

  ClientDatabaseModel({
    this.id,
    this.personalId,
    required this.userId,
  });

  factory ClientDatabaseModel.fromMap(Map<String, dynamic> map) {
    return ClientDatabaseModel(
      id: map['atr_id'],
      personalId: map['tb_personal_atr_id'],
      userId: map['tb_user_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tb_personal_atr_id': personalId,
      'tb_user_atr_id': userId,
    };
  }

  ClientDatabaseModel copy() {
    return ClientDatabaseModel(
      id: this.id,
      personalId: this.personalId,
      userId: this.userId,
    );
  }
}

class ClientLogicalModel {
  ClientDatabaseModel? model;
  PersonalLogicalModel? personal;

  ClientLogicalModel({this.model, this.personal});

  ClientLogicalModel copy() {
    return ClientLogicalModel(
      model: this.model?.copy(),
      personal: this.personal?.copy(),
    );
  }
}
