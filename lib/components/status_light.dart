import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusLight extends StatelessWidget {
  final String label;
  final Color color;
  final bool isActive;

  const StatusLight({
    required this.label,
    required this.color,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient:
                isActive
                    ? RadialGradient(colors: [color, color.withOpacity(0.3)])
                    : const RadialGradient(
                      colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                    ),
            border: Border.all(
              color: isActive ? color : const Color(0xFF4A4A4A),
              width: 1,
            ),
            boxShadow:
                isActive
                    ? [
                      BoxShadow(
                        color: color.withOpacity(0.6),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ]
                    : [],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.robotoMono(
            fontSize: 7,
            color: isActive ? color : const Color(0xFF666666),
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}