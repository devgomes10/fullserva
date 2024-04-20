class Coworker {
  String id;
  String name;
  String email;
  String password;
  String phone;
  int role;
  List<String> offeringIds;

  Coworker({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
    required this.offeringIds,
  });

  Coworker.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        email = map["email"],
        password = map["password"],
        phone = map["phone"],
        role = map["role"],
        offeringIds = map["offeringIds"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "role": role,
      "offeringIds": offeringIds,
    };
  }
}
