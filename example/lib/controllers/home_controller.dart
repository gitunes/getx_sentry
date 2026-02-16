import 'package:get/get.dart';
import 'package:getx_sentry/getx_sentry.dart';

/// Home Controller demonstrating SentryService usage in a GetX controller
/// 
/// This controller shows how to:
/// - Add breadcrumbs for user actions
/// - Capture exceptions
/// - Send custom messages
class HomeController extends GetxController {
  // Observable counter for demonstration
  final counter = 0.obs;
  
  // Loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    
    // ============================================
    // Add Breadcrumb for Controller Initialization
    // ============================================
    // Breadcrumbs help track the sequence of events before an error occurs
    SentryService.instance?.addBreadcrumb(
      type: SentryEventType.info,
      message: 'HomeController initialized',
      data: {
        'controller': 'HomeController',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Increment counter and track the action
  void incrementCounter() {
    counter.value++;
    
    // Track user interaction as a breadcrumb
    SentryService.instance?.addBreadcrumb(
      type: SentryEventType.userInteraction,
      message: 'Counter incremented',
      data: {
        'new_value': counter.value,
        'action': 'increment',
      },
    );
  }

  /// Simulate an API call with error tracking
  Future<void> simulateApiCall() async {
    isLoading.value = true;
    
    // Add breadcrumb for API call start
    SentryService.instance?.addBreadcrumb(
      type: SentryEventType.http,
      message: 'API call started: GET /api/data',
      data: {
        'method': 'GET',
        'url': 'https://api.example.com/api/data',
      },
    );
    
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Add breadcrumb for successful API call
      SentryService.instance?.addBreadcrumb(
        type: SentryEventType.http,
        message: 'API call completed successfully',
        data: {
          'status_code': 200,
          'duration_ms': 2000,
        },
      );
    } catch (e, stackTrace) {
      // Capture API errors
      await SentryService.instance?.captureException(
        e,
        stackTrace: stackTrace,
        hint: 'API call failed',
        extra: {'endpoint': '/api/data'},
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Trigger a test exception to demonstrate error capturing
  Future<void> triggerTestException() async {
    try {
      // Intentionally cause a division by zero error
      final result = 100 ~/ 0;
      print(result); // This line will never execute
    } catch (e, stackTrace) {
      // ============================================
      // Capture Exception
      // ============================================
      // captureException() sends the error to Sentry with:
      // - Stack trace for debugging
      // - Custom hint for context
      // - Extra data for additional information
      // - Tags for categorization and filtering
      await SentryService.instance?.captureException(
        e,
        stackTrace: stackTrace,
        hint: 'Test exception triggered by user',
        extra: {
          'operation': 'division',
          'numerator': 100,
          'denominator': 0,
          'triggered_at': DateTime.now().toIso8601String(),
        },
        tags: [
          {'key': 'error_type', 'value': 'arithmetic_error'},
          {'key': 'user_triggered', 'value': 'true'},
        ],
        level: SentryLevel.error,
      );
      
      // Show feedback to user
      Get.snackbar(
        'Error Captured',
        'Exception has been sent to Sentry',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Send a custom message to Sentry
  Future<void> sendCustomMessage({
    required String message,
    required SentryLevel level,
  }) async {
    // ============================================
    // Capture Message
    // ============================================
    // captureMessage() sends a custom message to Sentry
    // Useful for logging important events that aren't errors
    await SentryService.instance?.captureMessage(
      message,
      level: level,
      extra: {
        'counter_value': counter.value,
        'sent_at': DateTime.now().toIso8601String(),
      },
      tags: [
        {'key': 'message_type', 'value': 'user_action'},
        {'key': 'screen', 'value': 'home'},
      ],
    );
    
    Get.snackbar(
      'Message Sent',
      'Custom message has been sent to Sentry',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    // Track controller disposal
    SentryService.instance?.addBreadcrumb(
      type: SentryEventType.info,
      message: 'HomeController disposed',
      data: {
        'final_counter_value': counter.value,
      },
    );
    super.onClose();
  }
}
