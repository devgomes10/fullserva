import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fullserva/views/components/appointment_point.dart';
import 'package:fullserva/views/components/line_chart_appointment.dart';
import '../controllers/appointment_controller.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late Future<List<AppointmentPoint>> appointmentPoints; // Alterado para Future

  @override
  void initState() {
    super.initState();
    appointmentPoints = getAppointmentPoints(); // Atribuição do Future
  }

  Future<List<AppointmentPoint>> getAppointmentPoints() async {
    final data = await AppointmentController().getAppointmentsCountPerMonth();
    return data
        .mapIndexed(((index, element) =>
            AppointmentPoint(x: index.toDouble(), y: element)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Painel"),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text("Agendamentos"),
              const SizedBox(height: 30),
              FutureBuilder<List<AppointmentPoint>>(
                future: appointmentPoints, // Utilizando o Future
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      width: 350,
                        child: LineChartAppointment(snapshot.data!));} else if (snapshot.hasError) {
                    return Text("Erro ao carregar dados: ${snapshot.error}");
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
