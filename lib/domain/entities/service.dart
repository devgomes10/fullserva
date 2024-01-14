class Service {
  String id;
  String name;
  Duration duration;
  double price;

  Service({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
  });

  // Converting a map to an instance
  Service.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        duration = map["duration"],
        price = map["price"];

  // Convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "duration": duration,
      "price": price,
    };
  }
}
