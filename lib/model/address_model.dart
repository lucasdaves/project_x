class AddressModel {
  int? id;
  String? country;
  String? state;
  String? city;
  String? postalCode;
  String? street;
  String? number;
  String? complement;
  DateTime? createdAt;
  DateTime? updatedAt;

  AddressModel({
    this.id,
    this.country,
    this.state,
    this.city,
    this.postalCode,
    this.street,
    this.number,
    this.complement,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['atr_id'],
      country: map['atr_country'],
      state: map['atr_state'],
      city: map['atr_city'],
      postalCode: map['atr_postal_code'],
      street: map['atr_street'],
      number: map['atr_number'],
      complement: map['atr_complement'],
      createdAt: DateTime.tryParse(map['atr_created_at'] ?? ''),
      updatedAt: DateTime.tryParse(map['atr_updated_at'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atr_id': id,
      'atr_country': country,
      'atr_state': state,
      'atr_city': city,
      'atr_postal_code': postalCode,
      'atr_street': street,
      'atr_number': number,
      'atr_complement': complement,
      'atr_created_at': createdAt?.toIso8601String(),
      'atr_updated_at': updatedAt?.toIso8601String(),
    };
  }
}
