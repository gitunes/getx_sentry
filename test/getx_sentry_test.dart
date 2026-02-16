import 'package:flutter_test/flutter_test.dart';
import 'package:getx_sentry/getx_sentry.dart';

void main() {
  group('SentryEventType', () {
    test('navigation type returns correct sentry type', () {
      expect(SentryEventType.navigation.sentryType, 'navigation');
    });

    test('userInteraction type returns correct sentry type', () {
      expect(SentryEventType.userInteraction.sentryType, 'user');
    });

    test('http type returns correct sentry type', () {
      expect(SentryEventType.http.sentryType, 'http');
    });

    test('error type returns correct sentry type', () {
      expect(SentryEventType.error.sentryType, 'error');
    });

    test('warning type returns correct sentry type', () {
      expect(SentryEventType.warning.sentryType, 'warning');
    });

    test('info type returns correct sentry type', () {
      expect(SentryEventType.info.sentryType, 'info');
    });
  });

  group('GetxSentryInfo', () {
    test('version returns correct version string', () {
      expect(GetxSentryInfo.version, packageVersion);
    });

    test('name returns correct package name', () {
      expect(GetxSentryInfo.name, 'getx_sentry');
    });

    test('info returns map with all required keys', () {
      final info = GetxSentryInfo.info;
      
      expect(info.containsKey('package'), true);
      expect(info.containsKey('version'), true);
      expect(info.containsKey('min_getx_version'), true);
      expect(info.containsKey('min_sentry_flutter_version'), true);
    });

    test('formattedInfo contains package name and version', () {
      final formattedInfo = GetxSentryInfo.formattedInfo;
      
      expect(formattedInfo.contains('getx_sentry'), true);
      expect(formattedInfo.contains(packageVersion), true);
    });
  });

  group('Version Constants', () {
    test('packageVersion is not empty', () {
      expect(packageVersion.isNotEmpty, true);
    });

    test('packageName is getx_sentry', () {
      expect(packageName, 'getx_sentry');
    });

    test('minGetXVersion is defined', () {
      expect(minGetXVersion.isNotEmpty, true);
    });

    test('minSentryFlutterVersion is defined', () {
      expect(minSentryFlutterVersion.isNotEmpty, true);
    });
  });
}
