import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController specialtyController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Conta"),
        ),
        body: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Nome do profissional",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Nome é obrigatório";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: specialtyController,
                    decoration: const InputDecoration(
                      labelText: "Especialidade",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Especialidade é obrigatório";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: '(##) #####-####',
                        filter: {"#": RegExp(r'[0-9]')},
                      )
                    ],
                    controller: phoneController,
                    decoration:
                        const InputDecoration(labelText: 'Número do WhatsApp'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'WhatsApp é obrigatório';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
