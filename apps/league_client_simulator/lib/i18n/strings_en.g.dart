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
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	dynamic operator[](String key) => _meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'League Client Simulator'
	String get appTitle => 'League Client Simulator';

	late final Translations$connection$en connection = Translations$connection$en._(_root);
	late final Translations$queues$en queues = Translations$queues$en._(_root);
	late final Translations$session$en session = Translations$session$en._(_root);
	late final Translations$actions$en actions = Translations$actions$en._(_root);
	late final Translations$scenarios$en scenarios = Translations$scenarios$en._(_root);
}

// Path: connection
class Translations$connection$en {
	Translations$connection$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Connect Remote Rift Desktop'
	String get title => 'Connect Remote Rift Desktop';

	/// en: 'In Remote Rift Desktop, open Settings → Lockfile location and choose this file.'
	String get instructions => 'In Remote Rift Desktop, open Settings → Lockfile location and choose this file.';

	/// en: 'Starting the local League Client API…'
	String get starting => 'Starting the local League Client API…';

	/// en: 'Couldn't write the lockfile. Check that the simulator can write to its application support folder, then retry.'
	String get lockfileUnavailable => 'Couldn\'t write the lockfile. Check that the simulator can write to its application support folder, then retry.';

	/// en: 'Couldn't start the local League Client API. Retry to open a new local HTTPS port.'
	String get listenerUnavailable => 'Couldn\'t start the local League Client API. Retry to open a new local HTTPS port.';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Copy path'
	String get copyPath => 'Copy path';

	/// en: 'Lockfile path copied'
	String get copied => 'Lockfile path copied';
}

// Path: queues
class Translations$queues$en {
	Translations$queues$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Normal Draft Pick'
	String get draft => 'Normal Draft Pick';

	/// en: 'ARAM'
	String get aram => 'ARAM';
}

// Path: session
class Translations$session$en {
	Translations$session$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Game session'
	String get title => 'Game session';

	/// en: 'Client offline'
	String get standby => 'Client offline';

	/// en: 'Choose a queue here or create a lobby from Remote Rift Mobile.'
	String get noQueue => 'Choose a queue here or create a lobby from Remote Rift Mobile.';

	/// en: '$seconds s remaining'
	String countdown({required Object seconds}) => '${seconds} s remaining';

	/// en: 'Waiting for other players to accept.'
	String get readyAccepted => 'Waiting for other players to accept.';

	/// en: 'Returning to the lobby.'
	String get readyDeclined => 'Returning to the lobby.';

	late final Translations$session$stages$en stages = Translations$session$stages$en._(_root);
}

// Path: actions
class Translations$actions$en {
	Translations$actions$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Find match'
	String get startSearch => 'Find match';

	/// en: 'Cancel search'
	String get stopSearch => 'Cancel search';

	/// en: 'Trigger ready check'
	String get findNow => 'Trigger ready check';

	/// en: 'Leave lobby'
	String get leaveLobby => 'Leave lobby';

	/// en: 'Accept'
	String get accept => 'Accept';

	/// en: 'Decline'
	String get decline => 'Decline';

	/// en: 'Advance phase'
	String get skipPhase => 'Advance phase';

	/// en: 'End game'
	String get endGame => 'End game';

	/// en: 'Reset session'
	String get resetSession => 'Reset session';
}

// Path: scenarios
class Translations$scenarios$en {
	Translations$scenarios$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Scenarios'
	String get title => 'Scenarios';

	/// en: 'Client online'
	String get online => 'Client online';

	/// en: 'Go offline to exercise Remote Rift Mobile's launch action.'
	String get onlineDescription => 'Go offline to exercise Remote Rift Mobile\'s launch action.';

	/// en: 'Another player declines'
	String get declineNextMatch => 'Another player declines';

	/// en: 'Return to the lobby after the next local acceptance.'
	String get declineNextMatchDescription => 'Return to the lobby after the next local acceptance.';
}

// Path: session.stages
class Translations$session$stages$en {
	Translations$session$stages$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'In lobby'
	String get lobby => 'In lobby';

	/// en: 'Searching for a match'
	String get searching => 'Searching for a match';

	/// en: 'Ready check'
	String get readyCheck => 'Ready check';

	/// en: 'Choose a champion to hover'
	String get planning => 'Choose a champion to hover';

	/// en: 'Your ban'
	String get localBan => 'Your ban';

	/// en: 'Opponent is banning'
	String get enemyBan => 'Opponent is banning';

	/// en: 'Teammate is picking'
	String get teammatePick => 'Teammate is picking';

	/// en: 'Opponent is picking'
	String get enemyPick => 'Opponent is picking';

	/// en: 'Your pick'
	String get localPick => 'Your pick';

	/// en: 'Finalize your spells'
	String get finalization => 'Finalize your spells';

	/// en: 'Game starting'
	String get gameStarting => 'Game starting';

	/// en: 'In game'
	String get inGame => 'In game';

	/// en: 'Waiting for stats'
	String get waitingForStats => 'Waiting for stats';

	/// en: 'Finishing game'
	String get preEndOfGame => 'Finishing game';

	/// en: 'Game ended'
	String get endOfGame => 'Game ended';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appTitle' => 'League Client Simulator',
			'connection.title' => 'Connect Remote Rift Desktop',
			'connection.instructions' => 'In Remote Rift Desktop, open Settings → Lockfile location and choose this file.',
			'connection.starting' => 'Starting the local League Client API…',
			'connection.lockfileUnavailable' => 'Couldn\'t write the lockfile. Check that the simulator can write to its application support folder, then retry.',
			'connection.listenerUnavailable' => 'Couldn\'t start the local League Client API. Retry to open a new local HTTPS port.',
			'connection.retry' => 'Retry',
			'connection.copyPath' => 'Copy path',
			'connection.copied' => 'Lockfile path copied',
			'queues.draft' => 'Normal Draft Pick',
			'queues.aram' => 'ARAM',
			'session.title' => 'Game session',
			'session.standby' => 'Client offline',
			'session.noQueue' => 'Choose a queue here or create a lobby from Remote Rift Mobile.',
			'session.countdown' => ({required Object seconds}) => '${seconds} s remaining',
			'session.readyAccepted' => 'Waiting for other players to accept.',
			'session.readyDeclined' => 'Returning to the lobby.',
			'session.stages.home' => 'Home',
			'session.stages.lobby' => 'In lobby',
			'session.stages.searching' => 'Searching for a match',
			'session.stages.readyCheck' => 'Ready check',
			'session.stages.planning' => 'Choose a champion to hover',
			'session.stages.localBan' => 'Your ban',
			'session.stages.enemyBan' => 'Opponent is banning',
			'session.stages.teammatePick' => 'Teammate is picking',
			'session.stages.enemyPick' => 'Opponent is picking',
			'session.stages.localPick' => 'Your pick',
			'session.stages.finalization' => 'Finalize your spells',
			'session.stages.gameStarting' => 'Game starting',
			'session.stages.inGame' => 'In game',
			'session.stages.waitingForStats' => 'Waiting for stats',
			'session.stages.preEndOfGame' => 'Finishing game',
			'session.stages.endOfGame' => 'Game ended',
			'actions.startSearch' => 'Find match',
			'actions.stopSearch' => 'Cancel search',
			'actions.findNow' => 'Trigger ready check',
			'actions.leaveLobby' => 'Leave lobby',
			'actions.accept' => 'Accept',
			'actions.decline' => 'Decline',
			'actions.skipPhase' => 'Advance phase',
			'actions.endGame' => 'End game',
			'actions.resetSession' => 'Reset session',
			'scenarios.title' => 'Scenarios',
			'scenarios.online' => 'Client online',
			'scenarios.onlineDescription' => 'Go offline to exercise Remote Rift Mobile\'s launch action.',
			'scenarios.declineNextMatch' => 'Another player declines',
			'scenarios.declineNextMatchDescription' => 'Return to the lobby after the next local acceptance.',
			_ => null,
		};
	}
}
