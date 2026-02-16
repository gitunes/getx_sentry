/// Package version information
/// 
/// This file contains the version information for the getx_sentry package.
/// Update this file when releasing a new version.
library;

/// Current version of the getx_sentry package
/// 
/// This should match the version in pubspec.yaml
const String packageVersion = '1.0.0';

/// Package name
const String packageName = 'getx_sentry';

/// Minimum supported GetX version
const String minGetXVersion = '4.6.5';

/// Minimum supported Sentry Flutter version
const String minSentryFlutterVersion = '9.6.0';

/// Package information for debugging and tracking
class GetxSentryInfo {
  GetxSentryInfo._();

  /// Returns the full version string
  static String get version => packageVersion;

  /// Returns the package name
  static String get name => packageName;

  /// Returns a map containing all package information
  static Map<String, String> get info => {
        'package': packageName,
        'version': packageVersion,
        'min_getx_version': minGetXVersion,
        'min_sentry_flutter_version': minSentryFlutterVersion,
      };

  /// Returns a formatted string with package information
  static String get formattedInfo =>
      '$packageName v$packageVersion (GetX: $minGetXVersion+, Sentry: $minSentryFlutterVersion+)';
}
