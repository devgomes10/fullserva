import 'package:flutter/material.dart';

import '../../../utils/formatting/format_minutes.dart';

class DurationSelectionModal extends StatelessWidget {
  final List<int> durationOptions;
  final Function(int) onDurationSelected;

  const DurationSelectionModal({
    Key? key,
    required this.durationOptions,
    required this.onDurationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: ListView.builder(
              itemCount: durationOptions.length,
              itemBuilder: (context, index) {
                final duration = durationOptions[index];
                return ListTile(
                  title: Center(
                    child: Text(
                      formatMinutes(duration),
                    ),
                  ),
                  onTap: () {
                    onDurationSelected(duration);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}