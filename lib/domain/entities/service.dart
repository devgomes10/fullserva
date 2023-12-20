import 'package:fullserva/domain/entities/employee.dart';
import '../enums/service_mode.dart';

class Service {
  String id;
  String name;
  Employee employee;
  String description;
  ServiceMode serviceMode;
  String estimatedDuration;
  double price;

  Service({
    required this.id,
    required this.name,
    required this.employee,
    required this.description,
    required this.serviceMode,
    required this.estimatedDuration,
    required this.price,
  });

  Service.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        employee = Employee.fromMap(map["employee"]),
        description = map["description"],
        serviceMode = map["serviceMode"],
        estimatedDuration = map["estimatedDuration"],
        price = map["price"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "employee": employee,
      "description": description,
      "serviceMode": serviceMode,
      "estimatedDuration": estimatedDuration,
      "price": price,
    };
  }
}
