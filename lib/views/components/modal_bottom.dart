import 'package:flutter/material.dart';
import 'package:fullserva/controllers/service_controller.dart';
import '../../domain/entities/service.dart';

ServiceController _serviceController = ServiceController();
Widget modalBottomSheet({
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
      final streamDatas = snapshot.data;
      if (streamDatas == null || streamDatas.isEmpty) {
        return Center(
          child: Text("Está vázio"),
        );
      }
      return ListView.separated(
        itemBuilder: (BuildContext context, int i) {
          return ListTile(
            title: Text(streamDatas[i].name),
            subtitle: Text(streamDatas[i].duration.toString()),
          );
        },
        separatorBuilder: (_, __) => const Divider(),
        itemCount: streamDatas.length,
      );
    },
  );
}
