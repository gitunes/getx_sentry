import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'sentry_service.dart';

/// GetX Route Observer
/// Automatically notifies SentryService of page changes
class SentryRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logRouteChange(route, 'push', previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _logRouteChange(previousRoute, 'pop', route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _logRouteChange(newRoute, 'replace', oldRoute);
    }
  }

  void _logRouteChange(Route<dynamic> route, String action, Route<dynamic>? previousRoute) {
    try {
      final routeName = route.settings.name ?? route.runtimeType.toString();

      // Notify SentryService of page change
      if (Get.isRegistered<SentryService>() && Sentry.isEnabled) {
        SentryService.instance?.setCurrentPage(
          routeName,
          metadata: {
            'navigation_action': action,
          },
        );
      }
    } catch (e, stackTrace) {
      debugPrint('SentryRouteObserver error: $e');
      SentryService.instance?.captureException(
        e,
        stackTrace: stackTrace,
        hint: 'Route observer error',
        extra: {
          'route_name': route.settings.name ?? route.runtimeType.toString(),
          'action': action,
        },
      );
    }
  }
}
