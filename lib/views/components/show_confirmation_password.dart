import 'package:flutter/material.dart';
import '../../data/authentication/auth_service.dart';

showConfirmationPassword({
  required BuildContext context,
  required String email,
}) {
  showDialog(
    context: context,
    builder: (context) {
      TextEditingController confirmationPasswordController =
      TextEditingController();
      return AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        title: Text("Deseja remover a conta com o e-mail $email?"),
        content: SizedBox(
          height: 175,
          child: Column(
            children: [
              const Text("Para confirmar a remoção da conta, insira sua senha"),
              TextFormField(
                controller: confirmationPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text("Senha"),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              AuthService()
                  .removeAccount(password: confirmationPasswordController.text)
                  .then((String? error) {
                if (error == null) {
                  Navigator.pop(context);
                }
              });
            },
            child: const Text(
              "EXCLUIR CONTA",
            ),
          ),
        ],
      );
    },
  );
}