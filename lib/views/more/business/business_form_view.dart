import 'package:flutter/material.dart';
import 'package:fullserva/controllers/business_controller.dart';
import 'package:fullserva/domain/entities/business.dart';
import 'package:uuid/uuid.dart';

class BusinessFormView extends StatefulWidget {
  const BusinessFormView({super.key});

  @override
  State<BusinessFormView> createState() => _BusinessFormViewState();
}

class _BusinessFormViewState extends State<BusinessFormView> {
  String _uniqueId = const Uuid().v4();
  final BusinessController _controller = BusinessController();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PERSONALIZE O SITE"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Image(image: )
              TextFormField(
                keyboardType: TextInputType.name,
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nome da empresa",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o nome da empresa";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "E-mail da empresa",
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Telefone da empresa",
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.streetAddress,
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: "Endereço da empresa",
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Business business = Business(
                      id: _uniqueId,
                      name: _nameController.text,
                    );

                    await _controller.updateBusiness(business);
                  }
                },
                child: Text("SALVAR"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
