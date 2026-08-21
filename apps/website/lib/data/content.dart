class const SetupStep(final String title, final String description);

class const StatusItem(
  final String title,
  final String description, {
  final String? advice,
  final bool active = false,
});

class const CapabilityGroup(final String title, final List<String> items);

class const ProductScreenshot(final String path, final String alt, final String caption);

const requirements =
    'Requires Remote Rift Desktop, the League Client, and a local network that allows device-to-device connections.';

const setupSteps = [
  SetupStep('Run Remote Rift Desktop', 'Starts the local connector.'),
  SetupStep('Start the League Client', 'Remote Rift reads the available matchmaking state.'),
  SetupStep(
    'Open Remote Rift Mobile',
    'Remote Rift Mobile detects the desktop connector on the local network.',
  ),
  SetupStep(
    'Play the draft loop',
    'Choose roles, manage your lobby, answer the ready check, then take your assigned champion-select actions.',
  ),
];

const releasedCapabilities = [
  CapabilityGroup('Lobby and ready check', [
    'Choose a supported solo draft queue',
    'Set primary and secondary roles',
    'Create, search, cancel, or leave your lobby',
    'Accept or decline a ready check',
  ]),
  CapabilityGroup('Personal champion select', [
    'Select or ban when it is your assigned action',
    'Set your summoner spells',
    'Lock in your champion',
  ]),
];

const deferredCapabilities = ['Party management', 'Champion trades', 'ARAM-specific controls'];

const productScreenshots = [
  ProductScreenshot(
    'images/showcase/lobby-roles-placeholder.svg',
    'Placeholder for a native Remote Rift Mobile capture showing a solo draft lobby with primary and secondary role preferences',
    'Choose a solo draft queue and your preferred roles.',
  ),
  ProductScreenshot(
    'images/showcase/showcase.png',
    'Remote Rift Mobile showing a game found ready-check countdown',
    'Accept the ready check before it expires.',
  ),
  ProductScreenshot(
    'images/showcase/champion-select-placeholder.svg',
    'Placeholder for a native Remote Rift Mobile capture showing an assigned champion-select action with champion, spell, and lock-in controls',
    'When assigned, select or ban, set spells, and lock in.',
  ),
];

const statusItems = [
  StatusItem('Pre game', 'Choose a supported solo draft queue and create a lobby.'),
  StatusItem('In lobby', 'Set role preferences, search, or leave the lobby.'),
  StatusItem('Searching', 'Cancel search while the League Client keeps looking.'),
  StatusItem(
    'Ready check',
    'Accept or decline while the League Client offers the match.',
    active: true,
  ),
  StatusItem('Champion select', 'Only your currently assigned actions are available.'),
  StatusItem(
    'In game or post game',
    'Remote Rift remains informational until a new actionable state appears.',
  ),
];

const exceptionStates = [
  StatusItem(
    'Connection unavailable',
    'Remote Rift Desktop or the League Client is not running or cannot be reached.',
    advice: 'Start both applications, then reopen Remote Rift Mobile.',
  ),
  StatusItem(
    'Local network access required',
    'The phone cannot discover or reach the computer on the local network.',
    advice: 'Use a network that allows device-to-device connections. Guest Wi-Fi, client isolation, VLANs, firewalls, and blocked multicast can prevent discovery.',
  ),
  StatusItem(
    'Update required',
    'The desktop and mobile applications use incompatible versions.',
    advice: 'Update Remote Rift Desktop, then reopen the mobile application.',
  ),
];
