import 'package:flutter/material.dart';

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
                          const Color(0xFF00FF88).withOpacity(pulseAnimation.value),
                          const Color(
                            0xFF00AA55,
                          ).withOpacity(pulseAnimation.value * 0.3),
                        ],
                      )
                    : const RadialGradient(
                        colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                      ),
            border: Border.all(
              color:
                  isPowerOn ? const Color(0xFF00FF88) : const Color(0xFF4A4A4A),
              width: 2,
            ),
            boxShadow:
                isPowerOn
                    ? [
                        BoxShadow(
                          color: const Color(
                            0xFF00FF88,
                          ).withOpacity(pulseAnimation.value * 0.5),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
          ),
          child: InkWell(
            onTap: togglePower,
            customBorder: const CircleBorder(),
            child: Center(
              child: Icon(
                Icons.power_settings_new,
                color: isPowerOn ? Colors.white : const Color(0xFF666666),
                size: 18,
              ),
            ),
          ),
        );
      },
    );
  }
}
