import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fullserva/views/components/show_confirmation_password.dart';
import '../../data/authentication/auth_service.dart';
import 'account/account_view.dart';
import 'business/business_form_view.dart';
import 'opening_hours/opening_hours_view.dart';

class MoreView extends StatefulWidget {
  final User user;

  const MoreView({super.key, required this.user});

  @override
  State<MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("MAIS OPÇÕES"),
        ),
        body: Column(
          children: [
            Text(widget.user.email!),
            Text((widget.user.displayName != null)
                ? widget.user.displayName!
                : ""),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OpeningHoursView(),
                  ),
                );
              },
              child: const Text("Horários de atendimento"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Link do site"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BusinessFormView()),
                );
              },
              child: const Text("Página do site"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountView(),
                  ),
                );
              },
              child: const Text("Configurações da conta"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Premium"),
            ),
            ElevatedButton(
              onPressed: () {
                AuthService().logOut();
              },
              child: const Text("Sair"),
            ),
            ElevatedButton(
              onPressed: () {
                showConfirmationPassword(context: context, email: "");
              },
              child: const Text("Remover conta"),
            ),
          ],
        ),
      ),
    );
  }
}
