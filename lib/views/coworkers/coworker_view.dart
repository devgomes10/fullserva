import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fullserva/controllers/coworker_controller.dart';
import 'package:fullserva/domain/entities/coworker.dart';
import 'package:fullserva/views/coworkers/coworker_form_view.dart';

class CoworkerView extends StatefulWidget {
  const CoworkerView({super.key});

  @override
  State<CoworkerView> createState() => _CoworkerViewState();
}

class _CoworkerViewState extends State<CoworkerView> {
  final CoworkerController _coworkerController = CoworkerController();
  late StreamSubscription<List<Coworker>> _subscription;

  @override
  void initState() {
    _subscription = _coworkerController.getCoworker().listen((_) {});
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EQUIPE"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CoworkerFormView(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Coworker>>(
        stream: _coworkerController.getCoworker(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              // Adicionar uma imagem
              child: Text('Erro ao carregar os dados: ${snapshot.error}'),
            );
          }
          final employees = snapshot.data;
          if (employees == null || employees.isEmpty) {
            // Adicionar uma imagem
            return const Center(
              child: Text('Nenhum dado disponível'),
            );
          }
          return ListView.separated(
            itemBuilder: (BuildContext context, int i) {
              Coworker model = employees[i];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CoworkerFormView(model: model),
                    ),
                  );
                },
                title: Text(
                  employees[i].name,
                ),
                subtitle: Text(
                  employees[i].email,
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
              );
            },
            separatorBuilder: (_, __) => const Divider(),
            itemCount: employees.length,
          );
        },
      ),
    );
  }
}
