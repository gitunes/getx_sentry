# GetX Sentry

[![pub package](https://img.shields.io/pub/v/getx_sentry.svg)](https://pub.dev/packages/getx_sentry)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Seamless integration between **Sentry** and **GetX** framework for Flutter. Provides automatic error tracking, route observation, and controller lifecycle monitoring.

## Features

- 🔍 **Automatic Route Tracking** - Track page navigation automatically with `SentryRouteObserver`
- 🎮 **Controller Lifecycle Monitoring** - Automatically track GetX controller creation and disposal
- 🐛 **Exception Capturing** - Capture and send exceptions to Sentry with rich context
- 📝 **Custom Messages** - Send custom messages with different severity levels
- 🍞 **Breadcrumb Tracking** - Track user actions, HTTP requests, and navigation events
- 📄 **Page Tracking** - Manual page tracking with metadata support

## Installation

Add `getx_sentry` to your `pubspec.yaml`:

```yaml
dependencies:
  getx_sentry: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Initialize Sentry

```dart
import 'package:flutter/material.dart';
import 'package:getx_sentry/getx_sentry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SentryFlutter.init(
    (options) {
      options.dsn = 'YOUR_SENTRY_DSN';
      options.environment = 'production';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp()),
  );
}
```

### 2. Configure GetMaterialApp

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Add route observers for automatic navigation tracking
      navigatorObservers: [
        SentryNavigatorObserver(),
        SentryRouteObserver(),
      ],
      initialBinding: AppBindings(),
      home: HomeScreen(),
    );
  }
}
```

### 3. Register SentryService

```dart
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Register SentryService as a permanent service
    Get.put<SentryService>(SentryService(), permanent: true);
    
    // Initialize controller lifecycle tracking
    SentryGetXControllerDetector.initialize();
  }
}
```

## Usage

### Capture Exceptions

```dart
try {
  // Your code that might throw
} catch (e, stackTrace) {
  await SentryService.instance?.captureException(
    e,
    stackTrace: stackTrace,
    hint: 'Error occurred during data fetch',
    extra: {'user_action': 'fetch_data'},
    tags: [{'key': 'module', 'value': 'api'}],
  );
}
```

### Send Custom Messages

```dart
await SentryService.instance?.captureMessage(
  'User completed checkout',
  level: SentryLevel.info,
  extra: {'order_id': '12345'},
);
```

### Add Breadcrumbs

```dart
SentryService.instance?.addBreadcrumb(
  type: SentryEventType.userInteraction,
  message: 'Button tapped',
  data: {'button_id': 'submit'},
);
```

### Track Pages Manually

```dart
SentryService.instance?.setCurrentPage(
  'ProductDetailsScreen',
  metadata: {'product_id': '123'},
);
```

## Breadcrumb Types

| Type | Description |
|------|-------------|
| `SentryEventType.navigation` | Route/page transitions |
| `SentryEventType.userInteraction` | User actions (taps, gestures) |
| `SentryEventType.http` | API requests |
| `SentryEventType.error` | Error events |
| `SentryEventType.warning` | Warning events |
| `SentryEventType.info` | Informational events |

## API Reference

### SentryService

| Method | Description |
|--------|-------------|
| `captureException()` | Capture and send exceptions to Sentry |
| `captureMessage()` | Send custom messages to Sentry |
| `addBreadcrumb()` | Add breadcrumbs for event tracking |
| `setCurrentPage()` | Track page navigation manually |

### SentryRouteObserver

Automatically tracks GetX route changes and sends them as breadcrumbs to Sentry.

### SentryGetXControllerDetector

Automatically detects and logs GetX controller lifecycle events (init, close).

## Version Info

```dart
// Access package version information
print(GetxSentryInfo.version);        // "1.0.0"
print(GetxSentryInfo.formattedInfo);  // Full version string
```

## Requirements

- Flutter SDK
- Dart SDK: ^3.10.8
- get: ^4.6.5
- sentry_flutter: ^9.6.0

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Issues

If you find a bug or have a feature request, please open an issue on [GitHub](https://github.com/gitunes/getx_sentry/issues).
