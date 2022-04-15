class Address {
  String street;
  double lat;
  double lon;
  String apartment;
  Address({
    required this.street,
    required this.lat,
    required this.lon,
    this.apartment = '',
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'lat': this.lat,
      'lon': this.lon,
      'apartment': this.apartment,
      'street': this.street,
    };
    return map;
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(street: map['street'],
        lat: map['lat'],
        lon: map['lon'],
        apartment: map['apartment']);
  }
}