import 'package:flutter/material.dart';
import 'package:fullserva/views/components/working_day.dart';

class WorkingDays extends ChangeNotifier {
  List<WorkingDay> workingDays = [];

  WorkingDays({
    required this.workingDays,
});

  void updateWorkingDay(int index, WorkingDay updatedDay) {
    workingDays[index] = updatedDay;
    notifyListeners();
  }
}