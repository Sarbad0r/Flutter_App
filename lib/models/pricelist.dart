class Pricelist {
  int id;
  String image;
  String name;
  String description;
  dynamic price;
  String type;
  int? quantity;
  int? checked;

  Pricelist(
      {required this.id,
      required this.image,
      required this.name,
      required this.description,
      required this.price,
      required this.type,
      this.quantity = 0,
      this.checked = 0});

  factory Pricelist.fromJson(Map<String, dynamic> json) {
    return Pricelist(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "image": image,
      "name": name,
      "description": description,
      "price": price,
      "type": type,
      "quantity": quantity,
      "checked": checked
    };
  }

  Map<String, dynamic> toJsonforCart() {
    return {
      "id": id,
      "image": image,
      "name": name,
      "description": description,
      "price": price,
      "type": type,
      "quantity": quantity
    };
  }
}
