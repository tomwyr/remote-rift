class AppConfig({
  required final String apiMinVersion,
}) {
  factory defaults() => AppConfig(apiMinVersion: '0.13.0');
}
