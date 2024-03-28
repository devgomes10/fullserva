import 'package:flutter/material.dart';
import 'package:fullserva/controllers/service_controller.dart';
import '../../domain/entities/service.dart';

ServiceController _serviceController = ServiceController();

Widget modalOfferings({
  required BuildContext context,
}) {
  return StreamBuilder<List<Service>>(
    stream: _serviceController.getService(),
    builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(
          // Adicionar uma imagem
          child: Text('Erro ao carregar os dados: ${snapshot.error}'),
        );
      }
      final services = snapshot.data;
      if (services == null || services.isEmpty) {
        return Center(
          child: Text("Está vázio"),
        );
      }
      return ListView.separated(
        itemBuilder: (BuildContext context, int i) {
          return ListTile(
            onTap: () {
              Navigator.pop(context, services[i]);
            },
            title: Text(services[i].name),
            subtitle: Text(services[i].duration.toString()),
          );
        },
        separatorBuilder: (_, __) => const Divider(),
        itemCount: services.length,
      );
    },
  );
}
