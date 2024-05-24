import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../data/authentication/auth_service.dart';

showPhoneAppointments({
  required BuildContext context,
}) {
  showDialog(
    context: context,
    builder: (context) {
      final formKey = GlobalKey<FormState>();
      final phoneController = TextEditingController();

      return AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        title: const Text("Insira o seu número de telefone para procurarmos seus agendamentos"),
        content: SizedBox(
          height: 175,
          child: Column(
            children: [
              Form(
                key: formKey,
                child: TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    label: Text("Telefone"),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: '(##) #####-####',
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o telefone do cliente';
                    }
                    if (value.length < 15) {
                      return 'Por favor, insira um número válido';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "FECHAR",
            ),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pushNamed(context, "/appointments", arguments: phoneController.text);
              }
            },
            child: const Text(
              "BUSCAR",
            ),
          ),
        ],
      );
    },
  );
}