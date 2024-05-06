import 'package:flutter/material.dart';
import 'package:fullserva/data/repositories/coworker_repository.dart';
import 'package:fullserva/domain/entities/coworker.dart';

CoworkerRepository _coworkerRepository = CoworkerRepository();

Widget modalCoworkers({
  required BuildContext context,
  String? offeringId,
}) {
  return StreamBuilder<List<Coworker>>(
    stream: offeringId != null
        ? _coworkerRepository.getCoworkerByOfferingId(offeringId)
        : _coworkerRepository.getCoworkers(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(
          // Adicionar uma imagem
          child: Text('Erro ao carregar os dados: ${snapshot.error}'),
        );
      }
      final coworkers = (snapshot.data as List<dynamic>).cast<Coworker>();
      if (coworkers.isEmpty) {
        // Adicionar uma imagem
        return Center(
          child: Text('Nenhum dado disponível: ${snapshot.hasData}'),
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
