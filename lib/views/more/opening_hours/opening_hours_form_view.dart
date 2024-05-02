import 'package:flutter/material.dart';
import 'package:fullserva/controllers/opening_hours_controller.dart';
import 'package:fullserva/utils/formatting/format_minutes.dart';
import 'package:fullserva/utils/formatting/minutes_to_time_of_day.dart';
import 'package:fullserva/utils/formatting/time_of_day_to_minutes.dart';
import 'package:fullserva/utils/themes/theme_colors.dart';
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

  TimeOfDay _startTime = const TimeOfDay(
    hour: 8,
    minute: 00,
  );
  TimeOfDay _endTime = const TimeOfDay(
    hour: 16,
    minute: 00,
  );

  TimeOfDay _startTimeInterval = const TimeOfDay(
    hour: 12,
    minute: 00,
  );
  TimeOfDay _endTimeInterval = const TimeOfDay(
    hour: 13,
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

  @override
  void initState() {
    super.initState();
    _isWorking = widget.openingHours.working;
    _startTime = minutesToTimeOfDay(widget.openingHours.startTime);
    _endTime = minutesToTimeOfDay(widget.openingHours.endTime);
    _startTimeInterval =
        minutesToTimeOfDay(widget.openingHours.startTimeInterval);
    _endTimeInterval = minutesToTimeOfDay(widget.openingHours.endTimeInterval);
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
          children: [
            Row(
              children: [
                const Text(
                  'Aberto:',
                  style: TextStyle(
                    fontSize: 24,
                    // fontWeight: FontWeight.bold,
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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ThemeColors.primary,
              ),
              height: MediaQuery.of(context).size.height * 0.10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Das",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        formatMinutes(timeOfDayToMinutes(_startTime)),
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Até as",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        formatMinutes(timeOfDayToMinutes(_endTime)),
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.38,
              child: TimeRangePicker(
                hideButtons: true,
                hideTimes: true,
                labels: [
                  ClockLabel.fromTime(
                    time: const TimeOfDay(hour: 7, minute: 0),
                    text: "Início",
                  ),
                  ClockLabel.fromTime(
                    time: const TimeOfDay(hour: 18, minute: 0),
                    text: "Fim",
                  ),
                ],
                strokeColor: Theme.of(context).primaryColor.withOpacity(0.5),
                ticksColor: Theme.of(context).primaryColor,
                padding: 60,
                // activeTimeTextStyle: TextStyle(color: Colors.black),
                // autoAdjustLabels: true,
                start: _startTime,
                end: _endTime,
                onStartChange: (start) {
                  setState(() {
                    _startTime = start;
                  });
                },
                onEndChange: (end) {
                  setState(() {
                    _endTime = end;
                  });
                },
                interval: const Duration(minutes: 5),
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await showTimeRangePicker(
                      context: context,
                      fromText: "Das",
                      toText: "Até as",
                      start: _startTimeInterval,
                      end: _endTimeInterval,
                      disabledTime: TimeRange(
                        startTime: _endTime,
                        endTime: _startTime,
                      ),
                      onStartChange: (start) {
                        setState(() {
                          _startTimeInterval = start;
                        });
                      },
                      onEndChange: (end) {
                        setState(() {
                          _endTimeInterval = end;
                        });
                      },
                      interval: const Duration(minutes: 5),
                    );
                  },
                  child: Text("Intervalo: 12:00 às 13:00"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                OpeningHours weekDays = OpeningHours(
                  id: widget.openingHours.id,
                  working: _isWorking,
                  startTime: timeOfDayToMinutes(_startTime),
                  endTime: timeOfDayToMinutes(_endTime),
                  startTimeInterval: timeOfDayToMinutes(_startTimeInterval),
                  endTimeInterval: timeOfDayToMinutes(_endTimeInterval),
                );

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
