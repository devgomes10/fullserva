import 'package:flutter/material.dart';
import 'package:fullserva/controllers/service_controller.dart';
import 'package:fullserva/domain/entities/service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';

class ServiceFormView extends StatefulWidget {
  final Service? model;

  const ServiceFormView({super.key, this.model});

  @override
  State<ServiceFormView> createState() => _ServiceFormViewState();
}

class _ServiceFormViewState extends State<ServiceFormView> {
  String uniqueId = const Uuid().v4();
  final _formKey = GlobalKey<FormState>();
  final ServiceController serviceController = ServiceController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  int? _currentSliderValue = 5;
  final List<int> _durationOptions =
      List.generate(24 * 12, (index) => (index + 1) * 5);

  String formatDuration(int minutes) {
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;

    if (hours > 0 && remainingMinutes > 0) {
      return '$hours h e $remainingMinutes m';
    } else if (hours > 0) {
      return '$hours h';
    } else {
      return '$remainingMinutes m';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.model != null) {
      _nameController.text = widget.model!.name;
      _priceController.text = widget.model!.price.toString();
      _currentSliderValue = widget.model!.duration;
    }
  }

  @override
  Widget build(BuildContext context) {
    final serviceModel = widget.model;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Adicionar Serviço"),
          actions: serviceModel != null ? [
            IconButton(
              onPressed: () async {
                await serviceController.removeService(serviceModel.id);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete),
            ),
          ] : null,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
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
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 150,
                  child: DropdownButtonFormField<int>(
                    hint: const Text("Duração"),
                    value: _currentSliderValue,
                    items: _durationOptions.map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          formatDuration(value),
                        ),
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      if (value != null) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      }
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
                const SizedBox(
                  width: 20,
                ),
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final updatedService = Service(
                        id: serviceModel?.id ?? uniqueId,
                        name: _nameController.text,
                        duration: _currentSliderValue!.toInt(),
                        price: double.parse(_priceController.text),
                      );

                      if (serviceModel != null) {
                        serviceController.updateService(updatedService);
                      } else {
                        serviceController.addService(updatedService);
                      }

                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Adicionar Serviço"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
