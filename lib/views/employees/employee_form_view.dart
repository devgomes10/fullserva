import 'package:flutter/material.dart';
import 'package:fullserva/controllers/employee_controller.dart';
import 'package:fullserva/domain/entities/employee.dart';
import 'package:fullserva/domain/entities/service.dart';
import 'package:fullserva/controllers/service_controller.dart';
import 'package:uuid/uuid.dart';

class EmployeeFormView extends StatefulWidget {
  final Employee? model;

  const EmployeeFormView({Key? key, this.model}) : super(key: key);

  @override
  State<EmployeeFormView> createState() => _EmployeeFormViewState();
}

class _EmployeeFormViewState extends State<EmployeeFormView> {
  String uniqueId = const Uuid().v4();
  final _formKey = GlobalKey<FormState>();
  EmployeeController _employeeController = EmployeeController();
  ServiceController _serviceController = ServiceController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  List<String> _selectedServicesIds = [];
  List<String> _servicesIdList = [];

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      _nameController.text = widget.model!.name;
      _emailController.text = widget.model!.email;
      _passwordController.text = widget.model!.password;
      _phoneController.text = widget.model!.phone;
    }
    _fetchAvailableServices();
  }

  void _fetchAvailableServices() {
    _serviceController.getService().listen((services) {
      setState(() {
        _selectedServicesIds.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Equipe"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration:
                const InputDecoration(labelText: 'E-mail de acesso'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _passwordController,
                decoration:
                const InputDecoration(labelText: 'Senha de acesso'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: _phoneController,
                decoration:
                const InputDecoration(labelText: 'Telefone do Colaborador'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Obrigatório';
                  }
                  return null;
                },
              ),
              Text("Atribuir serviços"),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                decoration: BoxDecoration(border: Border.all(width: 5)),
                child: StreamBuilder<List<Service>>(
                  stream: _serviceController.getService(),
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
                    final services = snapshot.data;
                    if (services == null || services.isEmpty) {
                      // Adicionar uma imagem
                      return const Center(
                        child: Text('Nenhum dado disponível'),
                      );
                    }
                    return ListView.builder(
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final service = services[index];
                        final isSelected = _servicesIdList.contains(service.id);
                        final isSelectedNotifier = ValueNotifier<bool>(isSelected);
                        return ValueListenableBuilder<bool>(
                          valueListenable: isSelectedNotifier,
                          builder: (context, value, child) {
                            return CheckboxListTile(
                              title: Text(service.name),
                              value: value,
                              onChanged: (bool? newValue) {
                                isSelectedNotifier.value = newValue!;
                                if (newValue) {
                                  _servicesIdList.add(service.id);
                                } else {
                                  _servicesIdList.remove(service.id);
                                }
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
