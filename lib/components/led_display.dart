import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meter_link/enums/status.dart';
import 'package:meter_link/providers/ciu_screen_notifier.dart';
import 'package:meter_link/utils/app_colors.dart';

class LedDisplay extends ConsumerStatefulWidget {
  final Animation<double> scanAnimation;

  const LedDisplay({super.key, required this.scanAnimation});

  @override
  ConsumerState<LedDisplay> createState() => _LedDisplayState();
}

class _LedDisplayState extends ConsumerState<LedDisplay> {
  Color _getDisplayColor(bool isPowerOn, Status status) {
    if (!isPowerOn) return AppColors.textColorDisabled;

    switch (status) {
      case Status.idle:
        return AppColors.primaryColor;
      case Status.processing:
        return AppColors.warningColor;
      case Status.success:
        return AppColors.successColor;
      case Status.error:
        return AppColors.errorColor;
      case Status.offline:
        return AppColors.textColorSecondary;
      case Status.connected:
        return AppColors.successColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ciuState = ref.watch(ciuScreenNotifierProvider);
    final ciuNotifier = ref.read(ciuScreenNotifierProvider.notifier);

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFF1A2329),
          ),
        ),
        if (!ciuState.isPowerOn)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [Colors.black.withOpacity(0.15), Colors.transparent],
                ),
              ),
            ),
          ),
        Positioned.fill(
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: widget.scanAnimation,
                builder: (context, child) {
                  if (ciuState.status != Status.processing) {
                    return const SizedBox.shrink();
                  }
                  return Positioned(
                    left:
                        -50 +
                        (widget.scanAnimation.value *
                            (MediaQuery.of(context).size.width - 32)),
                    top: 0,
                    child: SizedBox(width: 100, height: 100),
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
                                ? AppColors.primaryColor
                                : AppColors.textColorDisabled,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ciuState.isTypingToken
                          ? (ciuState.status == Status.error
                              ? ciuState.token
                              : ciuState.status == Status.success
                              ? 'INJECTION SUCCESS'
                              : (ciuState.token.isEmpty
                                  ? (ciuState.isPowerOn
                                      ? '--------------------'
                                      : 'SYSTEM OFFLINE')
                                  : ciuState.token))
                          : (ciuState.status == Status.error
                              ? ciuState.token
                              : ciuNotifier.currentMeter.availableCredit
                                  .toStringAsFixed(2)),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoMono(
                        fontSize: ciuState.token.length > 15 ? 14 : 20,
                        fontWeight: FontWeight.bold,
                        color: _getDisplayColor(
                          ciuState.isPowerOn,
                          ciuState.status,
                        ),
                        letterSpacing: 1.5,
                      ),
                    ),
                    if (ciuState.isPowerOn &&
                        ciuState.isTypingToken &&
                        ciuState.token.isNotEmpty &&
                        ciuState.status == Status.idle)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        height: 2,
                        width: 160,
                        child: LinearProgressIndicator(
                          value: ciuState.token.length / 20,
                          backgroundColor: AppColors.surfaceColor3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            ciuState.token.length == 20
                                ? AppColors.successColor
                                : AppColors.primaryColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
