import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'sentry_event_type_enum.dart';
import 'version.dart';

/// Handles error capturing and basic page tracking
class SentryService extends GetxService {
  static SentryService? get instance {
    if (!Sentry.isEnabled) return null;
    if (!Get.isRegistered<SentryService>()) return null;
    return Get.find<SentryService>();
  }

  // Current page information
  String? _currentPage;
  String? _previousPage;

  // User session information
  Map<String, dynamic> _userContext = {};

  @override
  void onInit() {
    _initializeUserContext();
    super.onInit();
  }

  /// Initializes user context information
  void _initializeUserContext() {
    _userContext = {
      'session_start': DateTime.now().toIso8601String(),
      'platform': defaultTargetPlatform.name,
    };
  }

  /// Tracks page changes
  void setCurrentPage(String pageName, {Map<String, dynamic>? metadata}) {
    _previousPage = _currentPage;
    _currentPage = pageName;

    String? message;

    if (_previousPage != null) {
      message = 'Page changed -> navigated from $_previousPage to $pageName';
    } else {
      message = 'Initial page loaded -> $pageName';
    }

    // Add page change as breadcrumb
    addBreadcrumb(
      type: SentryEventType.navigation,
      message: message,
      data: {
        'from': _previousPage ?? 'unknown',
        'to': pageName,
        'timestamp': DateTime.now().toIso8601String(),
        if (metadata != null) ...metadata,
      },
    );

    // Add to Sentry scope
    Sentry.configureScope((scope) {
      scope.setTag('current_page', pageName);
      if (_previousPage != null) {
        scope.setTag('previous_page', _previousPage!);
      }
    });
  }

  /// Adds a simple breadcrumb
  void addBreadcrumb({
    required SentryEventType type,
    required String message,
    Map<String, dynamic>? data,
    SentryLevel level = SentryLevel.info,
  }) {
    if (!Sentry.isEnabled) return;

    // Add breadcrumb to Sentry
    Sentry.addBreadcrumb(Breadcrumb(
      type: type.sentryType,
      message: message,
      data: data,
      level: level,
      timestamp: DateTime.now(),
    ));
  }

  /// Captures and sends exceptions to Sentry
  Future<void> captureException(
    dynamic exception, {
    StackTrace? stackTrace,
    String? hint,
    Map<String, dynamic>? extra,
    List<Map<String, dynamic>>? tags,
    SentryLevel level = SentryLevel.error,
  }) async {
    // Add extra context
    final enrichedExtra = <String, dynamic>{
      ...?extra,
      'current_page': _currentPage,
      'previous_page': _previousPage,
      'user_context': _userContext,
      'timestamp': DateTime.now().toIso8601String(),
      'getx_sentry_version': packageVersion,
    };

    if (!Sentry.isEnabled) return;

    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      hint: hint != null ? Hint.withMap({'hint': hint}) : null,
      withScope: (scope) {
        scope.setTag('error_handler', 'getx_sentry');
        scope.setTag('getx_integration', 'enabled');

        // Add extra information
        enrichedExtra.forEach((key, value) {
          scope.setContexts(key, value);
        });

        // Add tags
        if (tags != null) {
          for (final tag in tags) {
            scope.setTag(tag['key'], tag['value']);
          }
        }

        scope.level = level;
      },
    );
  }

  /// Sends a custom message manually
  Future<void> captureMessage(
    String message, {
    SentryLevel level = SentryLevel.info,
    Map<String, dynamic>? extra,
    List<Map<String, dynamic>>? tags,
  }) async {
    final enrichedExtra = <String, dynamic>{
      ...?extra,
      'current_page': _currentPage,
      'user_context': _userContext,
      'getx_sentry_version': packageVersion,
    };

    if (!Sentry.isEnabled) return;

    await Sentry.captureMessage(
      message,
      level: level,
      withScope: (scope) {
        // Indicate that GetX Sentry package is being used
        scope.setTag('error_handler', 'getx_sentry');
        scope.setTag('getx_integration', 'enabled');

        enrichedExtra.forEach((key, value) {
          scope.setContexts(key, value);
        });

        if (tags != null) {
          for (final tag in tags) {
            scope.setTag(tag['key'], tag['value']);
          }
        }
      },
    ).then((s) {
      debugPrint('Sentry message captured: $message, status: $s');
    }).catchError((e) {
      debugPrint('Sentry message capture error: $e');
    });
  }
}
