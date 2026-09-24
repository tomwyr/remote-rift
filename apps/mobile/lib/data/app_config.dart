class AppConfig({
  required final String apiMinVersion,
}) {
  factory defaults() => AppConfig(apiMinVersion: '0.14.0');
}
