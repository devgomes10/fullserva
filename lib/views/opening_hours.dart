import 'package:flutter/material.dart';
import 'package:fullserva/views/set_opening_hours.dart';

class OpeningHours extends StatefulWidget {
  const OpeningHours({super.key});

  @override
  State<OpeningHours> createState() => _OpeningHoursState();
}

class _OpeningHoursState extends State<OpeningHours> {
  List<WorkingDay> workingDays = [
    WorkingDay(
      day: 'Segunda-feira',
      working: false,
      startTime: 'N/D',
      endTime: 'N/D',
      startTimeInterval: 'N/D',
      endTimeInterval: 'N/D',
    ),
    WorkingDay(
      day: 'Terça-feira',
      working: false,
      startTime: 'N/D',
      endTime: 'N/D',
      startTimeInterval: 'N/D',
      endTimeInterval: 'N/D',
    ),
    WorkingDay(
      day: 'Quarta-feira',
      working: false,
      startTime: 'N/D',
      endTime: 'N/D',
      startTimeInterval: 'N/D',
      endTimeInterval: 'N/D',
    ),
    WorkingDay(
      day: 'Quinta-feira',
      working: false,
      startTime: 'N/D',
      endTime: 'N/D',
      startTimeInterval: 'N/D',
      endTimeInterval: 'N/D',
    ),
    WorkingDay(
      day: 'Sexta-feira',
      working: false,
      startTime: 'N/D',
      endTime: 'N/D',
      startTimeInterval: 'N/D',
      endTimeInterval: 'N/D',
    ),
    WorkingDay(
      day: 'Sábado',
      working: false,
      startTime: 'N/D',
      endTime: 'N/D',
      startTimeInterval: 'N/D',
      endTimeInterval: 'N/D',
    ),
    WorkingDay(
      day: 'Domingo',
      working: false,
      startTime: 'N/D',
      endTime: 'N/D',
      startTimeInterval: 'N/D',
      endTimeInterval: 'N/D',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Horários de atendimento"),
        ),
        body: ListView.builder(
          itemCount: workingDays.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Text(workingDays[index].day),
              title: Text(
                workingDays[index].working
                    ? '${workingDays[index].startTime} às ${workingDays[index].endTime}'
                    : 'Horário não definido',
              ),
              subtitle: Text(
                workingDays[index].working
                    ? '${workingDays[index].startTimeInterval} às ${workingDays[index].endTimeInterval}'
                    : "",
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SetOpeningHours(workingDay: workingDays[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class WorkingDay {
  String day;
  bool working;
  String startTime;
  String endTime;
  String? startTimeInterval;
  String? endTimeInterval;

  WorkingDay({
    required this.day,
    required this.working,
    required this.startTime,
    required this.endTime,
    this.startTimeInterval,
    this.endTimeInterval,
  });

  void updateWorkingHours(
      bool working,
      String startTime,
      String endTime,
      String startTimeInterval,
      String endTimeInterval,
      ) {
    this.working = working;
    this.startTime = startTime;
    this.endTime = endTime;

    if (working) {
      this.startTimeInterval = startTimeInterval;
      this.endTimeInterval = endTimeInterval;
    } else {
      this.startTimeInterval = 'N/D';
      this.endTimeInterval = 'N/D';
    }
  }

}
