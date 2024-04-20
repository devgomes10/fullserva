class Offering {
  String id;
  String name;
  int duration;
  double price;

  Offering({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
  });

  Offering.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        duration = map["duration"],
        price = map["price"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "duration": duration,
      "price": price,
    };
  }
}
