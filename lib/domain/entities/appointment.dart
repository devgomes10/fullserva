import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  String id;
  String clientId;
  String employeeId;
  String serviceId;
  DateTime dateTime;

  Appointment({
    required this.id,
    required this.clientId,
    required this.employeeId,
    required this.serviceId,
    required this.dateTime,
  });

  Appointment.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        clientId = map["client"],
        employeeId = map["employee"],
        serviceId = map["service"],
        dateTime = (map["dateTime"] as Timestamp).toDate();

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "clientId": clientId,
      "employeeId": employeeId,
      "serviceId": serviceId,
      "dateTime": dateTime,
    };
  }
}
