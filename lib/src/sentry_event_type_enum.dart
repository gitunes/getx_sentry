enum SentryEventType {
  navigation,
  userInteraction,
  http,
  error,
  warning,
  info;

  String get sentryType {
    switch (this) {
      case SentryEventType.navigation:
        return 'navigation';
      case SentryEventType.userInteraction:
        return 'user';
      case SentryEventType.http:
        return 'http';
      case SentryEventType.error:
        return 'error';
      case SentryEventType.warning:
        return 'warning';
      case SentryEventType.info:
        return 'info';
    }
  }
}
