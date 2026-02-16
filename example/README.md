# GetX Sentry Example

A complete Flutter example demonstrating how to use the `getx_sentry` package for seamless integration between GetX and Sentry.

## Setup Instructions

### 1. Add Dependencies

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6
  sentry_flutter: ^8.3.0
  getx_sentry: ^1.0.0
```

### 2. Initialize Sentry

In your `main.dart`, initialize Sentry before running the app:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SentryFlutter.init(
    (options) {
      options.dsn = 'YOUR_SENTRY_DSN';
      options.environment = 'development';
      options.release = 'app_name@1.0.0';
      options.debug = true;
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp()),
  );
}
```

### 3. Add Route Observers

Add the route observers to your `GetMaterialApp`:

```dart
GetMaterialApp(
  navigatorObservers: [
    SentryNavigatorObserver(),  // Sentry's default observer
    SentryRouteObserver(),      // GetX Sentry route observer
  ],
  // ... other configurations
)
```

### 4. Register SentryService

Create a binding class to register the SentryService:

```dart
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Register SentryService
    Get.put<SentryService>(SentryService(), permanent: true);
    
    // Initialize controller detector
    SentryGetXControllerDetector.initialize();
  }
}
```

## Package Methods

### SentryService

| Method | Description |
|--------|-------------|
| `setCurrentPage(pageName, metadata)` | Manually tracks page navigation |
| `addBreadcrumb(type, message, data)` | Adds a breadcrumb for tracking events |
| `captureException(exception, stackTrace, hint, extra, tags)` | Captures and sends an exception to Sentry |
| `captureMessage(message, level, extra, tags)` | Sends a custom message to Sentry |

### SentryEventType

Available event types for breadcrumbs:

| Type | Sentry Type | Use Case |
|------|-------------|----------|
| `navigation` | navigation | Track page/route transitions |
| `userInteraction` | user | Track button taps, gestures |
| `http` | http | Track API requests |
| `error` | error | Track error occurrences |
| `warning` | warning | Track warning events |
| `info` | info | Track informational events |

## Usage Examples

### Capturing an Exception

```dart
try {
  // Code that might throw
} catch (e, stackTrace) {
  await SentryService.instance?.captureException(
    e,
    stackTrace: stackTrace,
    hint: 'Description of what went wrong',
    extra: {'key': 'value'},
    tags: [{'key': 'tag_name', 'value': 'tag_value'}],
  );
}
```

### Sending a Custom Message

```dart
await SentryService.instance?.captureMessage(
  'User completed checkout',
  level: SentryLevel.info,
  extra: {'order_id': '12345'},
);
```

### Adding a Breadcrumb

```dart
SentryService.instance?.addBreadcrumb(
  type: SentryEventType.userInteraction,
  message: 'Button tapped',
  data: {'button_id': 'submit_form'},
);
```

## Running the Example

1. Replace the DSN in `main.dart` with your Sentry project DSN
2. Run `flutter pub get`
3. Run `flutter run`

## Features Demonstrated

- ✅ Sentry initialization with Flutter
- ✅ Automatic route tracking with SentryRouteObserver
- ✅ Manual page tracking with setCurrentPage()
- ✅ Exception capturing with full context
- ✅ Custom message logging with severity levels
- ✅ Breadcrumb tracking for user actions
- ✅ HTTP request tracking
- ✅ GetX controller lifecycle tracking
