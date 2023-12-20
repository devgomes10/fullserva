import 'package:fullserva/domain/entities/appointment.dart';

class Client {
  String id;
  String name;
  String phone;
  String email;
  List<Appointment> appointmentHistory;
  String? address;

  Client({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.appointmentHistory,
    required this.address,
  });

  Client.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        phone = map["phone"],
        email = map["email"],
        appointmentHistory = (map["appointmentHistory"] as List)
            .map((appointmentMap) => Appointment.fromMap(appointmentMap))
            .toList(),
        address = map["address"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "phone": phone,
      "email": email,
      "appointmentHistory": appointmentHistory,
      "address": address,
    };
  }
}
