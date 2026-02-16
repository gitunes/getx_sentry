import 'package:get/get.dart';
import 'package:getx_sentry/getx_sentry.dart';

import '../controllers/home_controller.dart';

/// Initial Bindings for the application
/// 
/// This class demonstrates how to set up getx_sentry with GetX dependency injection.
/// It registers the SentryService and initializes the controller detector.
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // ============================================
    // Register SentryService as a permanent service
    // ============================================
    // The 'permanent: true' flag ensures the service persists
    // throughout the entire app lifecycle
    Get.put<SentryService>(SentryService(), permanent: true);
    
    // ============================================
    // Initialize GetX Controller Detector
    // ============================================
    // This automatically tracks controller lifecycle events
    // (creation, disposal) and sends them as breadcrumbs to Sentry
    SentryGetXControllerDetector.initialize();
    
    // Register other controllers
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
