import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fullserva/utils/formatting/format_minutes.dart';
import 'package:fullserva/views/more/opening_hours/opening_hours_form_view.dart';
import 'package:intl/intl.dart';
import '../../../controllers/opening_hours_controller.dart';
import '../../../domain/entities/opening_hours.dart';

class OpeningHoursView extends StatefulWidget {
  const OpeningHoursView({super.key});

  @override
  State<OpeningHoursView> createState() => _OpeningHoursViewState();
}

class _OpeningHoursViewState extends State<OpeningHoursView> {
  final OpeningHoursController _openingHoursController =
      OpeningHoursController();
  DateFormat timeFormat = DateFormat('HH:mm');
  late StreamSubscription<List<OpeningHours>> _subscription;

  @override
  void initState() {
    _subscription = _openingHoursController.getOpeningHours().listen((_) {});
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HORÁRIOS DE ATENDIMENTO"),
      ),
      body: StreamBuilder<List<OpeningHours>>(
        stream: _openingHoursController.getOpeningHours(),
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
              String formatNameDay(int index) {
                switch (index) {
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
                      builder: (context) =>
                          OpeningHoursFormView(openingHours: days[i]),
                    ),
                  );
                },
                leading: Text(formatNameDay(days[i].id)),
                title: Text(
                    "${formatMinutes(days[i].startTime)} às ${formatMinutes(days[i].endTime)}"),
                subtitle: Text(
                    "Intervalo: ${formatMinutes(days[i].startTimeInterval)} às ${formatMinutes(days[i].startTimeInterval)}"),
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