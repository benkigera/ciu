import 'package:flutter/material.dart';
import 'package:pawane_ciu/components/keypad_button.dart';

class Keypad extends StatelessWidget {
  final Function(String) onKeyPress;
  final bool isPowerOn;

  const Keypad({super.key, required this.onKeyPress, required this.isPowerOn});

  @override
  Widget build(BuildContext context) {
    final keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'BACK',
      '0',
      'ENTER',
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F1419), Color(0xFF1A2329)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0A0D10), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(-4, -4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.05),
            offset: const Offset(4, 4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemHeight =
              (constraints.maxHeight - (8 * 3)) /
              4; // Calculate item height based on available height and spacing
          final itemWidth =
              (constraints.maxWidth - (8 * 2)) /
              3; // Calculate item width based on available width and spacing
          final aspectRatio = itemWidth / itemHeight;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: aspectRatio,
            ),
            itemCount: keys.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final key = keys[index];
              return KeypadButton(
                label: key,
                onTap: () => onKeyPress(key),
                isEnabled: isPowerOn,
              );
            },
          );
        },
      ),
    );
  }
}
