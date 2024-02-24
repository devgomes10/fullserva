class Service {
  String id;
  String name;
  int duration;
  double price;
  List<String> employeeIds;

  Service({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.employeeIds,
  });

  // Converting a map to an instance
  Service.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        duration = map["duration"],
        price = map["price"],
        employeeIds = map["employeeIds"];

  // Convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "duration": duration,
      "price": price,
      "employeeIds": employeeIds,
    };
  }
}
