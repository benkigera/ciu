import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawane_ciu/components/keypad.dart';
import 'package:pawane_ciu/components/meter_selection_sheet.dart';
import 'package:pawane_ciu/components/power_indicator.dart';
import 'package:pawane_ciu/components/status_indicators.dart';
import 'package:pawane_ciu/components/main_panel.dart';
import 'package:pawane_ciu/enums/status.dart';
import 'package:pawane_ciu/providers/ciu_screen_notifier.dart';
import 'package:pawane_ciu/state/ciu_screen_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pawane_ciu/db/meter_db_service.dart';

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
        scaffoldBackgroundColor: const Color(0xFF0B0E10),
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
            colors: [Color(0xFF0B0E10), Color(0xFF1A1F25), Color(0xFF0B0E10)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildHeader(ciuState, ciuNotifier, _pulseAnimation),
                const SizedBox(height: 24),
                MainPanel(
                  ciuState: ciuState,
                  ciuNotifier: ciuNotifier,
                  scanAnimation: _scanAnimation,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Keypad(
                    onKeyPress: (value) {
                      ciuNotifier.handleKeyPress(value);
                      if (value == 'ENTER') {
                        _scanController.forward().then((_) => _scanController.reset());
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
            const Color(0xFF2A3A47).withOpacity(0.3),
            const Color(0xFF1E2832).withOpacity(0.5),
            const Color(0xFF2A3A47).withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF3A4A57), width: 1),
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
                      colors: [Color(0xFF00D4FF), Color(0xFF00A8FF)],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.swap_horiz,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'SWITCH',
                        style: GoogleFonts.robotoMono(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                              ? const Color(0xFF00D4FF)
                              : const Color(0xFF4A5568),
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    ciuNotifier.currentMeter.serialNumber,
                    style: GoogleFonts.robotoMono(
                      fontSize: 10,
                      color: const Color(0xFF8E8E93),
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
            meters: ciuState.meters,
            selectedMeterIndex: ciuState.selectedMeterIndex,
            onMeterSelected: (index) {
              ciuNotifier.selectMeter(index);
            },
            ciuNotifier: ciuNotifier,
          ),
    );
  }
}
