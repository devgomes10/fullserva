import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fullserva/views/appointments/appointment_view.dart';
import 'package:fullserva/views/coworkers/coworker_view.dart';
import 'package:fullserva/views/dash/dashboard_view.dart';
import 'package:fullserva/views/more/more_view.dart';
import 'package:fullserva/views/offerings/offering_view.dart';

class MenuNavigation extends StatefulWidget {
  final User user;

  const MenuNavigation({super.key, required this.user});

  @override
  State<MenuNavigation> createState() => _MenuNavigationState();
}

class _MenuNavigationState extends State<MenuNavigation> {
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
        OfferingView(),
        CoworkerView(),
        DashboardView(),
        MoreView(user: widget.user,),
      ] [currentPageIndex],
    );
  }
}
