import 'package:fullserva/domain/entities/employee.dart';

class Service {
  String id;
  String name;
  List<Employee> employee;
  String estimatedDuration;
  double price;

  Service({
    required this.id,
    required this.name,
    required this.employee,
    required this.estimatedDuration,
    required this.price,
  });

  // Converting a map to an instance
  Service.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        employee = (map["employee"] as List)
            .map((employeeMap) => Employee.fromMap(employeeMap))
            .toList(),
        estimatedDuration = map["estimatedDuration"],
        price = map["price"];

  // Convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "employee": employee,
      "estimatedDuration": estimatedDuration,
      "price": price,
    };
  }
}
