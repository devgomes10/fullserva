import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:fullserva/controllers/service_controller.dart';
import 'package:fullserva/domain/entities/service.dart';
import 'package:fullserva/views/components/picker_duration_offering.dart';
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
  final List<String> _coworkersIds = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.model != null) {
      _nameController.text = widget.model!.name;
      _priceController.text = widget.model!.price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final serviceModel = widget.model;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Adicionar Serviço"),
          actions: serviceModel != null
              ? [
                  IconButton(
                    onPressed: () async {
                      await serviceController.removeService(serviceModel.id);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ]
              : null,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 26),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        labelText: "Descrição",
                        hintText: "Qual serviço você oferece?"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor, digite o nome do serviço";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 26),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      CurrencyTextInputFormatter(
                          locale: 'pt_BR', decimalDigits: 0, symbol: 'R\$')
                    ],
                    decoration: const InputDecoration(
                      labelText: "Preço",
                      hintText: "R\$ 0,00",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor, digite o preço do serviço";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 26),
                  ElevatedButton(
                    onPressed: () async {
                      await pickerDurationOffering(context: context);
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                    ),
                    child: const Text('Selecione a duração'),
                  ),
                  const SizedBox(height: 26),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                    ),
                    child: Text("Selecione a equipe desse serviço: 0"),
                  ),
                  const SizedBox(height: 42),
                  ElevatedButton(
                    onPressed: () {
                      // if (_formKey.currentState!.validate()) {
                      //   final updatedService = Service(
                      //     id: serviceModel?.id ?? uniqueId,
                      //     name: _nameController.text,
                      //     duration: _currentSliderValue!.toInt(),
                      //     price: double.parse(_priceController.text),
                      //     employeeIds: _employeeIds,
                      //   );
                      //
                      //   if (serviceModel != null) {
                      //     serviceController.updateService(updatedService);
                      //   } else {
                      //     serviceController.addService(updatedService);
                      //   }
                      //
                      //   Navigator.pop(context);
                      // }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                    ),
                    child: (serviceModel != null)
                        ? const Text("ATUALIZAR")
                        : const Text("ADICIONAR"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
