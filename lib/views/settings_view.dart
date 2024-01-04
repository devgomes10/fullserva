import 'package:flutter/material.dart';
import 'package:fullserva/views/opening_hours.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Configurações"),
          ),
          body: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OpeningHours(),
                    ),
                  );
                },
                child: const Text("Horários de atendimento"),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text("Conta"),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text("Premium"),
              ),
            ],
          )),
    );
  }
}
