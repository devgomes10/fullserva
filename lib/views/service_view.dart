import 'package:flutter/material.dart';
import 'package:fullserva/controllers/service_controller.dart';
import 'package:fullserva/views/service_form_view.dart';
import 'package:intl/intl.dart';
import '../domain/entities/service.dart';

class ServiceView extends StatefulWidget {
  const ServiceView({super.key});

  @override
  State<ServiceView> createState() => _ServiceViewState();
}

class _ServiceViewState extends State<ServiceView> {
  final NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  final ServiceController _serviceController = ServiceController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Serviços"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Service>>(
        stream: _serviceController.getService(),
        builder: (BuildContext context, AsyncSnapshot<List<Service>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              // Adicionar uma imagem
              child: Text('Erro ao carregar os dados'),
            );
          }
          final services = snapshot.data;
          if (services == null || services.isEmpty) {
            // Adicionar uma imagem
            return const Center(
              child: Text('Nenhum dado disponível'),
            );
          }
          return SafeArea(
            child: ListView.separated(
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                  onTap: () {},
                  title: Text(
                    services[i].name,
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        // Aqui vai ficar a duração do serviço
                        services[i].estimatedDuration,
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
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceFormView(),),);
      },
      child: const Icon(Icons.add),),
    );
  }
}