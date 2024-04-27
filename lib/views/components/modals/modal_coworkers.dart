import 'package:flutter/material.dart';
import 'package:fullserva/controllers/coworker_controller.dart';
import 'package:fullserva/domain/entities/coworker.dart';

CoworkerController _coworkerController = CoworkerController();

Widget modalCoworkers({
  required BuildContext context,
  String? offeringId,
}) {
  return StreamBuilder<List<Coworker>>(
    stream: _coworkerController.getCoworkerByOfferingId(offeringId!),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return  Center(
          // Adicionar uma imagem
          child: Text('Erro ao carregar os dados: ${snapshot.error}'),
        );
      }
      final coworkers = (snapshot.data as List<dynamic>).cast<Coworker>();
      if (coworkers == null || coworkers.isEmpty) {
        // Adicionar uma imagem
        return const Center(
          child: Text('Nenhum dado disponível'),
        );
      }
      return ListView.separated(
        itemBuilder: (BuildContext context, int i) {
          return ListTile(
            onTap: () {
              Navigator.pop(context, coworkers[i]);
            },
            title: Text(
              coworkers[i].name,
            ),
            subtitle: Text(
              coworkers[i].email,
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
          );
        },
        separatorBuilder: (_, __) => const Divider(),
        itemCount: coworkers.length,
      );
    },
  );
}
