import 'package:flutter/material.dart';
import 'package:fullserva/views/appointments/appointment_view.dart';
import 'package:fullserva/views/dash/dashboard_view.dart';
import 'package:fullserva/views/employees/employees_view.dart';
import 'package:fullserva/views/more/more/more_view.dart';
import 'package:fullserva/views/services/service_view.dart';

class MenuNavigator extends StatefulWidget {
  const MenuNavigator({super.key});

  @override
  State<MenuNavigator> createState() => _MenuNavigatorState();
}

class _MenuNavigatorState extends State<MenuNavigator> {
  int currentPageIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
              label: "Agenda",
          ),
          NavigationDestination(
            icon: Icon(Icons.build_outlined),
            label: "Serviços",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            label: "Equipe",
          ),
          NavigationDestination(
            icon: Icon(Icons.bubble_chart_outlined),
            label: "Painel",
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz_outlined),
            label: "Mais",
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
        AppointmentView(),
        ServiceView(),
        EmployeesView(),
        DashboardView(),
        MoreView(),
      ] [currentPageIndex],
    );
  }
}
