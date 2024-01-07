import '../../controllers/appointment_controller.dart';
import 'package:collection/collection.dart';

class AppointmentPoint {
final double x;
final double y;

AppointmentPoint({required this.x, required this.y});
}

Future<List<AppointmentPoint>> get appointmentPoints async {
  final data = await AppointmentController().getAppointmentsCountPerMonth();
  return data.mapIndexed(((index, element) =>
      AppointmentPoint(x: index.toDouble(), y: element))).toList();
}
