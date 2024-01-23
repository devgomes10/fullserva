import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fullserva/views/components/menu_navigator.dart';
import 'controllers/week_days_controller.dart';
import 'data/firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting('pt_BR', null);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await WeekDaysController().setupInitialWeekDays();
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MenuNavigator(),
    );
  }
}
