import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future modalAvailableTimes ({
  required BuildContext context,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Selecione a duração',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: _durationOptions.length,
            //     itemBuilder: (context, index) {
            //       final duration = _durationOptions[index];
            //       return ListTile(
            //         title: Center(
            //           child: Text(
            //             formatDuration(duration),
            //           ),
            //         ),
            //         onTap: () {
            //           setState(() {
            //             _duration = duration;
            //           });
            //           Navigator.pop(context);
            //         },
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      );
    },
  );
}