import 'package:flutter/material.dart';
import 'package:fullserva/controllers/employee_controller.dart';
import 'package:fullserva/domain/entities/employee.dart';

EmployeeController _employeeController = EmployeeController();

Widget modalCoworkers({
  required BuildContext context,
}) {
  return StreamBuilder<List<Employee>>(
    stream: _employeeController.getEmployees(),
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
