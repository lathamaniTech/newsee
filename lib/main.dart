import 'package:flutter/material.dart';
import 'package:newsee/AppSamples/RouterApp/routerapp.dart';
import 'package:newsee/Utils/injectiondependency.dart';

import 'AppSamples/FaceDetection/HomeScreen.dart';

void main() {
  // runApp(MyApp()) // Default MyApp()
  // runApp(Counter()); // load CounterApp
  // runApp(App()); // timerApp
  // runApp(ToolBarSample()); // Toolbar App
  //runApp(LoginApp()); // Login Form App
  dependencyInjection();
  // setupLocator();
  runApp(RouterApp()); // GoRouter Sample App
  // runApp(MaterialApp(
  //   home: Scaffold(
  //     body: HomeScreen(),
  //   ),
  // ));
}

// git checkout -b karthicktechie-login_progressIndicator download-progress-indicator
