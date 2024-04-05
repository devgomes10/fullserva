import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

int _selectedHour = 1;
int _selectedMinute = 5;

Future modalDurationOffering({
  required BuildContext context,
}) {
  return showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 250,
                // Defina a altura desejada aqui
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 30,
                  onSelectedItemChanged: (index) => _selectedHour = index + 1,
                  children: List<Widget>.generate(
                    24,
                        (index) => Center(
                      child: Text('$index horas'),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 250,
                // Defina a altura desejada aqui
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 30,
                  scrollController: FixedExtentScrollController(
                      initialItem: _selectedMinute ~/ 5),
                  onSelectedItemChanged: (index) =>
                  _selectedMinute = (index + 1) * 5,
                  children: List<Widget>.generate(
                    12,
                        (index) => Center(
                      child: Text('${(index + 1) * 5} minutos'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text('CONFIRMAR'),
        onPressed: () {
          TimeOfDay timeOfDay = TimeOfDay(hour: _selectedHour, minute: _selectedMinute);
          Navigator.pop(
            context,
            timeOfDay,
          );
        },
      ),
    ),
  );
}