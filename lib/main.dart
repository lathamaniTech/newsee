import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:newsee/AppSamples/RouterApp/routerapp.dart';
import 'package:newsee/Utils/hive_cache_service.dart';
import 'package:newsee/Utils/injectiondependency.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/leadInbox/lead_cache_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await LeadCacheService.init();
  await HiveCacheService.init();
  // runApp(MyApp()) // Default MyApp()
  // runApp(Counter()); // load CounterApp
  // runApp(App()); // timerApp
  // runApp(ToolBarSample()); // Toolbar App
  //runApp(LoginApp()); // Login Form App
  dependencyInjection();
  // setupLocator();

  runApp(RouterApp()); // GoRouter Sample App
}

// git checkout -b karthicktechie-login_progressIndicator download-progress-indicator
