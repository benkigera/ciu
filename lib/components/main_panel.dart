import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawane_ciu/enums/status.dart';
import 'package:pawane_ciu/providers/ciu_screen_notifier.dart';
import 'package:pawane_ciu/state/ciu_screen_state.dart';
import 'package:pawane_ciu/utils/app_colors.dart';

class MainPanel extends ConsumerStatefulWidget {
  final Animation<double> scanAnimation;

  const MainPanel({
    super.key,
    required this.scanAnimation,
  });

  @override
  ConsumerState<MainPanel> createState() => _MainPanelState();
}

class _MainPanelState extends ConsumerState<MainPanel> {
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
    }
  }

  

  @override
  Widget build(BuildContext context) {
    final ciuState = ref.watch(ciuScreenNotifierProvider);
    final ciuNotifier = ref.read(ciuScreenNotifierProvider.notifier);
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceColor1,
            AppColors.surfaceColor2,
            AppColors.surfaceColor1,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              ciuState.isPowerOn
                  ? AppColors.primaryColor.withOpacity(0.3)
                  : AppColors.textColorDisabled,
          width: 2,
        ),
        boxShadow:
            ciuState.isPowerOn
                ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.1),
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
              animation: widget.scanAnimation,
              builder: (context, child) {
                return Positioned(
                  left:
                      -50 +
                      (widget.scanAnimation.value *
                          (MediaQuery.of(context).size.width - 32)),
                  top: 0,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.primaryColor.withOpacity(0.3),
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
                            ? AppColors.primaryColor
                            : AppColors.textColorDisabled,
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
    );
  }
}
