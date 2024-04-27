String formatMinutes(int minutes) {
  int hours = minutes ~/ 60;
  int remainingMinutes = minutes % 60;

  if (hours > 0 && remainingMinutes > 0) {
    return '$hours h e $remainingMinutes m';
  } else if (hours > 0) {
    return '$hours h';
  } else {
    return '$remainingMinutes m';
  }
}