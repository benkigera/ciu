import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawane_ciu/components/keypad.dart';
import 'package:pawane_ciu/components/meter_selection_sheet.dart';
import 'package:pawane_ciu/components/power_indicator.dart';
import 'package:pawane_ciu/components/status_indicators.dart';
import 'package:pawane_ciu/components/main_panel.dart';
import 'package:pawane_ciu/components/ciu_header.dart'; // New import
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
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _pulseController;
  late AnimationController _scanController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
    WidgetsBinding.instance.removeObserver(this);
    _pulseController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final ciuNotifier = ref.read(ciuScreenNotifierProvider.notifier);
    final ciuState = ref.read(ciuScreenNotifierProvider);
    if (state == AppLifecycleState.paused && ciuState.isPowerOn) {
      ciuNotifier.togglePower();
    }
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
                CiuHeader(
                  pulseAnimation: _pulseAnimation,
                  showMeterSelection: _showMeterSelection,
                ),
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
                    currentToken: ciuState.token,
                  ),
                ),
              ],
            ),
          ),
        ),
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