import 'package:flutter/material.dart';

import 'account/account_view.dart';
import 'business/business_form_view.dart';
import 'opening_hours/opening_hours_view.dart';

class MoreView extends StatefulWidget {
  const MoreView({super.key});

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
              onPressed: () {},
              child: const Text("Sair"),
            ),
          ],
        ),
      ),
    );
  }
}
