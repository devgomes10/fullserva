import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fullserva/domain/entities/client.dart';
import 'package:fullserva/domain/entities/service.dart';
import 'package:fullserva/domain/entities/employee.dart';

class Appointment {
  String id;
  Client client;
  Employee employee;
  Service service;
  DateTime dateTime;
  bool paid;
  bool complete;

  Appointment({
    required this.id,
    required this.client,
    required this.employee,
    required this.service,
    required this.dateTime,
    required this.paid,
    required this.complete,
  });

  Appointment.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        client = Client.fromMap(map["client"]),
        employee = Employee.fromMap(map["employee"]),
        service = Service.fromMap(map["service"]),
        dateTime = (map["dateTime"] as Timestamp).toDate(),
        paid = map["paid"],
        complete = map["complete"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "client": client.toMap(),
      "employee": employee.toMap(),
      "service": service.toMap(),
      "dateTime": dateTime,
      "paid": paid,
      "complete": complete,
    };
  }
}
