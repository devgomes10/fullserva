import 'package:flutter/material.dart';
import 'package:fullserva/data/repositories/calendar_times_repository.dart';
import 'package:fullserva/domain/entities/calendar_times.dart';

class CalendarTimesScreen extends StatelessWidget {
  final CalendarTimesRepository _calendarTimesRepository =
  CalendarTimesRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Week Calendar Times'),
      ),
      body: StreamBuilder<List<CalendarTimes>>(
        stream: _calendarTimesRepository.getCalendarTimes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          List<CalendarTimes> calendarTimesList = snapshot.data ?? [];

          return ListView.builder(
            itemCount: calendarTimesList.length,
            itemBuilder: (context, index) {
              CalendarTimes calendarTimes = calendarTimesList[index];

              return ListTile(
                title: Text('Day ${index + 1}'),
                onTap: () {
                  _navigateToEditScreen(context, calendarTimes);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToEditScreen(
      BuildContext context, CalendarTimes calendarTimes) {
    // Navegue para a tela de edição com o objeto CalendarTimes
    // Você pode implementar esta parte dependendo da estrutura do seu aplicativo
  }
}
