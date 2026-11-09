/// Versioned Drift migrations (P5-01).
abstract final class DatabaseMigrations {
  static const int currentVersion = 2;
  static const List<int> supportedVersions = [1, currentVersion];
}
