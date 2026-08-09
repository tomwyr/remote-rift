class SetupStep {
  const SetupStep(this.title, this.description);

  final String title;
  final String description;
}

class StatusItem {
  const StatusItem(this.title, this.description, {this.advice, this.active = false});

  final String title;
  final String description;
  final String? advice;
  final bool active;
}

const requirements =
    'Requires Remote Rift Desktop, the League Client, and a local network that allows device-to-device connections.';

const setupSteps = [
  SetupStep('Run Remote Rift Desktop', 'Starts the local connector.'),
  SetupStep('Start the League Client', 'Remote Rift reads the available matchmaking state.'),
  SetupStep(
    'Open Remote Rift Mobile',
    'Remote Rift Mobile detects the desktop connector on the local network.',
  ),
  SetupStep('Manage matchmaking', 'Available actions depend on the current client state.'),
];

const matchmakingActions = [
  'Select Game Queue',
  'Create Lobby',
  'Search Game',
  'Cancel Search',
  'Leave Lobby',
  'Accept Game',
  'Decline Game',
];

const queueGroups = ['Summoner\'s Rift', 'ARAM', 'Alternative', 'Other', 'Co-op vs. AI'];

const statusItems = [
  StatusItem('Pre game', 'Choose a queue and create a lobby.'),
  StatusItem('In lobby', 'A queue is selected and matchmaking is available.'),
  StatusItem('Searching game', 'Cancel Search remains available.'),
  StatusItem('Game found', 'Waiting for confirmation to join the game.', active: true),
  StatusItem('Game accepted', 'Waiting for the game to begin.'),
  StatusItem('Game in progress', 'Matchmaking actions are unavailable.'),
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
    advice:
        'Use a network that allows device-to-device connections. Guest Wi-Fi, client isolation, VLANs, firewalls, and blocked multicast can prevent discovery.',
  ),
  StatusItem(
    'Update required',
    'The desktop and mobile applications use incompatible versions.',
    advice: 'Update Remote Rift Desktop, then reopen the mobile application.',
  ),
];
