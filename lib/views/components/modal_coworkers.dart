import 'package:flutter/material.dart';
import 'package:fullserva/controllers/coworker_controller.dart';
import 'package:fullserva/domain/entities/coworker.dart';

CoworkerController _employeeController = CoworkerController();

Widget modalCoworkers({
  required BuildContext context,
}) {
  return StreamBuilder<List<Coworker>>(
    stream: _employeeController.getCoworker(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return const Center(
          // Adicionar uma imagem
          child: Text('Erro ao carregar os dados'),
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
          return ListTile(
            onTap: () {
              Navigator.pop(context, employees[i]);
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
  );
}
