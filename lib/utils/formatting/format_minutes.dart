String formatMinutes(int minutes) {
  int hours = minutes ~/ 60;
  int remainingMinutes = minutes % 60;

  String formattedTime = '${_formatTwoDigits(hours)}:${_formatTwoDigits(remainingMinutes)}';

  return formattedTime;
}

String _formatTwoDigits(int number) {
  return number.toString().padLeft(2, '0');
}
