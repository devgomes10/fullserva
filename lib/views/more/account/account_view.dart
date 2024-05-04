import 'package:flutter/material.dart';
import 'package:fullserva/data/authentication/auth_service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _roleController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MINHA CONTA"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nome *",

                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "O nome é obrigatório";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: _phoneController,
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: '(##) #####-####',
                    filter: {"#": RegExp(r'[0-9]')},
                  )
                ],
                decoration: const InputDecoration(
                  labelText: 'Número',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Número é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(
                  labelText: "Cargo",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Cargo é obrigatório";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "E-mail",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "E-mail é obrigatório";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Senha",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "A senha é obrigatório";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text("SALVAR"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
