import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meter_link/providers/ciu_screen_notifier.dart';
import 'package:meter_link/utils/app_colors.dart';

class KeypadButton extends ConsumerStatefulWidget {
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
  ConsumerState<KeypadButton> createState() => _KeypadButtonState();
}

class _KeypadButtonState extends ConsumerState<KeypadButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final ciuState = ref.watch(ciuScreenNotifierProvider);
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
        onTap: (widget.isEnabled && ciuState.isPowerOn) ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _isPressed || !ciuState.isPowerOn
                    ? const Color(0xFF1A2329)
                    : Color.lerp(const Color(0xFF1A2329), Colors.black, 0.1)!,
                _isPressed || !ciuState.isPowerOn
                    ? Color.lerp(const Color(0xFF1A2329), Colors.black, 0.05)!
                    : const Color(0xFF1A2329),
                _isPressed || !ciuState.isPowerOn
                    ? Color.lerp(const Color(0xFF1A2329), Colors.black, 0.05)!
                    : const Color(0xFF1A2329),
                Color.lerp(
                  const Color(0xFF1A2329),
                  Colors.white,
                  (_isPressed || !ciuState.isPowerOn) ? 0.1 : 0.2,
                )!,
              ],
              stops: const [0.0, 0.3, 0.6, 1.0],
            ),
            boxShadow:
                _isPressed || !ciuState.isPowerOn
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
