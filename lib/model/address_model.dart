class Address {
  int? id;
  String country;
  String state;
  String city;
  String postalCode;
  String street;
  String number;
  String? complement;

  Address({
    this.id,
    required this.country,
    required this.state,
    required this.city,
    required this.postalCode,
    required this.street,
    required this.number,
    this.complement,
  });

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
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
}
