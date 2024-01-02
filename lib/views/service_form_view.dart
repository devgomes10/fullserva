import 'package:flutter/material.dart';
import 'package:fullserva/controllers/service_controller.dart';
import 'package:fullserva/domain/entities/service.dart';
import 'package:uuid/uuid.dart';

class ServiceFormView extends StatefulWidget {

  const ServiceFormView({
    super.key,
  });

  @override
  State<ServiceFormView> createState() => _ServiceFormViewState();
}

class _ServiceFormViewState extends State<ServiceFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _estimatedDurationController = TextEditingController();
  final _priceController = TextEditingController();
  final ServiceController controller = ServiceController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar Serviço"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nome do Serviço",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nome do serviço é obrigatório";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _estimatedDurationController,
                decoration: const InputDecoration(
                  labelText: "Duração Estimada",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Duração estimada é obrigatória";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Preço",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Preço é obrigatório";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final service = Service(
                      id: const Uuid().v4(),
                      name: _nameController.text,
                      estimatedDuration: _estimatedDurationController.text,
                      price: double.parse(_priceController.text),
                    );
                    controller.addService(service);
                    Navigator.pop(context);
                  }
                },
                child: const Text("Adicionar Serviço"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
