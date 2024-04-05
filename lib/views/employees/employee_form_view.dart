import 'package:flutter/material.dart';
import 'package:fullserva/controllers/coworker_controller.dart';
import 'package:fullserva/domain/entities/coworker.dart';
import 'package:fullserva/domain/entities/offering.dart';
import 'package:fullserva/controllers/offering_controller.dart';
import 'package:uuid/uuid.dart';

class EmployeeFormView extends StatefulWidget {
  final Coworker? model;

  const EmployeeFormView({Key? key, this.model}) : super(key: key);

  @override
  State<EmployeeFormView> createState() => _EmployeeFormViewState();
}

class _EmployeeFormViewState extends State<EmployeeFormView> {
  String _uniqueId = const Uuid().v4();
  final _formKey = GlobalKey<FormState>();
  CoworkerController _employeeController = CoworkerController();
  OfferingController _serviceController = OfferingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  List<String> _selectedServicesIds = [];
  List<String> _servicesIdList = [];
  int _selectedRole = -1;
  List<bool> _selectionsRole = [false, false, false];
  ValueNotifier<int> _selectedOptionIndex = ValueNotifier<int>(-1);

  void _updateSelectedRole(int i) {
    setState(() {
      for (int buttonIndex = 0;
          buttonIndex < _selectionsRole.length;
          buttonIndex++) {
        if (buttonIndex == i) {
          _selectionsRole[buttonIndex] = true; // Seleciona o botão pressionado
        } else {
          _selectionsRole[buttonIndex] = false; // Desseleciona os outros botões
        }
      }
      _selectedRole = i; // Atualiza o índice da opção selecionada
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      _nameController.text = widget.model!.name;
      _emailController.text = widget.model!.email;
      _passwordController.text = widget.model!.password;
      _phoneController.text = widget.model!.phone;
      _selectedOptionIndex.value = widget.model!.role;
    }
    _fetchAvailableServices();
  }

  void _fetchAvailableServices() {
    _serviceController.getOfferings().listen((services) {
      setState(() {
        _selectedServicesIds.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final employeeModel = widget.model;
    return Scaffold(
      appBar: AppBar(
        title: Text("NOVO COLABORADOR"),
        actions: employeeModel != null
            ? [
                IconButton(
                  onPressed: () async {
                    await _employeeController.removeCoworker(employeeModel.id);
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.delete),
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ValueListenableBuilder<int>(
                valueListenable: _selectedOptionIndex,
                builder: (context, selectedIndex, _) {
                  return ToggleButtons(
                    children: <Widget>[
                      Text('Operacional'),
                      Text('Assistencial'),
                      Text('Administrativo'),
                    ],
                    isSelected: [
                      selectedIndex == 0,
                      selectedIndex == 1,
                      selectedIndex == 2
                    ],
                    onPressed: (int index) {
                      _selectedOptionIndex.value =
                          index; // Atualiza o valor do índice selecionado
                      // Após atualizar o índice selecionado, você pode realizar outras operações aqui
                      // Se necessário, como salvar o valor selecionado em uma variável int
                      int selectedValue = index;
                      print('Valor selecionado: $selectedValue');
                    },
                  );
                },
              ),
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
                decoration: const InputDecoration(labelText: 'Senha de acesso'),
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
                height: 200,
                decoration: BoxDecoration(border: Border.all(width: 5)),
                child: StreamBuilder<List<Offering>>(
                  stream: _serviceController.getOfferings(),
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
                        final isSelected =
                            _selectedServicesIds.contains(service.id);
                        final isSelectedNotifier =
                            ValueNotifier<bool>(isSelected);
                        return ValueListenableBuilder<bool>(
                          valueListenable: isSelectedNotifier,
                          builder: (context, value, child) {
                            return CheckboxListTile(
                              title: Text(service.name),
                              value: value,
                              onChanged: (bool? newValue) {
                                isSelectedNotifier.value = newValue!;
                                if (newValue) {
                                  _selectedServicesIds.add(service.id);
                                } else {
                                  _selectedServicesIds.remove(service.id);
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
              ElevatedButton(
                onPressed: () async {
                  int selectedValue = _selectedOptionIndex.value;
                  if (_formKey.currentState!.validate()) {
                    Coworker coworker = Coworker(
                      id: _uniqueId,
                      name: _nameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      phone: _phoneController.text,
                      role: selectedValue,
                      offeringIds: _selectedServicesIds,
                    );

                    if (employeeModel != null) {
                      await _employeeController.updateCoworker(coworker);
                    } else {
                      await _employeeController.addCoworker(coworker);
                    }
                    Navigator.pop(context, true);
                  }
                },
                child: Text("CONFIRMAR"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
