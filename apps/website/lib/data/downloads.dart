import '../models/download.dart';

const downloads = [
  DownloadOption(
    title: 'Desktop application',
    description: 'Connect Remote Rift to the League Client on your computer.',
    links: [
      DownloadLink(label: 'Windows'),
      DownloadLink(label: 'macOS'),
    ],
  ),
  DownloadOption(
    title: 'Mobile application',
    description: 'Check queue status, manage the lobby, and respond to a found match.',
    links: [
      DownloadLink(label: 'Android'),
      DownloadLink(label: 'iOS'),
    ],
  ),
];
