import 'package:flutter/material.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:fullserva/controllers/coworker_controller.dart';
import 'package:fullserva/controllers/offering_controller.dart';
import 'package:fullserva/domain/entities/coworker.dart';
import 'package:fullserva/domain/entities/offering.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:fullserva/views/components/modal_duration_offering.dart';

class OfferingFormView extends StatefulWidget {
  // if it is different from null, it is editing
  final Offering? model;

  const OfferingFormView({Key? key, this.model}) : super(key: key);

  @override
  State<OfferingFormView> createState() => _OfferingFormViewState();
}

class _OfferingFormViewState extends State<OfferingFormView> {
  final _formKey = GlobalKey<FormState>();
  final CoworkerController _coworkerController = CoworkerController();
  final OfferingController _offeringController = OfferingController();

  // model attributes
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final List<String> _coworkersIds = [];
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
    super.initState();
    if (widget.model != null) {
      _nameController.text = widget.model!.name;
      _priceController.text = widget.model!.price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final offeringModel = widget.model;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("NOVO SERVIÇO"),
          actions: offeringModel != null
              ? [
                  IconButton(
                    onPressed: () async {
                      await _offeringController
                          .removeOffering(offeringModel.id);
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
                      hintText: "Qual serviço você oferece?",
                    ),
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
                      // package for to customize currency (Real)
                      CurrencyTextInputFormatter(
                        locale: 'pt_BR',
                        decimalDigits: 0,
                        symbol: 'R\$',
                      ),
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
                    onPressed: () {
                      _showDurationModal(context);
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                    ),
                    child: Text(
                      _currentSliderValue != null
                          ? formatDuration(_currentSliderValue!)
                          : "Selecione a duração",
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Text("Quais colaboradores trabalham com esse serviço?"),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(border: Border.all(width: 5)),
                    child: StreamBuilder<List<Coworker>>(
                      stream: _coworkerController.getCoworker(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(
                            // Adicionar uma imagem
                            child: Text('Erro ao carregar os dados'),
                          );
                        }
                        final coworkers = snapshot.data;
                        if (coworkers == null || coworkers.isEmpty) {
                          // Adicionar uma imagem
                          return const Center(
                            child: Text('Nenhum dado disponível'),
                          );
                        }
                        return ListView.builder(
                          itemCount: coworkers.length,
                          itemBuilder: (context, index) {
                            final coworker = coworkers[index];

                            // checking stored ids
                            final isSelected =
                                _coworkersIds.contains(coworker.id);
                            final isSelectedNotifier =
                                ValueNotifier<bool>(isSelected);
                            return ValueListenableBuilder<bool>(
                              valueListenable: isSelectedNotifier,
                              builder: (context, value, child) {
                                return CheckboxListTile(
                                  title: Text(coworker.name),
                                  value: value,
                                  onChanged: (bool? newValue) {
                                    isSelectedNotifier.value = newValue!;
                                    if (newValue) {
                                      _coworkersIds.add(coworker.id);
                                    } else {
                                      _coworkersIds.remove(coworker.id);
                                    }
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 42),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                    ),
                    child: (offeringModel != null)
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

  void _showDurationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Selecione a duração',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _durationOptions.length,
                  itemBuilder: (context, index) {
                    final duration = _durationOptions[index];
                    return ListTile(
                      title: Center(
                        child: Text(
                          formatDuration(duration),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _currentSliderValue = duration;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
