import 'package:fullserva/domain/entities/appointment.dart';

class Client {
  String id;
  String name;
  String phone;
  List<Appointment> appointmentHistory;

  Client({
    required this.id,
    required this.name,
    required this.phone,
    required this.appointmentHistory,
  });

  Client.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        phone = map["phone"],
        appointmentHistory = (map["appointmentHistory"] as List)
            .map((appointmentMap) => Appointment.fromMap(appointmentMap))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "phone": phone,
      "appointmentHistory": appointmentHistory,
    };
  }
}
