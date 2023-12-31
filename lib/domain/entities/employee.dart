class Employee {
  String id;
  String name;
  String phone;
  String role;
  bool isVacation;

  Employee({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.isVacation,
  });

  // Converting a map to an instance
  Employee.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        phone = map["phone"],
        role = map["role"],
        isVacation = map["isVacation"];

  // Convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "phone": phone,
      "role": role,
      "isVacation": isVacation,
    };
  }
}
