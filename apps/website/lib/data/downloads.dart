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
    description: 'Run the full solo draft loop: roles and lobby, ready check, then your champion-select actions.',
    links: [
      DownloadLink(label: 'Android'),
      DownloadLink(label: 'iOS'),
    ],
  ),
];
