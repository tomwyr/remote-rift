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

	/// en: 'Remote Rift Desktop could not be reached. Make sure it is running and both devices are on the same local network.'
	String get errorUnableToConnectDescription => 'Remote Rift Desktop could not be reached. Make sure it is running and both devices are on the same local network.';

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
			'connection.errorUnableToConnectDescription' => 'Remote Rift Desktop could not be reached. Make sure it is running and both devices are on the same local network.',
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
