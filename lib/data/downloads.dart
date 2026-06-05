import '../models/download.dart';

const downloads = [
  DownloadOption(
    title: "Desktop",
    description: "Run the client connector to link your League account and enable remote access.",
    links: [
      DownloadLink(label: "Windows"),
      DownloadLink(label: "macOS"),
    ],
  ),
  DownloadOption(
    title: "Mobile",
    description: "Use the app to queue, accept matches, and check status from your phone or watch.",
    links: [
      DownloadLink(icon: "downloads/icon_app_store.svg"),
      DownloadLink(icon: "downloads/icon_play_store.svg"),
    ],
  ),
];
