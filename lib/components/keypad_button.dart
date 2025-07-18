import 'package:flutter/material.dart';
import 'package:meter_link/utils/app_colors.dart';

class KeypadButton extends StatefulWidget {
  final Widget content;
  final VoidCallback onTap;
  final bool isEnabled;

  const KeypadButton({
    super.key,
    required this.content,
    required this.onTap,
    required this.isEnabled,
  });

  @override
  State<KeypadButton> createState() => _KeypadButtonState();
}

class _KeypadButtonState extends State<KeypadButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: GestureDetector(
        onTapDown: (_) {
          if (widget.isEnabled) {
            setState(() => _isPressed = true);
          }
        },
        onTapUp: (_) {
          Future.delayed(const Duration(milliseconds: 100), () {
            setState(() => _isPressed = false);
          });
        },
        onTapCancel: () {
          Future.delayed(const Duration(milliseconds: 100), () {
            setState(() => _isPressed = false);
          });
        },
        onTap: widget.isEnabled ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _isPressed
                    ? const Color(0xFF1A2329)
                    : Color.lerp(const Color(0xFF1A2329), Colors.black, 0.1)!,
                _isPressed
                    ? Color.lerp(const Color(0xFF1A2329), Colors.black, 0.05)!
                    : const Color(0xFF1A2329),
                _isPressed
                    ? Color.lerp(const Color(0xFF1A2329), Colors.black, 0.05)!
                    : const Color(0xFF1A2329),
                Color.lerp(
                  const Color(0xFF1A2329),
                  Colors.white,
                  _isPressed ? 0.1 : 0.2,
                )!,
              ],
              stops: const [0.0, 0.3, 0.6, 1.0],
            ),
            boxShadow:
                _isPressed
                    ? null
                    : [
                      BoxShadow(
                        blurRadius: 4,
                        offset: const Offset(-4, -4),
                        color:
                            Color.lerp(
                              const Color(0xFF1A2329),
                              AppColors.primaryColor,
                              0.2,
                            )!,
                      ),
                      BoxShadow(
                        blurRadius: 12,
                        offset: const Offset(6, 6),
                        color:
                            Color.lerp(
                              const Color(0xFF1A2329),
                              Colors.black,
                              0.3,
                            )!,
                      ),
                    ],
          ),
          child: Center(child: widget.content),
        ),
      ),
    );
  }
}

extension ColorUtils on Color {
  Color mix(Color another, double amount) {
    return Color.lerp(this, another, amount)!;
  }
}
