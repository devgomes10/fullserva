import 'package:flutter/material.dart';
import 'package:fullserva/controllers/coworker_controller.dart';
import 'package:fullserva/controllers/offering_controller.dart';
import 'package:fullserva/domain/entities/coworker.dart';
import 'package:fullserva/domain/entities/offering.dart';
import '../../utils/consts/unique_id.dart';

class CoworkerFormView extends StatefulWidget {
  final Coworker? model;

  const CoworkerFormView({Key? key, this.model}) : super(key: key);

  @override
  State<CoworkerFormView> createState() => _CoworkerFormViewState();
}

class _CoworkerFormViewState extends State<CoworkerFormView> {
  final _formKey = GlobalKey<FormState>();

  final CoworkerController _coworkerController = CoworkerController();
  final OfferingController _offeringController = OfferingController();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final ValueNotifier<int> _selectedRole = ValueNotifier<int>(-1);

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      _nameController.text = widget.model!.name;
      _emailController.text = widget.model!.email;
      _passwordController.text = widget.model!.password;
      _phoneController.text = widget.model!.phone;
      _selectedRole.value = widget.model!.role;
    }
  }

  @override
  Widget build(BuildContext context) {
    final coworkerModel = widget.model;
    return Scaffold(
      appBar: AppBar(
        title: const Text("NOVO COLABORADOR"),
        actions: coworkerModel != null
            ? [
                // excluding coworker when editing
                IconButton(
                  onPressed: () async {
                    await _coworkerController.removeCoworker(coworkerModel.id);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete),
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
                valueListenable: _selectedRole,
                builder: (context, selectedIndex, _) {
                  return ToggleButtons(
                    isSelected: [
                      selectedIndex == 0,
                      selectedIndex == 1,
                      selectedIndex == 2
                    ],
                    onPressed: (int index) {
                      _selectedRole.value = index;
                    },
                    children: const <Widget>[
                      Text('Operacional'),
                      Text('Assistencial'),
                      Text('Administrativo'),
                    ],
                  );
                },
              ),
              const SizedBox(height: 26),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  hintText: "Qual o nome do colaborador?",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o nome do colaborador';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 26),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email de acesso',
                  hintText: "Qual o email para acessar a conta?",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o email do colaborador';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 26),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha de acesso',
                  hintText: "Qual a senha para acessar a conta?",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite a senha de acesso';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 26),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone do Colaborador',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o telefone do colaborador';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 26),
              const Text(
                "Quais serviços esse colaborador realiza?",
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
                child: StreamBuilder<List<Offering>>(
                  stream: _offeringController.getOfferings(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text('Erro ao carregar os dados'));
                    }
                    final offerings = snapshot.data!;
                    if (offerings.isEmpty) {
                      return const Center(
                          child: Text('Nenhum dado disponível'));
                    }
                    return ListView.builder(
                      itemCount: offerings.length,
                      // Dentro do itemBuilder do ListView.builder do StreamBuilder em CoworkerFormView
                      itemBuilder: (context, index) {
                        final offering = offerings[index];
                        final isSelected = widget.model != null &&
                            offering.coworkerIds.contains(widget.model!.id);
                        final isSelectedNotifier =
                            ValueNotifier<bool>(isSelected);

                        return ValueListenableBuilder<bool>(
                          valueListenable: isSelectedNotifier,
                          builder: (context, value, child) {
                            return CheckboxListTile(
                              title: Text(offering.name),
                              value: value,
                              onChanged: (bool? newValue) {
                                if (newValue!) {
                                  if (!isSelected) {
                                    setState(() {
                                      offering.coworkerIds
                                          .add(widget.model!.id);
                                    });
                                  }
                                } else {
                                  if (isSelected) {
                                    setState(() {
                                      offering.coworkerIds
                                          .remove(widget.model!.id);
                                    });
                                  }
                                }
                                isSelectedNotifier.value = newValue;
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 42),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Coworker coworker = Coworker(
                      id: uniqueId,
                      name: _nameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      phone: _phoneController.text,
                      role: _selectedRole.value,
                    );

                    if (coworkerModel != null) {
                      await _coworkerController.updateCoworker(coworker);
                    } else {
                      await _coworkerController.addCoworker(coworker);
                    }

                    Navigator.pop(context, true);
                  }
                },
                child: Text(coworkerModel != null ? "ATUALIZAR" : "ADICIONAR"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
