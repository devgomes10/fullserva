import 'package:flutter/material.dart';
import '../controllers/calendar_times_controller.dart';
import '../domain/entities/calendar_times.dart';

class CalendarTimesPage extends StatefulWidget {
  const CalendarTimesPage({super.key});

  @override
  _CalendarTimesPageState createState() => _CalendarTimesPageState();
}

class _CalendarTimesPageState extends State<CalendarTimesPage> {
  final CalendarTimesController _calendarTimesController =
      CalendarTimesController();

  @override
  void initState() {
    super.initState();
    _calendarTimesController.setupInitialCalendarTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Horários de atendimento"),
      ),
      body: StreamBuilder<List<CalendarTimes>>(
        stream: _calendarTimesController.getCalendarTimes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!
                  .map(
                    (calendarTimes) => ListTile(
                      leading: Text(calendarTimes.id),
                      title: Text(
                          "De ${calendarTimes.startTime} a ${calendarTimes.endTime}"),
                      subtitle: Text(
                        calendarTimes.toString(),
                      ),
                    ),
                  )
                  .toList(),
            );
          } else {
            if (snapshot.hasError) {
              print(_calendarTimesController.getCalendarTimes());
            }
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
