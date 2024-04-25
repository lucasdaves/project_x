import 'package:project_x/services/database/model/address_model.dart';

class PersonalDatabaseModel {
  int? id;
  String name;
  String document;
  String? email;
  String? phone;
  String? gender;
  DateTime? birth;
  String? annotation;
  String? profession;
  int? addressId;

  PersonalDatabaseModel({
    this.id,
    required this.name,
    required this.document,
    this.email,
    this.phone,
    this.gender,
    this.birth,
    this.annotation,
    this.profession,
    this.addressId,
  });

  factory PersonalDatabaseModel.fromMap(Map<String, dynamic> map) {
    return PersonalDatabaseModel(
      id: map['atr_id'],
      name: map['atr_name'],
      document: map['atr_document'],
      email: map['atr_email'],
      phone: map['atr_phone'],
      gender: map['atr_gender'],
      birth: map['atr_birth'] != null ? DateTime.parse(map['atr_birth']) : null,
      annotation: map['atr_annotation'],
      profession: map['atr_profession'],
      addressId: map['tb_address_atr_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_name': name,
      'atr_document': document,
      'atr_email': email,
      'atr_phone': phone,
      'atr_gender': gender,
      'atr_birth': birth?.toIso8601String(),
      'atr_annotation': annotation,
      'atr_profession': profession,
      'tb_address_atr_id': addressId,
    };
  }

  PersonalDatabaseModel copy() {
    return PersonalDatabaseModel(
      id: this.id,
      name: this.name,
      document: this.document,
      email: this.email,
      phone: this.phone,
      gender: this.gender,
      birth: this.birth,
      annotation: this.annotation,
      profession: this.profession,
      addressId: this.addressId,
    );
  }
}

class PersonalLogicalModel {
  PersonalDatabaseModel? model;
  AddressLogicalModel? address;

  PersonalLogicalModel({this.model, this.address});

  PersonalLogicalModel copy() {
    return PersonalLogicalModel(
      model: this.model?.copy(),
      address: this.address?.copy(),
    );
  }
}
