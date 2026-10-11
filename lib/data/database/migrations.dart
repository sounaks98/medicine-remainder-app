/// Versioned Drift migrations (P5-01).
abstract final class DatabaseMigrations {
  static const int currentVersion = 1;
  static const List<int> supportedVersions = [currentVersion];
}
