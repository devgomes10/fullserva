import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fullserva/views/components/menu_navigator.dart';
import 'package:fullserva/views/components/working_day.dart';
import 'package:fullserva/views/components/working_days.dart';
import 'package:provider/provider.dart';
import 'data/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => WorkingDays(
          workingDays: [
            WorkingDay(day: "Segunda-feira", working: false,),
            WorkingDay(day: "Terça-feira", working: false,),
            WorkingDay(day: "Quarta-feira", working: false,),
            WorkingDay(day: "Quinta-feira", working: false,),
            WorkingDay(day: "Sexta-feira", working: false,),
            WorkingDay(day: "Sábado", working: false,),
            WorkingDay(day: "Domingo", working: false,),
          ],
        ),
      ),
    ], child: const Fullserva()),
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
