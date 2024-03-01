import 'package:flutter/material.dart';
import 'package:fullserva/views/settings/opening_hours/week_days_form.dart';
import 'package:intl/intl.dart';
import '../../../controllers/week_days_controller.dart';
import '../../../domain/entities/week_days.dart';

class WeekDaysView extends StatefulWidget {
  const WeekDaysView({super.key});

  @override
  _WeekDaysViewState createState() => _WeekDaysViewState();
}

class _WeekDaysViewState extends State<WeekDaysView> {
  final WeekDaysController calendarTimesController = WeekDaysController();
  DateFormat timeFormat = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Horários de atendimento"),
      ),
      body: StreamBuilder<List<WeekDays>>(
        stream: calendarTimesController.getWeekDays(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar os dados: ${snapshot.error}'),
            );
          }
          final days = snapshot.data;
          if (days == null || days.isEmpty) {
            return const Center(
              child: Text('Nenhum dado disponível'),
            );
          }
          return ListView.separated(
            itemBuilder: (context, int i) {

              String getDiaDaSemana(int indice) {
                switch (indice) {
                  case 1:
                    return 'Segunda-feira';
                  case 2:
                    return 'Terça-feira';
                  case 3:
                    return 'Quarta-feira';
                  case 4:
                    return 'Quinta-feira';
                  case 5:
                    return 'Sexta-feira';
                  case 6:
                    return 'Sábado';
                  case 7:
                    return 'Domingo';
                  default:
                    return 'Índice inválido';
                }
              }

              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeekDaysForm(weekDays: days[i]),
                    ),
                  );
                },
                leading: Text(getDiaDaSemana(days[i].id)),
                title: Text(
                    "${timeFormat.format(days[i].startTime)} às ${timeFormat.format(days[i].endTime)}"),
                subtitle: Text(
                    "Intervalo: ${timeFormat.format(days[i].startTimeInterval)} às ${timeFormat.format(days[i].endTimeInterval)}"),
                trailing: const Icon(Icons.arrow_forward_ios),
              );
            },
            separatorBuilder: (_, __) => const Divider(),
            itemCount: days.length,
          );
        },
      ),
    );
  }
}