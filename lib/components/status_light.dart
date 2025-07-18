import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meter_link/utils/app_colors.dart';

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
                      colors: [
                        AppColors.powerOffGradientStart,
                        AppColors.powerOffGradientEnd,
                      ],
                    ),
            border: Border.all(
              color: isActive ? color : AppColors.textColorDisabled,
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
            color: isActive ? color : AppColors.textColorTertiary,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
