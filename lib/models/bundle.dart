class Bundle {
  int id;
  String name;
  String description;
  String type;
  String? images;
  List<dynamic>? ids;
  int discount;
  bool? min;
  int? izbrannoe;

  Bundle(
      {required this.id,
      required this.name,
      required this.description,
      required this.type,
      required this.discount,
      this.min,
      this.ids,
      this.images,
      this.izbrannoe = 0});

  factory Bundle.fromJson(Map<String, dynamic> json) {
    return Bundle(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        type: json['type'],
        ids: List.of(json['ids']),
        discount: json['discount'],
        min: json['min']);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "type": type,
      "discount": discount,
      "izbrannoe": izbrannoe
    };
  }
}
