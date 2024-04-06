import 'package:project_x/services/database/model/personal_model.dart';
import 'package:project_x/services/database/model/recover_model.dart';

class UserDatabaseModel {
  int? id;
  int type;
  String login;
  String password;
  int? personalId;

  UserDatabaseModel({
    this.id,
    required this.type,
    required this.login,
    required this.password,
    this.personalId,
  });

  factory UserDatabaseModel.fromMap(Map<String, dynamic> map) {
    return UserDatabaseModel(
      id: map['atr_id'],
      type: map['atr_type'],
      login: map['atr_login'],
      password: map['atr_password'],
      personalId: map['tb_personal_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_type': type,
      'atr_login': login,
      'atr_password': password,
      'tb_personal_atr_id': personalId,
    };
  }
}

class UserLogicalModel {
  UserDatabaseModel? model;
  RecoverLogicalModel? recover;
  PersonalLogicalModel? personal;

  UserLogicalModel({this.model, this.recover, this.personal});
}
