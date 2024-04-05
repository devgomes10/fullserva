class Offering {
  String id;
  String name;
  int duration;
  double price;
  List<String> coworkerIds;

  Offering({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.coworkerIds,
  });

  // Converting a map to an instance
  Offering.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        duration = map["duration"],
        price = map["price"],
        coworkerIds = map["coworkerIds"];

  // Convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "duration": duration,
      "price": price,
      "coworkerIds": coworkerIds,
    };
  }
}
