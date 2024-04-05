import 'package:flutter/material.dart';
import 'package:fullserva/controllers/business_controller.dart';
import 'package:fullserva/controllers/offering_controller.dart';
import 'package:fullserva/domain/entities/business.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/offering.dart';

class OfferingPageView extends StatefulWidget {
  const OfferingPageView({Key? key}) : super(key: key);

  @override
  State<OfferingPageView> createState() => _OfferingPageViewState();
}

class _OfferingPageViewState extends State<OfferingPageView> {
  BusinessController _businessController = BusinessController();
  OfferingController _serviceController = OfferingController();
  final NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

  String _formatDuration(int duration) {
    int hours = duration ~/ 60;
    int minutes = duration % 60;

    if (hours > 0 && minutes > 0) {
      return '$hours h $minutes min';
    } else if (hours > 0) {
      return '$hours h';
    } else {
      return '$minutes min';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          child: const Text("Ver agendamentos"),
        ),
        StreamBuilder<List<Business>>(
          stream: _businessController.getBusiness(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text("Erro ao carregar os dados");
            }
            final List<Business>? businesses = snapshot.data;
            if (businesses == null || businesses.isEmpty) {
              return Text("Nenhuma empresa encontrada");
            }
            return Column(
              children: businesses.map((business) {
                return Text(business.name);
              }).toList(),
            );
          },
        ),
        StreamBuilder<List<Offering>>(
          stream: _serviceController.getOfferings(),
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
            final services = snapshot.data;
            if (services == null || services.isEmpty) {
              // Adicionar uma imagem
              return const Center(
                child: Text('Nenhum dado disponível'),
              );
            }
            return ListView.separated(
              itemBuilder: (BuildContext context, int i) {
                Offering model = services[i];
                return ListTile(
                  onTap: () {},
                  title: Text(
                    services[i].name,
                  ),
                  subtitle: Row(
                    children: [
                      // Aqui vai ficar a duração do serviço
                      Text(
                          _formatDuration(services[i].duration)
                      ),
                      Text(
                        // Aqui vai ficar o preço do serviço
                          " | ${real.format(services[i].price)}")
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                );
              },
              separatorBuilder: (_, __) => const Divider(),
              itemCount: services.length,
            );
          },
        ),
      ],
    );
  }
}
