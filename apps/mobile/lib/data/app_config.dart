class AppConfig({
  required final String apiMinVersion,
}) {
  factory AppConfig.defaults() => AppConfig(apiMinVersion: '0.12.0');
}
