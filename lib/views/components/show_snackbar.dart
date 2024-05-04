import 'package:flutter/material.dart';
import 'package:fullserva/utils/themes/theme_colors.dart';

showSnackbar({
  required BuildContext context,
  required String message,
  bool isError = true,
}) {
  SnackBar snackBar = SnackBar(
    content: Text(message),
    backgroundColor: (isError) ? Colors.red : ThemeColors.primary,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
