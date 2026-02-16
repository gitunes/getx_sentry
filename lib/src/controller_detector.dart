import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'sentry_event_type_enum.dart';
import 'sentry_service.dart';

/// Global GetX Configuration for Sentry
/// Automatically tracks all controllers
class SentryGetXControllerDetector {
  static bool _initialized = false;

  /// Configures GetX with Sentry
  static void initialize() {
    if (_initialized) return;

    // Override GetX's default dependency injection behavior
    Get.config(
      enableLog: kDebugMode,
      // Capture GetX controller creation/destruction logs
      logWriterCallback: (text, {bool isError = false}) {
        log(text, name: 'GETX');
        _handleGetXLog(text, isError);
      },

      // Default transition and other settings
      defaultTransition: Get.defaultTransition,
    );

    _initialized = true;
  }

  /// Processes GetX log messages
  static void _handleGetXLog(String text, bool isError) {
    if (!Get.isRegistered<SentryService>()) return;

    try {
      // Detect controller lifecycle events
      if (_isControllerLifecycleEvent(text)) {
        _handleControllerLifecycle(text);
      }
    } catch (e) {
      debugPrint('❌ SentryGetXConfig error: $e');
    }
  }

  /// Checks for controller lifecycle events
  static bool _isControllerLifecycleEvent(String text) {
    final lowerText = text.toLowerCase();
    return (lowerText.contains('controller') &&
        (lowerText.contains('init') ||
            lowerText.contains('close') ||
            lowerText.contains('create') ||
            lowerText.contains('dispose') ||
            lowerText.contains('delete')));
  }

  /// Handles controller lifecycle events
  static void _handleControllerLifecycle(String text) {
    // Extract controller name
    final controllerMatch = RegExp(r'(\w*[Cc]ontroller\w*)').firstMatch(text);
    if (controllerMatch == null) return;

    final controllerName = controllerMatch.group(1) ?? 'UnknownController';

    // Log to Sentry
    SentryService.instance?.addBreadcrumb(
      type: SentryEventType.info,
      message: controllerName,
      data: {
        'controller': controllerName,
        'message': text,
        'source': 'SentryGetXControllerDetector',
      },
    );
  }
}
