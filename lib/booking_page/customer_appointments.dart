import 'package:flutter/material.dart';
import 'package:fullserva/controllers/appointment_controller.dart';
import 'package:fullserva/data/repositories/appointment_repository.dart';
import 'package:fullserva/data/repositories/offering_repository.dart';
import 'package:fullserva/domain/entities/appointment.dart';
import 'package:intl/intl.dart';

class CustomerAppointments extends StatefulWidget {
  const CustomerAppointments({super.key});

  @override
  State<CustomerAppointments> createState() => _CustomerAppointmentsState();
}

class _CustomerAppointmentsState extends State<CustomerAppointments> {
  final AppointmentRepository _appointmentRepository = AppointmentRepository();
  final OfferingRepository _offeringRepository = OfferingRepository();

  final AppointmentController _appointmentController = AppointmentController();

  @override
  Widget build(BuildContext context) {
    final phone = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Seus agendamentos"),
      ),
      body: StreamBuilder<List<Appointment>>(
        stream: _appointmentRepository.getAppointmentsByPhone(phone),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum agendamento encontrado.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final appointment = snapshot.data![index];
                return FutureBuilder<String>(
                  future: _offeringRepository
                      .getNameByOffering(appointment.offeringId),
                  builder: (context, nameSnapshot) {
                    if (nameSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return ListTile(
                        title: const Text("Carregando..."),
                        subtitle: Text(appointment.clientPhone),
                      );
                    } else if (nameSnapshot.hasError) {
                      return ListTile(
                        title: Text("Erro: ${nameSnapshot.error}"),
                        subtitle: Text(appointment.clientPhone),
                      );
                    } else {
                      return ListTile(
                        title: Text(nameSnapshot.data ?? "Nome não encontrado"),
                        subtitle: Text(
                            "${DateFormat('dd/MM/yyyy').format(appointment.dateTime)} às ${DateFormat("HH:mm").format(appointment.dateTime)}"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          _showSummaryAppointment(
                              appointment, nameSnapshot.data);
                        },
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showSummaryAppointment(Appointment appointment, String? offeringName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(offeringName!),
        content: const Text("Você deseja desmarcar esse agendamento?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          ),
          TextButton(
            onPressed: () async {
              await _appointmentController.removeAppointment(appointment.id);
              Navigator.pop(context);
            },
            child: const Text("Desmarcar"),
          )
        ],
      ),
    );
  }
}
