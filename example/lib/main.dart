import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_sentry/getx_sentry.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'bindings/initial_bindings.dart';
import 'screens/home_screen.dart';
import 'screens/details_screen.dart';
import 'screens/settings_screen.dart';

/// Main entry point for the GetX Sentry Example Application
/// 
/// This example demonstrates:
/// - How to initialize Sentry with Flutter
/// - How to integrate getx_sentry package
/// - How to track routes automatically
/// - How to capture exceptions and messages
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ============================================
  // STEP 1: Initialize Sentry
  // ============================================
  // You must initialize Sentry before running the app.
  // Replace the DSN with your own Sentry project DSN.
  await SentryFlutter.init(
    (options) {
      // Your Sentry DSN (Data Source Name)
      // Get this from your Sentry project settings
      options.dsn = 'https://your-sentry-dsn@sentry.io/your-project-id';
      
      // Set the environment (development, staging, production)
      options.environment = 'development';
      
      // Set the app release version
      options.release = 'getx_sentry_example@1.0.0+1';
      
      // Enable debug mode for development (disable in production)
      options.debug = true;
      
      // Sample rate for performance monitoring (0.0 to 1.0)
      // 1.0 means 100% of transactions will be sent
      options.tracesSampleRate = 1.0;
      
      // Automatically attach screenshots to errors (optional)
      options.attachScreenshot = true;
    },
    appRunner: () => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Sentry Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      
      // ============================================
      // STEP 2: Add Route Observers
      // ============================================
      // SentryNavigatorObserver: Default Sentry route observer
      // SentryRouteObserver: Custom GetX route observer from getx_sentry package
      navigatorObservers: [
        SentryNavigatorObserver(),  // Sentry's default observer
        SentryRouteObserver(),      // GetX Sentry route observer
      ],
      
      // ============================================
      // STEP 3: Initialize Bindings
      // ============================================
      // InitialBindings sets up the SentryService and controller detector
      initialBinding: InitialBindings(),
      
      // Define your app routes
      initialRoute: '/home',
      getPages: [
        GetPage(
          name: '/home',
          page: () => const HomeScreen(),
        ),
        GetPage(
          name: '/details',
          page: () => const DetailsScreen(),
        ),
        GetPage(
          name: '/settings',
          page: () => const SettingsScreen(),
        ),
      ],
    );
  }
}
