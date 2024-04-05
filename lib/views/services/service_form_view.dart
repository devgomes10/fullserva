import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:fullserva/controllers/offering_controller.dart';
import 'package:fullserva/domain/entities/offering.dart';
import 'package:fullserva/views/components/modal_duration_offering.dart';
import 'package:uuid/uuid.dart';

class ServiceFormView extends StatefulWidget {
  final Offering? model;

  const ServiceFormView({Key? key, this.model}) : super(key: key);

  @override
  State<ServiceFormView> createState() => _ServiceFormViewState();
}

class _ServiceFormViewState extends State<ServiceFormView> {
  String uniqueId = const Uuid().v4();
  final _formKey = GlobalKey<FormState>();
  final OfferingController serviceController = OfferingController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final List<String> _coworkersIds = [];
  int _selectedHour = 1;
  int _selectedMinute = 5;
  bool _isHourSelected = false;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
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
          title: const Text("NOVO SERVIÇO"),
          actions: serviceModel != null
              ? [
            IconButton(
              onPressed: () async {
                await serviceController.removeOffering(serviceModel.id);
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
                      await modalDurationOffering(
                        context: context,
                      );
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                    ),
                    child: Text("Selecione a duração"),
                  ),
                  const SizedBox(height: 26),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                    ),
                    child: Text(
                        "Selecione a equipe desse serviço: 0"),
                  ),
                  const SizedBox(height: 42),
                  ElevatedButton(
                    onPressed: () {},
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
