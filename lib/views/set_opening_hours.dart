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
  double endTime = 18.0;
  List<TimeRange> intervals = [];

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
                        // Se o dia estiver fechado, redefine o horário de funcionamento e limpa os intervalos
                        startTime = 0.0;
                        endTime = 0.0;
                        intervals.clear();
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
              divisions: 288, // 24 horas * 60 minutos / 5 minutos
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
            Text('Intervalos:'),
            intervals.isEmpty
                ? Text('Nenhum intervalo definido')
                : Text(
              'Intervalo: ${_formatTime(intervals.first.start)} - ${_formatTime(intervals.first.end)}',
            ),
            SizedBox(height: 8.0),
            Column(
              children: intervals.map((interval) {
                return Row(
                  children: [
                    Text('${_formatTime(interval.start)} - ${_formatTime(interval.end)}'),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          intervals.remove(interval);
                        });
                      },
                    ),
                  ],
                );
              }).toList(),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showIntervalPicker();
                  },
                  child: Text('Adicionar Intervalo'),
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
        intervals.add(result);
      });
    }
  }

    void _confirmChanges() {
      // Atualiza o WorkingDay com as alterações
      widget.workingDay.updateWorkingHours(isOpen, _formatTime(startTime), _formatTime(endTime));

      // Volta para a tela anterior com os dados atualizados
      Navigator.pop(context);
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
      title: Text('Adicionar Intervalo'),
      content: Column(
        children: [
          Text('Escolha o horário do intervalo:'),
          RangeSlider(
            values: RangeValues(startInterval, endInterval),
            min: 0.0,
            max: 24.0,
            divisions: 288, // 24 horas * 60 minutos / 5 minutos
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
          child: Text('Adicionar'),
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
