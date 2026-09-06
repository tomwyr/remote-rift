///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$app$en app = Translations$app$en._(_root);
	late final Translations$gameState$en gameState = Translations$gameState$en._(_root);
	late final Translations$championSelect$en championSelect = Translations$championSelect$en._(_root);
	late final Translations$lobbyRolePreferences$en lobbyRolePreferences = Translations$lobbyRolePreferences$en._(_root);
	late final Translations$gameError$en gameError = Translations$gameError$en._(_root);
	late final Translations$gameQueue$en gameQueue = Translations$gameQueue$en._(_root);
	late final Translations$connection$en connection = Translations$connection$en._(_root);
	late final Translations$home$en home = Translations$home$en._(_root);
}

// Path: app
class Translations$app$en {
	Translations$app$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Remote Rift'
	String get title => 'Remote Rift';
}

// Path: gameState
class Translations$gameState$en {
	Translations$gameState$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Ready to queue'
	String get preGameTitle => 'Ready to queue';

	/// en: 'Choose a queue, then create a lobby.'
	String get preGameDescription => 'Choose a queue, then create a lobby.';

	/// en: 'In lobby'
	String get lobbyIdleTitle => 'In lobby';

	/// en: 'Start matchmaking to search for a game.'
	String get lobbyIdleDescription => 'Start matchmaking to search for a game.';

	/// en: 'Searching for a match'
	String get lobbySearchingTitle => 'Searching for a match';

	/// en: 'Matchmaking is looking for a game.'
	String get lobbySearchingDescription => 'Matchmaking is looking for a game.';

	/// en: 'Game found'
	String get foundPendingTitle => 'Game found';

	/// en: 'Accept the ready check before time runs out.'
	String get foundPendingDescription => 'Accept the ready check before time runs out.';

	/// en: 'Time left'
	String get foundPendingTimeLeft => 'Time left';

	/// en: 'Game accepted'
	String get foundAcceptedTitle => 'Game accepted';

	/// en: 'Waiting for other players to join before starting the game.'
	String get foundAcceptedDescription => 'Waiting for other players to join before starting the game.';

	/// en: 'Game declined'
	String get foundDeclinedTitle => 'Game declined';

	/// en: 'Waiting for the game to cancel before returning to the lobby.'
	String get foundDeclinedDescription => 'Waiting for the game to cancel before returning to the lobby.';

	/// en: 'Game in progress'
	String get inGameTitle => 'Game in progress';

	/// en: 'Wait for the current game to finish before queueing again.'
	String get inGameDescription => 'Wait for the current game to finish before queueing again.';

	/// en: 'Unknown game state'
	String get unknownTitle => 'Unknown game state';

	/// en: 'The game is running, but its current state cannot be identified. Restart the League Client and Remote Rift Desktop, or join manually this time.'
	String get unknownDescription => 'The game is running, but its current state cannot be identified. Restart the League Client and Remote Rift Desktop, or join manually this time.';

	/// en: 'Action not completed'
	String get actionFailed => 'Action not completed';

	/// en: 'Review the current game state, then try again if the action is still available.'
	String get actionRecoveryDescription => 'Review the current game state, then try again if the action is still available.';
}

// Path: championSelect
class Translations$championSelect$en {
	Translations$championSelect$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Champion select'
	String get title => 'Champion select';

	/// en: 'Review your current champion-select choices.'
	String get description => 'Review your current champion-select choices.';

	/// en: 'Choose champion'
	String get pickTitle => 'Choose champion';

	/// en: 'Choose champion to ban'
	String get banTitle => 'Choose champion to ban';

	/// en: 'Choose a champion to lock in for your turn.'
	String get pickGuidance => 'Choose a champion to lock in for your turn.';

	/// en: 'Choose a champion to ban for your turn.'
	String get banGuidance => 'Choose a champion to ban for your turn.';

	/// en: 'Choose Spell 1'
	String get spell1Title => 'Choose Spell 1';

	/// en: 'Choose Spell 2'
	String get spell2Title => 'Choose Spell 2';

	/// en: 'Choose a summoner spell for this slot.'
	String get spellGuidance => 'Choose a summoner spell for this slot.';

	/// en: 'Lock in champion?'
	String get lockInTitle => 'Lock in champion?';

	/// en: 'Confirm your champion before the timer runs out.'
	String get lockInGuidance => 'Confirm your champion before the timer runs out.';

	/// en: 'Lock In'
	String get lockInConfirm => 'Lock In';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Pick champion'
	String get pickAction => 'Pick champion';

	/// en: 'Ban champion'
	String get banAction => 'Ban champion';

	/// en: 'Lock In'
	String get lockInAction => 'Lock In';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Search choices'
	String get search => 'Search choices';

	/// en: 'Search'
	String get searchLabel => 'Search';

	/// en: 'No matching choices'
	String get noSearchResults => 'No matching choices';

	/// en: 'Couldn't send that action. Try again.'
	String get actionFailed => 'Couldn\'t send that action. Try again.';

	/// en: 'Couldn't load choices. Check your connection and retry.'
	String get catalogFailed => 'Couldn\'t load choices. Check your connection and retry.';

	/// en: 'Choices unavailable'
	String get catalogFailureTitle => 'Choices unavailable';

	/// en: 'Phase'
	String get phaseLabel => 'Phase';

	/// en: 'Time left'
	String get timeLeftLabel => 'Time left';

	/// en: 'Champion'
	String get championLabel => 'Champion';

	/// en: 'Position'
	String get positionLabel => 'Position';

	/// en: 'Summoner spells'
	String get spellsLabel => 'Summoner spells';

	/// en: 'Spell 1'
	String get spell1Label => 'Spell 1';

	/// en: 'Spell 2'
	String get spell2Label => 'Spell 2';

	/// en: 'Unavailable'
	String get unavailable => 'Unavailable';

	/// en: 'No champion selected'
	String get noChampion => 'No champion selected';

	late final Translations$championSelect$phase$en phase = Translations$championSelect$phase$en._(_root);
	late final Translations$championSelect$position$en position = Translations$championSelect$position$en._(_root);
}

// Path: lobbyRolePreferences
class Translations$lobbyRolePreferences$en {
	Translations$lobbyRolePreferences$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Role Preferences'
	String get title => 'Role Preferences';

	/// en: 'Select roles'
	String get selectRolesLabel => 'Select roles';

	/// en: 'Primary'
	String get primaryLabel => 'Primary';

	/// en: 'Secondary'
	String get secondaryLabel => 'Secondary';

	/// en: 'Select Primary Role'
	String get primarySelectionTitle => 'Select Primary Role';

	/// en: 'Select Secondary Role'
	String get secondarySelectionTitle => 'Select Secondary Role';

	/// en: 'Choose your preferred role for this game.'
	String get selectionDescription => 'Choose your preferred role for this game.';

	late final Translations$lobbyRolePreferences$role$en role = Translations$lobbyRolePreferences$role$en._(_root);
}

// Path: gameError
class Translations$gameError$en {
	Translations$gameError$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Unable to connect'
	String get unableToConnectTitle => 'Unable to connect';

	/// en: 'The game client could not be reached. Make sure that it is running to interact with the game.'
	String get unableToConnectDescription => 'The game client could not be reached. Make sure that it is running to interact with the game.';

	/// en: 'Unknown game state'
	String get unknownTitle => 'Unknown game state';

	/// en: 'The game's state could not be accessed due to an unexpected error.'
	String get unknownDescription => 'The game\'s state could not be accessed due to an unexpected error.';
}

// Path: gameQueue
class Translations$gameQueue$en {
	Translations$gameQueue$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Unknown'
	String get unknownPlaceholder => 'Unknown';

	/// en: 'Select Game Queue'
	String get selectButton => 'Select Game Queue';

	/// en: 'Available Queues'
	String get selectionTitle => 'Available Queues';

	/// en: 'CO-OP vs. AI'
	String get selectionAiTitle => 'CO-OP vs. AI';

	late final Translations$gameQueue$groupLabel$en groupLabel = Translations$gameQueue$groupLabel$en._(_root);
}

// Path: connection
class Translations$connection$en {
	Translations$connection$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Local link ready'
	String get statusReady => 'Local link ready';

	/// en: 'Connecting'
	String get statusConnecting => 'Connecting';

	/// en: 'Check connection'
	String get statusCheck => 'Check connection';

	/// en: 'Connecting...'
	String get connectingTitle => 'Connecting...';

	/// en: 'Looking for Remote Rift Desktop on your local network.'
	String get connectingDescription => 'Looking for Remote Rift Desktop on your local network.';

	/// en: 'Checking game state...'
	String get loadingTitle => 'Checking game state...';

	/// en: 'Reading the current League Client session.'
	String get loadingDescription => 'Reading the current League Client session.';

	/// en: 'Update required'
	String get incompatibleTitle => 'Update required';

	/// en: 'Your desktop application is out of date and isn't compatible anymore. Please update it to continue.'
	String get incompatibleDescription => 'Your desktop application is out of date and isn\'t compatible anymore. Please update it to continue.';

	/// en: 'Refresh'
	String get incompatibleRetry => 'Refresh';

	/// en: 'Connection error'
	String get errorTitle => 'Connection error';

	/// en: 'Remote Rift Desktop could not be reached. Make sure it is running and both devices can communicate on the same local network.'
	String get errorUnableToConnectDescription => 'Remote Rift Desktop could not be reached. Make sure it is running and both devices can communicate on the same local network.';

	/// en: 'Remote Rift Desktop could not be reached.'
	String get errorUnknownDescription => 'Remote Rift Desktop could not be reached.';

	/// en: 'Reconnect'
	String get errorRetry => 'Reconnect';
}

// Path: home
class Translations$home$en {
	Translations$home$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Game Mode'
	String get gameModeLabel => 'Game Mode';

	/// en: 'Game State'
	String get gameStateLabel => 'Game State';

	/// en: 'Create Lobby'
	String get createLobbyButton => 'Create Lobby';

	/// en: 'Search Game'
	String get searchGameButton => 'Search Game';

	/// en: 'Leave Lobby'
	String get leaveLobbyButton => 'Leave Lobby';

	/// en: 'Cancel Search'
	String get cancelSearchButton => 'Cancel Search';

	/// en: 'Accept Game'
	String get acceptGameButton => 'Accept Game';

	/// en: 'Decline Game'
	String get declineGameButton => 'Decline Game';
}

// Path: championSelect.phase
class Translations$championSelect$phase$en {
	Translations$championSelect$phase$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Planning'
	String get planning => 'Planning';

	/// en: 'Ban / Pick'
	String get banPick => 'Ban / Pick';

	/// en: 'Finalization'
	String get finalization => 'Finalization';
}

// Path: championSelect.position
class Translations$championSelect$position$en {
	Translations$championSelect$position$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Top'
	String get top => 'Top';

	/// en: 'Jungle'
	String get jungle => 'Jungle';

	/// en: 'Middle'
	String get middle => 'Middle';

	/// en: 'Bottom'
	String get bottom => 'Bottom';

	/// en: 'Support'
	String get support => 'Support';
}

// Path: lobbyRolePreferences.role
class Translations$lobbyRolePreferences$role$en {
	Translations$lobbyRolePreferences$role$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Top'
	String get top => 'Top';

	/// en: 'Jungle'
	String get jungle => 'Jungle';

	/// en: 'Middle'
	String get middle => 'Middle';

	/// en: 'Bottom'
	String get bottom => 'Bottom';

	/// en: 'Support'
	String get support => 'Support';
}

// Path: gameQueue.groupLabel
class Translations$gameQueue$groupLabel$en {
	Translations$gameQueue$groupLabel$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Summoner's Rift'
	String get summonersRift => 'Summoner\'s Rift';

	/// en: 'ARAM'
	String get aram => 'ARAM';

	/// en: 'Alternative'
	String get alternative => 'Alternative';

	/// en: 'Other'
	String get other => 'Other';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Remote Rift',
			'gameState.preGameTitle' => 'Ready to queue',
			'gameState.preGameDescription' => 'Choose a queue, then create a lobby.',
			'gameState.lobbyIdleTitle' => 'In lobby',
			'gameState.lobbyIdleDescription' => 'Start matchmaking to search for a game.',
			'gameState.lobbySearchingTitle' => 'Searching for a match',
			'gameState.lobbySearchingDescription' => 'Matchmaking is looking for a game.',
			'gameState.foundPendingTitle' => 'Game found',
			'gameState.foundPendingDescription' => 'Accept the ready check before time runs out.',
			'gameState.foundPendingTimeLeft' => 'Time left',
			'gameState.foundAcceptedTitle' => 'Game accepted',
			'gameState.foundAcceptedDescription' => 'Waiting for other players to join before starting the game.',
			'gameState.foundDeclinedTitle' => 'Game declined',
			'gameState.foundDeclinedDescription' => 'Waiting for the game to cancel before returning to the lobby.',
			'gameState.inGameTitle' => 'Game in progress',
			'gameState.inGameDescription' => 'Wait for the current game to finish before queueing again.',
			'gameState.unknownTitle' => 'Unknown game state',
			'gameState.unknownDescription' => 'The game is running, but its current state cannot be identified. Restart the League Client and Remote Rift Desktop, or join manually this time.',
			'gameState.actionFailed' => 'Action not completed',
			'gameState.actionRecoveryDescription' => 'Review the current game state, then try again if the action is still available.',
			'championSelect.title' => 'Champion select',
			'championSelect.description' => 'Review your current champion-select choices.',
			'championSelect.pickTitle' => 'Choose champion',
			'championSelect.banTitle' => 'Choose champion to ban',
			'championSelect.pickGuidance' => 'Choose a champion to lock in for your turn.',
			'championSelect.banGuidance' => 'Choose a champion to ban for your turn.',
			'championSelect.spell1Title' => 'Choose Spell 1',
			'championSelect.spell2Title' => 'Choose Spell 2',
			'championSelect.spellGuidance' => 'Choose a summoner spell for this slot.',
			'championSelect.lockInTitle' => 'Lock in champion?',
			'championSelect.lockInGuidance' => 'Confirm your champion before the timer runs out.',
			'championSelect.lockInConfirm' => 'Lock In',
			'championSelect.cancel' => 'Cancel',
			'championSelect.pickAction' => 'Pick champion',
			'championSelect.banAction' => 'Ban champion',
			'championSelect.lockInAction' => 'Lock In',
			'championSelect.retry' => 'Retry',
			'championSelect.search' => 'Search choices',
			'championSelect.searchLabel' => 'Search',
			'championSelect.noSearchResults' => 'No matching choices',
			'championSelect.actionFailed' => 'Couldn\'t send that action. Try again.',
			'championSelect.catalogFailed' => 'Couldn\'t load choices. Check your connection and retry.',
			'championSelect.catalogFailureTitle' => 'Choices unavailable',
			'championSelect.phaseLabel' => 'Phase',
			'championSelect.timeLeftLabel' => 'Time left',
			'championSelect.championLabel' => 'Champion',
			'championSelect.positionLabel' => 'Position',
			'championSelect.spellsLabel' => 'Summoner spells',
			'championSelect.spell1Label' => 'Spell 1',
			'championSelect.spell2Label' => 'Spell 2',
			'championSelect.unavailable' => 'Unavailable',
			'championSelect.noChampion' => 'No champion selected',
			'championSelect.phase.planning' => 'Planning',
			'championSelect.phase.banPick' => 'Ban / Pick',
			'championSelect.phase.finalization' => 'Finalization',
			'championSelect.position.top' => 'Top',
			'championSelect.position.jungle' => 'Jungle',
			'championSelect.position.middle' => 'Middle',
			'championSelect.position.bottom' => 'Bottom',
			'championSelect.position.support' => 'Support',
			'lobbyRolePreferences.title' => 'Role Preferences',
			'lobbyRolePreferences.selectRolesLabel' => 'Select roles',
			'lobbyRolePreferences.primaryLabel' => 'Primary',
			'lobbyRolePreferences.secondaryLabel' => 'Secondary',
			'lobbyRolePreferences.primarySelectionTitle' => 'Select Primary Role',
			'lobbyRolePreferences.secondarySelectionTitle' => 'Select Secondary Role',
			'lobbyRolePreferences.selectionDescription' => 'Choose your preferred role for this game.',
			'lobbyRolePreferences.role.top' => 'Top',
			'lobbyRolePreferences.role.jungle' => 'Jungle',
			'lobbyRolePreferences.role.middle' => 'Middle',
			'lobbyRolePreferences.role.bottom' => 'Bottom',
			'lobbyRolePreferences.role.support' => 'Support',
			'gameError.unableToConnectTitle' => 'Unable to connect',
			'gameError.unableToConnectDescription' => 'The game client could not be reached. Make sure that it is running to interact with the game.',
			'gameError.unknownTitle' => 'Unknown game state',
			'gameError.unknownDescription' => 'The game\'s state could not be accessed due to an unexpected error.',
			'gameQueue.unknownPlaceholder' => 'Unknown',
			'gameQueue.selectButton' => 'Select Game Queue',
			'gameQueue.selectionTitle' => 'Available Queues',
			'gameQueue.selectionAiTitle' => 'CO-OP vs. AI',
			'gameQueue.groupLabel.summonersRift' => 'Summoner\'s Rift',
			'gameQueue.groupLabel.aram' => 'ARAM',
			'gameQueue.groupLabel.alternative' => 'Alternative',
			'gameQueue.groupLabel.other' => 'Other',
			'connection.statusReady' => 'Local link ready',
			'connection.statusConnecting' => 'Connecting',
			'connection.statusCheck' => 'Check connection',
			'connection.connectingTitle' => 'Connecting...',
			'connection.connectingDescription' => 'Looking for Remote Rift Desktop on your local network.',
			'connection.loadingTitle' => 'Checking game state...',
			'connection.loadingDescription' => 'Reading the current League Client session.',
			'connection.incompatibleTitle' => 'Update required',
			'connection.incompatibleDescription' => 'Your desktop application is out of date and isn\'t compatible anymore. Please update it to continue.',
			'connection.incompatibleRetry' => 'Refresh',
			'connection.errorTitle' => 'Connection error',
			'connection.errorUnableToConnectDescription' => 'Remote Rift Desktop could not be reached. Make sure it is running and both devices can communicate on the same local network.',
			'connection.errorUnknownDescription' => 'Remote Rift Desktop could not be reached.',
			'connection.errorRetry' => 'Reconnect',
			'home.gameModeLabel' => 'Game Mode',
			'home.gameStateLabel' => 'Game State',
			'home.createLobbyButton' => 'Create Lobby',
			'home.searchGameButton' => 'Search Game',
			'home.leaveLobbyButton' => 'Leave Lobby',
			'home.cancelSearchButton' => 'Cancel Search',
			'home.acceptGameButton' => 'Accept Game',
			'home.declineGameButton' => 'Decline Game',
			_ => null,
		};
	}
}
