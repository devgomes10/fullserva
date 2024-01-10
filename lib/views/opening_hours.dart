import 'package:flutter/material.dart';
import 'package:fullserva/views/components/working_days.dart';
import 'package:fullserva/views/set_opening_hours.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OpeningHours extends StatefulWidget {
  const OpeningHours({super.key});

  @override
  State<OpeningHours> createState() => _OpeningHoursState();
}

class _OpeningHoursState extends State<OpeningHours> {
  final DateFormat _timeFormat = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Horários de atendimento"),
        ),
        body: Consumer<WorkingDays>(
          builder: (BuildContext context, WorkingDays list, Widget? widget) {
            return ListView.separated(
              separatorBuilder: (_, __) => const Divider(),
              itemCount: list.workingDays.length,
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                  leading: Text(list.workingDays[i].day),
                  title: Text(
                    list.workingDays[i].working
                        ? '${_timeFormat.format(list.workingDays[i].startTime!)} às ${_timeFormat.format(list.workingDays[i].endTime!)}'
                        : 'Fechado',
                  ),
                  subtitle: Text(
                    list.workingDays[i].working ||
                            list.workingDays[i].endTimeInterval != null &&
                                list.workingDays[i].startTimeInterval != null
                        ? 'Intervalo: ${_timeFormat.format(list.workingDays[i].startTimeInterval!)} às ${_timeFormat.format(list.workingDays[i].endTimeInterval!)}'
                        : "",
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SetOpeningHours(index: i),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
