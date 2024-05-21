import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fullserva/utils/themes/theme_light.dart';
import 'package:fullserva/views/authentication/auth_view.dart';
import 'package:fullserva/views/booking_page/appointments_page_view.dart';
import 'package:fullserva/views/components/menu_navigator.dart';
import 'data/firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting('pt_BR', null);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      home: AppointmentsPageView() //const RouterViews(),
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
