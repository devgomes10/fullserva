import 'package:flutter/material.dart';

bool isTimeInInterval(TimeOfDay time, TimeOfDay start, TimeOfDay end) {
  if (time.hour > start.hour && time.hour < end.hour) {
    return true; // O horário está dentro do intervalo
  } else if (time.hour == start.hour && time.minute >= start.minute) {
    return true; // O horário é igual ou depois do horário de início
  } else if (time.hour == end.hour && time.minute < end.minute) {
    return true; // O horário é igual ou antes do horário de término
  }
  return false; // O horário está fora do intervalo ocupado
}