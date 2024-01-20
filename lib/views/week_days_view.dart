import 'package:flutter/material.dart';
import 'package:fullserva/views/week_days_form.dart';
import 'package:intl/intl.dart';
import '../controllers/week_days_controller.dart';
import '../domain/entities/week_days.dart';

class WeekDaysView extends StatefulWidget {
  const WeekDaysView({super.key});

  @override
  _WeekDaysViewState createState() => _WeekDaysViewState();
}

class _WeekDaysViewState extends State<WeekDaysView> {
  final WeekDaysController calendarTimesController = WeekDaysController();
  DateFormat timeFormat = DateFormat('HH:mm');

  @override
  void initState() {
    super.initState();
    calendarTimesController.setupInitialWeekDays();
  }

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
              WeekDays model = days[i];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeekDaysForm(model: model),
                    ),
                  );
                },
                leading: Text(days[i].id.toString()),
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
