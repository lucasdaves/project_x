class AddressDatabaseModel {
  int? id;
  String country;
  String state;
  String city;
  String postalCode;
  String street;
  String number;
  String? complement;

  AddressDatabaseModel({
    this.id,
    required this.country,
    required this.state,
    required this.city,
    required this.postalCode,
    required this.street,
    required this.number,
    this.complement,
  });

  factory AddressDatabaseModel.fromMap(Map<String, dynamic> map) {
    return AddressDatabaseModel(
      id: map['atr_id'],
      country: map['atr_country'],
      state: map['atr_state'],
      city: map['atr_city'],
      postalCode: map['atr_postal_code'],
      street: map['atr_street'],
      number: map['atr_number'],
      complement: map['atr_complement'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_country': country,
      'atr_state': state,
      'atr_city': city,
      'atr_postal_code': postalCode,
      'atr_street': street,
      'atr_number': number,
      'atr_complement': complement,
    };
  }

  AddressDatabaseModel copy() {
    return AddressDatabaseModel(
      id: this.id,
      country: this.country,
      state: this.state,
      city: this.city,
      postalCode: this.postalCode,
      street: this.street,
      number: this.number,
      complement: this.complement,
    );
  }
}

class AddressLogicalModel {
  AddressDatabaseModel? model;

  AddressLogicalModel({this.model});

  AddressLogicalModel copy() {
    return AddressLogicalModel(
      model: this.model?.copy(),
    );
  }

  String getAddress() {
    if ((model?.street ?? '').isEmpty &&
        (model?.number ?? '').isEmpty &&
        (model?.complement ?? '').isEmpty &&
        (model?.city ?? '').isEmpty &&
        (model?.state ?? '').isEmpty &&
        (model?.postalCode ?? '').isEmpty) {
      return "";
    }

    String addressString = '${model?.street ?? ''}, ${model?.number ?? ''}';
    if (model?.complement != null && model!.complement!.isNotEmpty) {
      addressString += ' - ${model?.complement}';
    }
    addressString +=
        ', ${model?.city ?? ''} - ${model?.state ?? ''}, ${model?.postalCode ?? ''}';
    return addressString;
  }
}
