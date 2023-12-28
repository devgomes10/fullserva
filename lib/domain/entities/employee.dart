import 'package:fullserva/domain/entities/appointment.dart';
import 'package:fullserva/domain/entities/service.dart';

class Employee {
  String id;
  String name;
  List<Service> serviceList;
  List<Appointment> appointmentHistory;
  bool isVacation;

  Employee({
    required this.id,
    required this.name,
    required this.appointmentHistory,
    required this.serviceList,
    required this.isVacation,
  });

  Employee.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        serviceList = map["serviceList"],
        appointmentHistory = map["appointmentHistory"],
        isVacation = map["isVacation"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "serviceList": serviceList,
      "appointmentHistory": appointmentHistory,
      "isVacation": isVacation,
    };
  }
}
