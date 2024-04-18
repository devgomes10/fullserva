import 'package:flutter/material.dart';
import 'package:fullserva/controllers/opening_hours_controller.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';
import '../../../domain/entities/opening_hours.dart';

class OpeningHoursFormView extends StatefulWidget {
  final OpeningHours openingHours;

  const OpeningHoursFormView({Key? key, required this.openingHours})
      : super(key: key);

  @override
  State<OpeningHoursFormView> createState() => _OpeningHoursFormViewState();
}

class _OpeningHoursFormViewState extends State<OpeningHoursFormView> {
  bool _isWorking = false;
  int _startTime = 0;
  int _endTime = 0;
  int _startTimeInterval = 0;
  int _endTimeInterval = 0;
  DateFormat formatTime = DateFormat('HH:mm');

  TimeOfDay _startTimeOfDay = const TimeOfDay(
    hour: 8,
    minute: 00,
  );
  TimeOfDay _endTimeOfDay = const TimeOfDay(
    hour: 16,
    minute: 00,
  );

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

  String formatDuration(int minutes) {
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;

    if (hours > 0 && remainingMinutes > 0) {
      return '$hours h e $remainingMinutes m';
    } else if (hours > 0) {
      return '$hours h';
    } else {
      return '$remainingMinutes m';
    }
  }

  @override
  void initState() {
    super.initState();
    _isWorking = widget.openingHours.working;
    _startTime = widget.openingHours.startTime;
    _endTime = widget.openingHours.endTime;
    _startTimeInterval = widget.openingHours.startTimeInterval;
    _endTimeInterval = widget.openingHours.endTimeInterval;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(formatNameDay(widget.openingHours.id)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Aberto:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Switch(
                  value: _isWorking,
                  onChanged: (value) {
                    setState(() {
                      _isWorking = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: () async {
                TimeRange result = await showTimeRangePicker(
                  context: context,
                  fromText: "Das",
                  toText: "Até às",
                  start: _startTimeOfDay,
                  end: _endTimeOfDay,
                  onStartChange: (start) {
                    setState(() {
                      _startTimeOfDay = start;
                    });
                  },
                  onEndChange: (end) {
                    setState(() {
                      _endTimeOfDay = end;
                    });
                  },
                  interval: const Duration(minutes: 5),
                );
              },
              child: Text("$_startTimeOfDay : $_endTimeOfDay"),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    TimeRange result = await showTimeRangePicker(
                      context: context,
                      fromText: "Das",
                      toText: "Até às",
                      start: _startTimeOfDay,
                      end: _endTimeOfDay,
                      disabledTime: TimeRange(
                        startTime: _endTimeOfDay,
                        endTime: _startTimeOfDay,
                      ),
                      interval: const Duration(minutes: 5),
                    );
                  },
                  child: const Text('Definir Intervalo'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                OpeningHours weekDays = OpeningHours(
                  id: widget.openingHours.id,
                  working: _isWorking,
                  startTime: _startTime,
                  endTime: _endTime,
                  startTimeInterval: _startTimeInterval,
                  endTimeInterval: _endTimeInterval,
                );

                print("startTime: $_startTime");

                await OpeningHoursController().updateOpeningHours(weekDays);

                Navigator.pop(context);
              },
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
  }
}
