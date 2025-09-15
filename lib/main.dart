import 'package:flutter/material.dart';
import 'package:routin_flutter/core/app_theme.dart';
import 'package:routin_flutter/core/logging.dart';
import 'package:routin_flutter/features/usage_stats/presentation/usage_page.dart';

void main() async {
  await AppLogger.init();
  await AppLogger.log("Application started");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const UsagePage(),
    );
  }
}
