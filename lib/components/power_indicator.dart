import 'package:flutter/material.dart';
import 'package:meter_link/utils/app_colors.dart';

class PowerIndicator extends StatelessWidget {
  final Animation<double> pulseAnimation;
  final bool isPowerOn;
  final VoidCallback togglePower;

  const PowerIndicator({
    super.key,
    required this.pulseAnimation,
    required this.isPowerOn,
    required this.togglePower,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient:
                isPowerOn
                    ? RadialGradient(
                      colors: [
                        AppColors.successColor.withOpacity(
                          pulseAnimation.value,
                        ),
                        AppColors.successColorDark.withOpacity(
                          pulseAnimation.value * 0.3,
                        ),
                      ],
                    )
                    : const RadialGradient(
                      colors: [
                        AppColors.powerOffGradientStart,
                        AppColors.powerOffGradientEnd,
                      ],
                    ),
            border: Border.all(
              color:
                  isPowerOn
                      ? AppColors.successColor
                      : AppColors.textColorDisabled,
              width: 2,
            ),
            boxShadow: [
              // Sunken effect shadows (always present)
              BoxShadow(
                color: Colors.black.withOpacity(
                  0.2,
                ), // Dark shadow for top-left (inner illusion)
                offset: const Offset(-4, -4),
                blurRadius: 8,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(
                  0.05,
                ), // Light highlight for bottom-right (inner illusion)
                offset: const Offset(4, 4),
                blurRadius: 8,
                spreadRadius: 0,
              ),
              // Pulsing glow shadow (only when power is on)
              if (isPowerOn)
                BoxShadow(
                  color: AppColors.successColor.withOpacity(
                    pulseAnimation.value * 0.5,
                  ),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
            ],
          ),
          child: InkWell(
            onTap: togglePower,
            customBorder: const CircleBorder(),
            child: Center(
              child: Icon(
                Icons.power_settings_new,
                color:
                    isPowerOn
                        ? AppColors.textColorPrimary
                        : AppColors.textColorTertiary,
                size: 18,
              ),
            ),
          ),
        );
      },
    );
  }
}
