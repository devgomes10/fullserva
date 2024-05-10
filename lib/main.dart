import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fullserva/booking_page/booking_page.dart';
import 'package:fullserva/utils/themes/theme_light.dart';
import 'package:fullserva/views/authentication/auth_view.dart';
import 'package:fullserva/views/components/menu_navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/opening_hours_controller.dart';
import 'data/firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting('pt_BR', null);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // // Verifica se os dias já foram inicializados
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // bool daysInitialized = prefs.getBool('days_initialized') ?? false;
  // if (!daysInitialized) {
  // //   // Se os dias ainda não foram inicializados, então inicialize-os
  //   await OpeningHoursController().setupInitialOpeningHours();
  // //   // Marca a flag indicando que os dias já foram inicializados
  //   await prefs.setBool('days_initialized', true);
  // }

  runApp(
    const Fullserva(),
  );
}

class Fullserva extends StatelessWidget {
  const Fullserva({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.light,
      theme: themeLight,
      home: BookingPage(),
    );
  }
}

class RouterViews extends StatelessWidget {
  const RouterViews({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            return MenuNavigation(
              user: snapshot.data!,
            );
          } else {
            return const AuthView();
          }
        }
      },
    );
  }
}
