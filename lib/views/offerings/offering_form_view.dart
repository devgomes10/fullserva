import 'package:flutter/material.dart';
import 'package:fullserva/controllers/offering_controller.dart';
import 'package:fullserva/domain/entities/offering.dart';
import 'package:uuid/uuid.dart';

class OfferingFormView extends StatefulWidget {
  final Offering? model;

  const OfferingFormView({Key? key, this.model}) : super(key: key);

  @override
  State<OfferingFormView> createState() => _OfferingFormViewState();
}

class _OfferingFormViewState extends State<OfferingFormView> {
  final _formKey = GlobalKey<FormState>();
  int? _duration;
  final String _uniqueId = const Uuid().v4();

  final OfferingController _offeringController = OfferingController();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  // list of ints with 288 total elements that are multiples of 5,
  // starting from 5 and going up to 1440
  final List<int> _durationOptions =
      List.generate(24 * 12, (index) => (index + 1) * 5);

  // takes an int value and return a formatted string
  // representing that value in hours and minutes.
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
    // showing object parameters when editing
    if (widget.model != null) {
      _nameController.text = widget.model!.name;
      _priceController.text = widget.model!.price.toString();
      _duration = widget.model!.duration;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final offeringModel = widget.model;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(offeringModel != null ? "Editando serviço" : "Novo serviço"),
          actions: offeringModel != null
              ? [
                  // excluding offering when editing
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
                      _duration != null
                          ? formatDuration(_duration!)
                          : "Duração",
                    ),
                  ),
                  const SizedBox(height: 42),
                  ElevatedButton(
                    onPressed: () async {
                      if (_duration == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Por favor, selecione a duração do serviço",
                            ),
                          ),
                        );
                      } else {
                        if (_formKey.currentState!.validate()) {

                          Offering offering = Offering(
                            id: offeringModel?.id ?? _uniqueId,
                            name: _nameController.text,
                            duration: _duration!.toInt(),
                            price: double.parse(_priceController.text),
                          );

                          if (offeringModel != null) {
                            await _offeringController.updateOffering(offering);
                          } else {
                            await _offeringController.addOffering(offering);
                          }

                          Navigator.pop(context);
                        }
                      }
                    },
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

  void _showDurationModal(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Selecione a duração',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
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
                          _duration = duration;
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
