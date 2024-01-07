import 'package:flutter/material.dart';
import 'package:fullserva/controllers/service_controller.dart';
import 'package:fullserva/domain/entities/service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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
  final _priceController = TextEditingController();
  final ServiceController serviceController = ServiceController();
  Duration selectedDuration = const Duration(minutes: 5);

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;

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
    List<DropdownMenuItem<Duration>> durationItems = [];

    for (int i = 5; i <= 600; i += 5) {
      durationItems.add(
        DropdownMenuItem<Duration>(
          value: Duration(minutes: i),
          child: Text(_formatDuration(Duration(minutes: i))),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Adicionar Serviço"),
        ),
        body: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Nome do Serviço",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Obrigatório";
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: DropdownButtonFormField<Duration>(
                        hint: const Text("Duração"),
                        value: selectedDuration,
                        items: durationItems,
                        onChanged: (value) {
                          setState(() {
                            selectedDuration = value!;
                          });
                        },
                        decoration: const InputDecoration(labelText: 'Duração'),
                        validator: (value) {
                          if (value == null) {
                            return 'Obrigatório';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 20,),
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          MaskTextInputFormatter(
                            filter: {"#": RegExp(r'[0-9]')},
                          ),
                        ],
                        decoration: const InputDecoration(
                          labelText: "Preço",
                          hintText: "0,00",
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Obrigatório";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final service = Service(
                        id: const Uuid().v4(),
                        name: _nameController.text,
                        duration: selectedDuration.inMinutes,
                        price: double.parse(_priceController.text),
                      );
                      serviceController.addService(service);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Adicionar Serviço"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
