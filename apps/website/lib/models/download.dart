class DownloadLink {
  const DownloadLink({
    this.label,
    this.icon,
  });

  final String? label;
  final String? icon;
}

class DownloadOption {
  const DownloadOption({
    required this.title,
    required this.description,
    required this.links,
  });

  final String title;
  final String description;
  final List<DownloadLink> links;
}
