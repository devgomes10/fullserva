import 'package:fullserva/domain/entities/client.dart';
import 'package:fullserva/domain/entities/job.dart';
import 'package:fullserva/domain/entities/professional.dart';

class Appointment {
  String id;
  Client client;
  Professional professional;
  Job job;
  DateTime dateTime;
  bool paid;
  bool complete;

  Appointment({
    required this.id,
    required this.client,
    required this.professional,
    required this.job,
    required this.dateTime,
    required this.paid,
    required this.complete,
  });

  Appointment.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        client = map["client"],
        professional = map["professional"],
        job = map["job"],
        dateTime = map["dateTime"],
        paid = map["paid"],
        complete = map["complete"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "client": client,
      "professional": professional,
      "job": job,
      "dateTime": dateTime,
      "paid": paid,
      "complete": complete,
    };
  }
}
