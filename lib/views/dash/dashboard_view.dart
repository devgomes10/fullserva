import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  DateTime _selectedDate = DateTime.now();
  final NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

  void _changeMonth(bool increment) {
    setState(() {
      if (increment) {
        _selectedDate =
            DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
      } else {
        _selectedDate =
            DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("PAINEL"),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_left),
                  onPressed: () => _changeMonth(false),
                ),
                Text(
                  DateFormat.yMMMM('pt_BR').format(_selectedDate),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_right),
                  onPressed: () => _changeMonth(true),
                ),
              ],
            ),
            // StreamBuilder(
            //   stream: AppointmentRepository()
            //       .getTotalAppointmentByMonth(_selectedDate),
            //   builder: (BuildContext context,
            //       AsyncSnapshot<int> appointmentsSnapshot) {
            //     int totalAppointments = appointmentsSnapshot.data ?? 0;
            //     return Text("$totalAppointments");
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
