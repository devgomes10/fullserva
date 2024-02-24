import 'package:flutter/material.dart';
import 'package:fullserva/views/auth/register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("Login"),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    label: Text("E-mail"),
                  ),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    label: Text("Senha"),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text("Entrar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterView(),
                ),
              );
            },
            child: Text("Cadastrar"),
          ),
        ],
      ),
    );
  }
}
