import 'package:fullserva/domain/entities/appointment.dart';
import 'package:fullserva/domain/entities/job.dart';

class Professional {
  String id;
  String name;
  String email;
  String expertise;
  List<Job> jobList;
  List<Appointment> appointmentHistory;

  Professional({
    required this.id,
    required this.name,
    required this.email,
    required this.expertise,
    required this.appointmentHistory,
    required this.jobList,
  });

  Professional.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        email = map["email"],
        expertise = map["expertise"],
        jobList = map["jobList"],
        appointmentHistory = map["appointmentHistory"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "expertise": expertise,
      "jobList": jobList,
      "appointmentHistory": appointmentHistory,
    };
  }
}
