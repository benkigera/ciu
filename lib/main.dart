import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawane_ciu/components/keypad.dart';
import 'package:pawane_ciu/components/meter_selection_sheet.dart';
import 'package:pawane_ciu/components/power_indicator.dart';
import 'package:pawane_ciu/components/status_indicators.dart';
import 'package:pawane_ciu/components/main_panel.dart';
import 'package:pawane_ciu/providers/ciu_screen_notifier.dart';
import 'package:pawane_ciu/state/ciu_screen_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pawane_ciu/db/meter_db_service.dart';
import 'package:pawane_ciu/utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await MeterDbService().init();
  runApp(const ProviderScope(child: PawaneCiuApp()));
}

class PawaneCiuApp extends StatelessWidget {
  const PawaneCiuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pawane CIU',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        textTheme: GoogleFonts.robotoMonoTextTheme(ThemeData.dark().textTheme),
      ),
      home: const CiuScreen(),
    );
  }
}

class CiuScreen extends ConsumerStatefulWidget {
  const CiuScreen({super.key});

  @override
  ConsumerState<CiuScreen> createState() => _CiuScreenState();
}

class _CiuScreenState extends ConsumerState<CiuScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scanController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scanController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );

    ref.listenManual(ciuScreenNotifierProvider, (previous, next) {
      if (next.showMeterSelectionSheet) {
        _showMeterSelection(next, ref.read(ciuScreenNotifierProvider.notifier));
        ref
            .read(ciuScreenNotifierProvider.notifier)
            .dismissMeterSelectionSheet();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ciuState = ref.watch(ciuScreenNotifierProvider);
    final ciuNotifier = ref.read(ciuScreenNotifierProvider.notifier);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundColor,
              AppColors.surfaceColor2,
              AppColors.backgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildHeader(ciuState, ciuNotifier, _pulseAnimation),
                const SizedBox(height: 24),
                MainPanel(scanAnimation: _scanAnimation),
                const SizedBox(height: 24),
                Expanded(
                  child: Keypad(
                    onKeyPress: (value) {
                      ciuNotifier.handleKeyPress(value);
                      if (value == 'ENTER') {
                        _scanController.forward().then(
                          (_) => _scanController.reset(),
                        );
                      }
                    },
                    isPowerOn: ciuState.isPowerOn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    CiuScreenState ciuState,
    CiuScreenNotifier ciuNotifier,
    Animation<double> pulseAnimation,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.surfaceColor3.withOpacity(0.3),
            AppColors.surfaceColor4.withOpacity(0.5),
            AppColors.surfaceColor3.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor2, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _showMeterSelection(ciuState, ciuNotifier),
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
            subscribedTopic: ciuState.subscribedTopic,
            currentMeterSerialNumber: ciuNotifier.currentMeter.serialNumber,
          ),
        ],
      ),
    );
  }

  void _showMeterSelection(
    CiuScreenState ciuState,
    CiuScreenNotifier ciuNotifier,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => MeterSelectionSheet(
            selectedMeterIndex: ciuState.selectedMeterIndex,
            onMeterSelected: (index) {
              ciuNotifier.selectMeter(index);
            },
          ),
    );
  }
}
