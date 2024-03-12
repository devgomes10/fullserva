import 'package:flutter/material.dart';

class AppointmentsPageView extends StatefulWidget {
  const AppointmentsPageView({super.key});

  @override
  State<AppointmentsPageView> createState() => _AppointmentsPageViewState();
}

class _AppointmentsPageViewState extends State<AppointmentsPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seus Agendamentos"),
      ),
    );
  }
}
