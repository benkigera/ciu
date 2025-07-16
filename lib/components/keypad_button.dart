import 'package:flutter/material.dart';

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
          setState(() => _isPressed = false);
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
        },
        onTap: widget.isEnabled ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF1A2329), // Solid background color
            border:
                widget.isEnabled && !_isPressed
                    ? Border.all(color: const Color(0xFF0A0D10), width: 1)
                    : null,
            boxShadow:
                widget.isEnabled
                    ? _isPressed
                        ? [
                          // Pressed (sinking) effect when enabled
                          BoxShadow(
                            color: Colors.black.withOpacity(0.7),
                            offset: const Offset(2, 2), // Inward dark shadow
                            blurRadius: 4,
                            spreadRadius: 0.5,
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.02),
                            offset: const Offset(-2, -2), // Inward light shadow
                            blurRadius: 4,
                            spreadRadius: 0.5,
                          ),
                        ]
                        : [
                          // Sunken effect when not pressed and enabled
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(-4, -4), // Inward dark shadow
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.05),
                            offset: const Offset(4, 4), // Inward light shadow
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                    : [
                      // Disabled state shadow
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                        spreadRadius: 0.5,
                      ),
                    ],
          ),
          child: Center(child: widget.content),
        ),
      ),
    );
  }
}
