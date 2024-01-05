import 'package:flutter/material.dart';
import 'opening_hours.dart';

class SetOpeningHours extends StatefulWidget {
  final WorkingDay workingDay;

  const SetOpeningHours({Key? key, required this.workingDay}) : super(key: key);

  @override
  State<SetOpeningHours> createState() => _SetOpeningHoursState();
}

class _SetOpeningHoursState extends State<SetOpeningHours> {
  bool isOpen = false;
  double startTime = 8.0;
  double endTime = 18;
  double startTimeInterval = 12;
  double endTimeInterval = 13;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurar Dia de Trabalho'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Aberto:'),
                Switch(
                  value: isOpen,
                  onChanged: (value) {
                    setState(() {
                      isOpen = value;
                      if (!value) {
                        startTime = 0.0;
                        endTime = 0.0;
                        startTimeInterval = 0;
                        endTimeInterval = 0;
                      }
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text('Horário de Funcionamento:'),
            RangeSlider(
              values: RangeValues(startTime, endTime),
              min: 0.0,
              max: 24.0,
              divisions: 288,
              onChanged: (RangeValues values) {
                setState(() {
                  startTime = values.start;
                  endTime = values.end;
                });
              },
              labels: RangeLabels(
                _formatTime(startTime),
                _formatTime(endTime),
              ),
            ),
            SizedBox(height: 16.0),
            Text('Intervalo: ${_formatTime(startTimeInterval)} - ${_formatTime(endTimeInterval)}'),
            SizedBox(height: 8.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showIntervalPicker();
                  },
                  child: Text('Definir Intervalo'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _confirmChanges();
              },
              child: Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
  }

  _showIntervalPicker() async {
    TimeRange? result = await showDialog(
      context: context,
      builder: (context) => IntervalPickerDialog(),
    );

    if (result != null) {
      setState(() {
        startTimeInterval = result.start;
        endTimeInterval = result.end;
      });
    }
  }

  void _confirmChanges() {
    widget.workingDay.updateWorkingHours(
      isOpen,
      _formatTime(startTime),
      _formatTime(endTime),
      _formatTime(startTimeInterval),
      _formatTime(endTimeInterval),
    );

    // Aguarde um curto período antes de fechar a tela
    Future.delayed(Duration(milliseconds: 100), () {
      Navigator.pop(context);
    });
  }



  String _formatTime(double time) {
    int hours = time.floor();
    int minutes = ((time - hours) * 60).round();
    return '$hours:${minutes.toString().padLeft(2, '0')}';
  }
}

class IntervalPickerDialog extends StatefulWidget {
  @override
  _IntervalPickerDialogState createState() => _IntervalPickerDialogState();
}

class _IntervalPickerDialogState extends State<IntervalPickerDialog> {
  double startInterval = 12.0;
  double endInterval = 13.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Definir Intervalo'),
      content: Column(
        children: [
          Text('Escolha o horário do intervalo:'),
          RangeSlider(
            values: RangeValues(startInterval, endInterval),
            min: 0.0,
            max: 24.0,
            divisions: 288,
            onChanged: (RangeValues values) {
              setState(() {
                startInterval = values.start;
                endInterval = values.end;
              });
            },
            labels: RangeLabels(
              _formatTime(startInterval),
              _formatTime(endInterval),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, TimeRange(startInterval, endInterval));
          },
          child: Text('Definir'),
        ),
      ],
    );
  }

  String _formatTime(double time) {
    int hours = time.floor();
    int minutes = ((time - hours) * 60).round();
    return '$hours:${minutes.toString().padLeft(2, '0')}';
  }
}

class TimeRange {
  final double start;
  final double end;

  TimeRange(this.start, this.end);
}
