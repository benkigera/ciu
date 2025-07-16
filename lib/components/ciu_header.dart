import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawane_ciu/components/power_indicator.dart';
import 'package:pawane_ciu/components/status_indicators.dart';
import 'package:pawane_ciu/providers/ciu_screen_notifier.dart';
import 'package:pawane_ciu/state/ciu_screen_state.dart';
import 'package:pawane_ciu/utils/app_colors.dart';
import 'package:pawane_ciu/components/meter_selection_sheet.dart'; // Import for _showMeterSelection

class CiuHeader extends ConsumerWidget {
  final Animation<double> pulseAnimation;
  final Function(CiuScreenState, CiuScreenNotifier) showMeterSelection;

  const CiuHeader({
    super.key,
    required this.pulseAnimation,
    required this.showMeterSelection,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ciuState = ref.watch(ciuScreenNotifierProvider);
    final ciuNotifier = ref.read(ciuScreenNotifierProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F1419), Color(0xFF1A2329)], // Similar to Keypad background
        ),
        borderRadius: BorderRadius.circular(16), // Slightly larger radius
        border: Border.all(color: const Color(0xFF0A0D10), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5), // Dark shadow for bottom-right
            offset: const Offset(4, 4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.05), // Light highlight for top-left
            offset: const Offset(-4, -4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => showMeterSelection(ciuState, ciuNotifier),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.secondaryColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.swap_horiz,
                        color: AppColors.textColorPrimary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'SWITCH',
                        style: GoogleFonts.robotoMono(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColorPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    'CIU v2.1',
                    style: GoogleFonts.orbitron(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          ciuState.isPowerOn
                              ? AppColors.primaryColor
                              : AppColors.textColorDisabled,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    ciuNotifier.currentMeter.serialNumber,
                    style: GoogleFonts.robotoMono(
                      fontSize: 10,
                      color: AppColors.textColorSecondary,
                    ),
                  ),
                ],
              ),
              PowerIndicator(
                pulseAnimation: pulseAnimation,
                isPowerOn: ciuState.isPowerOn,
                togglePower: ciuNotifier.togglePower,
              ),
            ],
          ),
          const SizedBox(height: 16),
          StatusIndicators(
            status: ciuState.status,
            isPowerOn: ciuState.isPowerOn,
            isMqttConnected: ciuState.isMqttConnected,
            subscribedTopics: ciuState.subscribedTopics,
            currentMeterSerialNumber: ciuNotifier.currentMeter.serialNumber,
          ),
        ],
      ),
    );
  }
}
