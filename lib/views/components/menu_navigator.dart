import 'package:flutter/material.dart';
import 'package:fullserva/views/dashboard_view.dart';
import 'package:fullserva/views/employee_view.dart';
import 'package:fullserva/views/service_view.dart';
import 'package:fullserva/views/settings_view.dart';

class MenuNavigator extends StatefulWidget {
  const MenuNavigator({super.key});

  @override
  State<MenuNavigator> createState() => _MenuNavigatorState();
}

class _MenuNavigatorState extends State<MenuNavigator> {
  int currentPageIndex = 0; // Inicialize com um índice válido


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_repair_service),
            label: "Serviços",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: "Funcionários",
          ),
          NavigationDestination(
            icon: Icon(Icons.bubble_chart_outlined),
            label: "Painel",
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: "Configurações",
          ),
        ],
        animationDuration: const Duration(milliseconds: 1000),
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int i) {
          setState(() {
            currentPageIndex = i;
          });
        },
      ),
      body: [
        ServiceView(),
        EmployeeView(),
        DashboardView(),
        SettingsView(),
      ] [currentPageIndex],
    );
  }
}
