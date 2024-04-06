import 'package:flutter/material.dart';
import 'package:fullserva/controllers/offering_controller.dart';
import 'package:fullserva/views/offerings/offering_form_view.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/offering.dart';

class OfferingView extends StatefulWidget {
  const OfferingView({super.key});

  @override
  State<OfferingView> createState() => _OfferingViewState();
}

class _OfferingViewState extends State<OfferingView> {
  final NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  OfferingController serviceController = OfferingController();

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("SERVIÇO"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OfferingFormView(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder<List<Offering>>(
          stream: serviceController.getOfferings(),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OfferingFormView(model: model),
                      ),
                    );
                  },
                  title: Text(
                    services[i].name,
                  ),
                  subtitle: Row(
                    children: [
                      // Aqui vai ficar a duração do serviço
                      Text(
                        _formatDuration(
                          services[i].duration,
                        ),
                      ),
                      Text(
                          // Aqui vai ficar o preço do serviço
                          " | ${real.format(
                        services[i].price,
                      )}")
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
      ),
    );
  }
}
