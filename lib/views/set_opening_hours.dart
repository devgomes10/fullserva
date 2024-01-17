// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../domain/entities/calendar_times.dart';
//
// class SetOpeningHours extends StatefulWidget {
//
//   const SetOpeningHours({Key? key}) : super(key: key);
//
//   @override
//   State<SetOpeningHours> createState() => _SetOpeningHoursState();
// }
//
// class _SetOpeningHoursState extends State<SetOpeningHours> {
//   bool working = false;
//   DateTime startTime = DateTime.now();
//   DateTime endTime = DateTime.now();
//   DateTime startTimeInterval = DateTime.now();
//   DateTime endTimeInterval = DateTime.now();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Configurar Dia de Trabalho'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const Text('Aberto:'),
//                 Switch(
//                   value: working,
//                   onChanged: (value) {
//                     setState(() {
//                       working = value;
//                     });
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16.0),
//             const Text('Horário de Funcionamento:'),
//             RangeSlider(
//               values: RangeValues(
//                 _convertTimeToDouble(startTime),
//                 _convertTimeToDouble(endTime),
//               ),
//               min: 0.0,
//               max: 24.0 * 60.0,
//               divisions: 288,
//               onChanged: (RangeValues values) {
//                 setState(() {
//                   startTime = _convertDoubleToTime(values.start);
//                   endTime = _convertDoubleToTime(values.end);
//                 });
//               },
//               labels: RangeLabels(
//                 _formatTime(startTime),
//                 _formatTime(endTime),
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             Text('Intervalo: $startTimeInterval - $endTimeInterval'),
//             const SizedBox(height: 8.0),
//             Row(
//               children: [
//                 ElevatedButton(
//                   onPressed: () async {
//                     TimeRange? result = await showDialog(
//                       context: context,
//                       builder: (context) => const IntervalPickerDialog(),
//                     );
//
//                     if (result != null) {
//                       setState(() {
//                         startTimeInterval = result.start;
//                         endTimeInterval = result.end;
//                       });
//                     }
//                   },
//                   child: const Text('Definir Intervalo'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 WorkingDay updatedDay = WorkingDay(
//                   day: listWorkingDays.workingDays[widget.index].day,
//                   working: working,
//                   startTime: startTime,
//                   endTime: endTime,
//                   startTimeInterval: startTimeInterval,
//                   endTimeInterval: endTimeInterval,
//                 );
//
//                 // Atualiza a lista de dias de trabalho usando a função definida em WorkingDays
//                 // Provider.of<WorkingDays>(context, listen: false)
//                 //     .updateWorkingDay(widget.index, updatedDay);
//
//                 // Fecha a tela de configuração de horários
//                 Navigator.pop(context);
//               },
//               child: const Text('Confirmar'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _formatTime(DateTime time) {
//     return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
//   }
//
//   double _convertTimeToDouble(DateTime time) {
//     return time.hour * 60.0 + time.minute;
//   }
//
//   DateTime _convertDoubleToTime(double time) {
//     int hours = time ~/ 60;
//     int minutes = (time % 60).toInt();
//     return DateTime.utc(0, 1, 1, hours, minutes);
//   }
// }
//
// class IntervalPickerDialog extends StatefulWidget {
//   const IntervalPickerDialog({super.key});
//
//   @override
//   _IntervalPickerDialogState createState() => _IntervalPickerDialogState();
// }
//
// class _IntervalPickerDialogState extends State<IntervalPickerDialog> {
//   DateTime startInterval = DateTime.now();
//   DateTime endInterval = DateTime.now();
//
//   double _convertTimeToDouble(DateTime time) {
//     return time.hour * 60.0 + time.minute;
//   }
//
//   DateTime _convertDoubleToTime(double time) {
//     int hours = time ~/ 60;
//     int minutes = (time % 60).toInt();
//     return DateTime.utc(0, 1, 1, hours, minutes);
//   }
//
//   String _formatTime(DateTime time) {
//     return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Definir Intervalo'),
//       content: Column(
//         children: [
//           const Text('Escolha o horário do intervalo:'),
//           RangeSlider(
//             values: RangeValues(
//               _convertTimeToDouble(startInterval),
//               _convertTimeToDouble(endInterval),
//             ),
//             min: 0.0,
//             max: 24.0 * 60.0,
//             divisions: 288,
//             onChanged: (RangeValues values) {
//               setState(() {
//                 startInterval = _convertDoubleToTime(values.start);
//                 endInterval = _convertDoubleToTime(values.end);
//               });
//             },
//             labels: RangeLabels(
//               _formatTime(startInterval),
//               _formatTime(endInterval),
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: const Text('Cancelar'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             Navigator.pop(context, TimeRange(startInterval, endInterval));
//           },
//           child: const Text('Definir'),
//         ),
//       ],
//     );
//   }
// }
//
// class TimeRange {
//   final DateTime start;
//   final DateTime end;
//
//   TimeRange(this.start, this.end);
// }