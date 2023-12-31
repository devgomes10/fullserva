import 'package:flutter/material.dart';
import 'package:fullserva/controllers/employee_controller.dart';
import 'package:fullserva/domain/entities/employee.dart';
import 'package:fullserva/views/employee_form_view.dart';

class EmployeeView extends StatefulWidget {
  const EmployeeView({super.key});

  @override
  State<EmployeeView> createState() => _EmployeeViewState();
}

class _EmployeeViewState extends State<EmployeeView> {
  EmployeeController employeeController = EmployeeController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Funcionários"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  const EmployeeFormView(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder<List<Employee>>(
          stream: employeeController.getEmployee(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Employee>> snapshot) {
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
                child: Text("Nenhum dado disponível"),
              );
            }
            return ListView.separated(
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                  onTap: () {},
                  title: Text(
                    employees[i].name,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                );
              },
              separatorBuilder: (_, __) => const Divider(),
              itemCount: employees.length,
            );
          },
        ),
      ),
    );
  }
}
