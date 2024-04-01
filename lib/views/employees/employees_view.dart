import 'package:flutter/material.dart';
import 'package:fullserva/controllers/employee_controller.dart';
import 'package:fullserva/domain/entities/employee.dart';
import 'package:fullserva/views/employees/employee_form_view.dart';

class EmployeesView extends StatefulWidget {
  const EmployeesView({super.key});

  @override
  State<EmployeesView> createState() => _EmployeesViewState();
}

class _EmployeesViewState extends State<EmployeesView> {
  EmployeeController _employeeController = EmployeeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EQUIPE"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EmployeeFormView()));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Employee>>(
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
              Employee model = employees[i];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmployeeFormView(model: model),
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
