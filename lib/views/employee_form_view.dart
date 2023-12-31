import 'package:flutter/material.dart';
import 'package:fullserva/controllers/employee_controller.dart';
import 'package:fullserva/domain/entities/employee.dart';
import 'package:uuid/uuid.dart';

class EmployeeFormView extends StatefulWidget {
  final Employee? employeeToEdit; // Adicionado para editar funcionários existentes
  const EmployeeFormView({super.key, this.employeeToEdit});

  @override
  State<EmployeeFormView> createState() => _EmployeeFormViewState();
}

class _EmployeeFormViewState extends State<EmployeeFormView> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _phone;
  late String _role;
  bool _isVacation = false;

  @override
  void initState() {
    super.initState();

    // Preenche os campos se estiver editando um funcionário existente
    if (widget.employeeToEdit != null) {
      _name = widget.employeeToEdit!.name;
      _phone = widget.employeeToEdit!.phone;
      _role = widget.employeeToEdit!.role;
      _isVacation = widget.employeeToEdit!.isVacation;
    } else {
      _name = "";
      _phone = "";
      _role = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    EmployeeController employeeController = EmployeeController();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employeeToEdit != null ? "Editar Funcionário" : "Adicionar Funcionário"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Campos de entrada para os atributos do funcionário
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(labelText: "Nome"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Nome é obrigatório";
                }
                return null;
              },
              onSaved: (value) => _name = value!,
            ),
            TextFormField(
              initialValue: _phone,
              decoration: const InputDecoration(labelText: "Telefone"),
              validator: (value) {
                // Adicione validação para o telefone, se necessário
                return null;
              },
              onSaved: (value) => _phone = value!,
            ),
            TextFormField(
              initialValue: _role,
              decoration: const InputDecoration(labelText: "Cargo"),
              validator: (value) {
                // Adicione validação para o cargo, se necessário
                return null;
              },
              onSaved: (value) => _role = value!,
            ),
            SwitchListTile(
              title: const Text("Férias"),
              value: _isVacation,
              onChanged: (value) => setState(() => _isVacation = value),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  Employee employee = Employee(
                    id: widget.employeeToEdit?.id ?? const Uuid().v4(),
                    name: _name,
                    phone: _phone,
                    role: _role,
                    isVacation: _isVacation,
                  );

                  if (widget.employeeToEdit != null) {
                    await employeeController.updateEmployee(employee);
                  } else {
                    await employeeController.addEmployee(employee);
                  }

                  Navigator.pop(context); // Fecha o formulário após salvar
                }
              },
              child: Text(widget.employeeToEdit != null ? "Atualizar" : "Salvar"),
            )
          ],
        ),
      ),
    );
  }
}
