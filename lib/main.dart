import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fullserva/booking_page/booking_page.dart';
import 'package:fullserva/booking_page/customer_appointments.dart';
import 'package:fullserva/utils/themes/theme_light.dart';
import 'package:fullserva/views/authentication/auth_view.dart';
import 'package:fullserva/views/components/menu_navigator.dart';
import 'data/firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const Fullserva());
}

class Fullserva extends StatelessWidget {
  const Fullserva({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.light,
      theme: themeLight,
      routes: {
        '/': (_) => const BookingPage(),
        '/appointments': (_) => const CustomerAppointments(),
      },
    );
  }
}

class RouterViews extends StatelessWidget {
  const RouterViews({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final user = snapshot.data!;
          return MenuNavigation(user: user);
        } else {
          return const AuthView();
        }
      },
    );
  }
}
