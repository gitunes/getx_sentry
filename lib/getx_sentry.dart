/// Sentry GetX Integration Package
///
/// This package provides seamless integration between Sentry and GetX framework,
/// including automatic error tracking, route observation, and controller lifecycle monitoring.
library getx_sentry;

// Re-export commonly used Sentry types for convenience
export 'package:sentry_flutter/sentry_flutter.dart' show Sentry, SentryLevel, SentryUser;

export 'src/controller_detector.dart';
export 'src/route_observer.dart';
export 'src/sentry_event_type_enum.dart';
export 'src/version.dart';
// Export all public APIs
export 'src/sentry_service.dart';
