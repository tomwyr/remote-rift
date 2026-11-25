class LcuRoutes {
  static const applicationName = '/riotclient/app-name';
  static const gameflowPhase = '/lol-gameflow/v1/gameflow-phase';
  static const gameflowSession = '/lol-gameflow/v1/session';
  static const queues = '/lol-game-queues/v1/queues';

  static const lobby = '/lol-lobby/v2/lobby';
  static const lobbyPositionPreferences = '$lobby/members/localMember/position-preferences';
  static const matchmakingSearch = '$lobby/matchmaking/search';
  static const matchmakingSearchState = '$matchmakingSearch-state';
  static const readyCheck = '/lol-matchmaking/v1/ready-check';
  static const acceptReadyCheck = '$readyCheck/accept';
  static const declineReadyCheck = '$readyCheck/decline';

  static const _championSelect = '/lol-champ-select/v1';
  static const championSelectSession = '$_championSelect/session';
  static const championSelectActions = '$championSelectSession/actions';
  static const championSelectLocalSelection = '$championSelectSession/my-selection';
  static const championGrid = '$_championSelect/all-grid-champions';
  static const summonerSpells = '/lol-game-data/assets/v1/summoner-spells.json';
}
