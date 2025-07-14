import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawane_ciu/enums/status.dart';
import 'package:pawane_ciu/providers/ciu_screen_notifier.dart';
import 'package:pawane_ciu/state/ciu_screen_state.dart';

class MainPanel extends StatelessWidget {
  final CiuScreenState ciuState;
  final CiuScreenNotifier ciuNotifier;
  final Animation<double> scanAnimation;

  const MainPanel({
    super.key,
    required this.ciuState,
    required this.ciuNotifier,
    required this.scanAnimation,
  });

  Color _getDisplayColor(bool isPowerOn, Status status) {
    if (!isPowerOn) return const Color(0xFF4A5568);

    switch (status) {
      case Status.idle:
        return const Color(0xFF00D4FF);
      case Status.processing:
        return const Color(0xFFFFB800);
      case Status.success:
        return const Color(0xFF00FF88);
      case Status.error:
        return const Color(0xFFFF3B30);
      case Status.offline:
        return const Color(0xFF8E8E93);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0F1419),
            const Color(0xFF1A2329),
            const Color(0xFF0F1419),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              ciuState.isPowerOn
                  ? const Color(0xFF00D4FF).withOpacity(0.3)
                  : const Color(0xFF4A5568),
          width: 2,
        ),
        boxShadow:
            ciuState.isPowerOn
                ? [
                  BoxShadow(
                    color: const Color(0xFF00D4FF).withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
                : [],
      ),
      child: Stack(
        children: [
          if (ciuState.status == Status.processing)
            AnimatedBuilder(
              animation: scanAnimation,
              builder: (context, child) {
                return Positioned(
                  left:
                      -50 +
                      (scanAnimation.value *
                          (MediaQuery.of(context).size.width - 32)),
                  top: 0,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          const Color(0xFF00D4FF).withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ciuState.isTypingToken ? 'TOKEN INPUT' : 'METER READING',
                  style: GoogleFonts.robotoMono(
                    fontSize: 10,
                    color:
                        ciuState.isPowerOn
                            ? const Color(0xFF00D4FF)
                            : const Color(0xFF4A5568),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ciuState.isTypingToken
                      ? (ciuState.token.isEmpty
                          ? (ciuState.isPowerOn ? '--------------------' : 'SYSTEM OFFLINE')
                          : ciuState.token)
                      : ciuNotifier.currentMeter.reading.toStringAsFixed(2), // Display meter reading
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoMono(
                    fontSize: ciuState.token.length > 15 ? 14 : 20,
                    fontWeight: FontWeight.bold,
                    color: _getDisplayColor(ciuState.isPowerOn, ciuState.status),
                    letterSpacing: 1.5,
                  ),
                ),
                if (ciuState.isPowerOn && ciuState.isTypingToken && ciuState.token.isNotEmpty && ciuState.status == Status.idle)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 2,
                    width: 160,
                    child: LinearProgressIndicator(
                      value: ciuState.token.length / 20,
                      backgroundColor: const Color(0xFF2A3A47),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ciuState.token.length == 20
                            ? const Color(0xFF00FF88)
                            : const Color(0xFF00D4FF),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
