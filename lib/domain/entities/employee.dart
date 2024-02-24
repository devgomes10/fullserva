class Employee {
  String id;
  String name;
  String email;
  String password;
  String phone;
  int role;
  List<String> serviceIds;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
    required this.serviceIds,
  });

  // Converting a map to an instance
  Employee.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        email = map["email"],
        password = map["password"],
        phone = map["phone"],
        role = map["role"],
        serviceIds = map["serviceIds"];

  // Convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "role": role,
      "serviceIds": serviceIds,
    };
  }
}
