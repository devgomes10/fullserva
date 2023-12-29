import 'package:fullserva/domain/entities/employee.dart';

class Service {
  String id;
  String name;
  Employee employee;
  String description;
  String estimatedDuration;
  double price;

  Service({
    required this.id,
    required this.name,
    required this.employee,
    required this.description,
    required this.estimatedDuration,
    required this.price,
  });

  // Converting a map to an instance
  Service.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        employee = Employee.fromMap(map["employee"]),
        description = map["description"],
        estimatedDuration = map["estimatedDuration"],
        price = map["price"];

  // Convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "employee": employee,
      "description": description,
      "estimatedDuration": estimatedDuration,
      "price": price,
    };
  }
}
