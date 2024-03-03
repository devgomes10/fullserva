class Business {
  String id;
  String name;
  String? email;
  String? phone;
  String? address;

  Business({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.address,
  });

  // Converting a map to an instance
  Business.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        email = map["email"],
        phone = map["phone"],
        address = map["address"];

  // Convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
    };
  }
}