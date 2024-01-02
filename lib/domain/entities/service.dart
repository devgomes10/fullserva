class Service {
  String id;
  String name;
  String estimatedDuration;
  double price;

  Service({
    required this.id,
    required this.name,
    required this.estimatedDuration,
    required this.price,
  });

  // Converting a map to an instance
  Service.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        estimatedDuration = map["estimatedDuration"],
        price = map["price"];

  // Convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "estimatedDuration": estimatedDuration,
      "price": price,
    };
  }
}
