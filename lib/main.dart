import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawane_ciu/components/ciu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pawane_ciu/db/meter_db_service.dart';
import 'package:pawane_ciu/utils/app_colors.dart';
import 'package:pawane_ciu/utils/env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await MeterDbService().init();
  //await Env.load();
  runApp(const ProviderScope(child: PawaneCiuApp()));
}

class PawaneCiuApp extends StatelessWidget {
  const PawaneCiuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CIU',
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
