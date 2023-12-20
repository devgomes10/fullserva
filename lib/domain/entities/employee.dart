import 'package:fullserva/domain/entities/appointment.dart';
import 'package:fullserva/domain/entities/service.dart';

class Employee {
  String id;
  String name;
  String email;
  String expertise;
  List<Service> serviceList;
  List<Appointment> appointmentHistory;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.expertise,
    required this.appointmentHistory,
    required this.serviceList,
  });

  Employee.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        email = map["email"],
        expertise = map["expertise"],
        serviceList = map["serviceList"],
        appointmentHistory = map["appointmentHistory"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "expertise": expertise,
      "serviceList": serviceList,
      "appointmentHistory": appointmentHistory,
    };
  }
}
