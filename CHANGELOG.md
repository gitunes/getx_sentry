# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-16

### Added
- Initial release of getx_sentry package
- `SentryService` - Core service for error tracking and page monitoring
  - `captureException()` - Capture and send exceptions to Sentry
  - `captureMessage()` - Send custom messages to Sentry
  - `addBreadcrumb()` - Add breadcrumbs for event tracking
  - `setCurrentPage()` - Track page navigation
- `SentryRouteObserver` - Automatic route tracking for GetX navigation
- `SentryGetXControllerDetector` - Automatic controller lifecycle tracking
- `SentryEventType` enum for categorizing breadcrumb types
  - `navigation` - Route/page transitions
  - `userInteraction` - User actions (taps, gestures)
  - `http` - API requests
  - `error` - Error events
  - `warning` - Warning events
  - `info` - Informational events
- Centralized version management with `GetxSentryInfo` class
- Full integration with Sentry Flutter SDK
- Compatible with GetX 4.6.5+

### Dependencies
- Flutter SDK
- get: ^4.6.5
- sentry_flutter: ^9.6.0
