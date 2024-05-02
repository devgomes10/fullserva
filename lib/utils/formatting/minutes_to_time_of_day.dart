import 'package:flutter/material.dart';

TimeOfDay minutesToTimeOfDay(int minutes) {
  int hours = minutes ~/ 60;
  int remainingMinutes = minutes % 60;

  return TimeOfDay(hour: hours, minute: remainingMinutes);
}