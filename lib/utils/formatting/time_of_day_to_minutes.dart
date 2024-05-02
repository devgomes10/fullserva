import 'package:flutter/material.dart';

int timeOfDayToMinutes(TimeOfDay timeOfDay) {
  return timeOfDay.hour * 60 + timeOfDay.minute;
}