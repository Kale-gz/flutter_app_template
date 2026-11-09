import 'package:flutter/material.dart';
import 'package:flutter_app_template/app.dart';
import 'package:flutter_app_template/services/analytics_service.dart';
import 'package:flutter_app_template/services/crash_reporting_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CrashReportingService.initialize();
  await AnalyticsService.initialize();
  runApp(const StarterApp());
}
