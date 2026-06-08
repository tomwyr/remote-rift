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
	late final TranslationsAppEn app = TranslationsAppEn._(_root);
	late final TranslationsUpdateEn update = TranslationsUpdateEn._(_root);
	late final TranslationsTrayEn tray = TranslationsTrayEn._(_root);
	late final TranslationsServiceEn service = TranslationsServiceEn._(_root);
	late final TranslationsConnectionEn connection = TranslationsConnectionEn._(_root);
	late final TranslationsGameErrorEn gameError = TranslationsGameErrorEn._(_root);
}

// Path: app
class TranslationsAppEn {
	TranslationsAppEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Remote Rift'
	String get title => 'Remote Rift';
}

// Path: update
class TranslationsUpdateEn {
	TranslationsUpdateEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Update'
	String get installTooltip => 'Update';

	/// en: 'Update Available'
	String get availableTitle => 'Update Available';

	/// en: 'A new version of the application is available. Update now to access the latest features.'
	String get availableDescription => 'A new version of the application is available. Update now to access the latest features.';

	/// en: 'Update'
	String get availableConfirmLabel => 'Update';

	/// en: 'Later'
	String get availableCancelLabel => 'Later';

	/// en: 'Updating...'
	String get inProgressTitle => 'Updating...';

	/// en: 'Downloading and installing the update. This may take a moment.'
	String get inProgressDescription => 'Downloading and installing the update. This may take a moment.';

	/// en: 'Update Failed'
	String get errorTitle => 'Update Failed';

	/// en: 'An error occurred while updating. Please try again.'
	String get errorDescription => 'An error occurred while updating. Please try again.';

	/// en: 'Retry'
	String get errorRetryLabel => 'Retry';
}

// Path: tray
class TranslationsTrayEn {
	TranslationsTrayEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Open'
	String get openLabel => 'Open';

	/// en: 'Quit'
	String get quitLabel => 'Quit';
}

// Path: service
class TranslationsServiceEn {
	TranslationsServiceEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Starting...'
	String get startingTitle => 'Starting...';

	/// en: 'Initializing application components'
	String get startingDescription => 'Initializing application components';

	/// en: 'Multiple networks detected'
	String get pendingMultipleAddressesTitle => 'Multiple networks detected';

	/// en: 'The application found more than one network address it can use and will automatically choose one.'
	String get pendingMultipleAddressesDescription => 'The application found more than one network address it can use and will automatically choose one.';

	/// en: 'Continue'
	String get pendingMultipleAddressesContinue => 'Continue';

	/// en: 'Startup failed'
	String get errorTitle => 'Startup failed';

	/// en: 'No network connection was found. Please check your internet connection and try again.'
	String get errorNoAddressDescription => 'No network connection was found. Please check your internet connection and try again.';

	/// en: 'The application couldn't start. This may be due to a missing network connection or another temporary issue.'
	String get errorUnknownDescription => 'The application couldn\'t start. This may be due to a missing network connection or another temporary issue.';

	/// en: 'Restart'
	String get errorRetry => 'Restart';
}

// Path: connection
class TranslationsConnectionEn {
	TranslationsConnectionEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Connecting...'
	String get connectingTitle => 'Connecting...';

	/// en: 'Initializing communication with the game client.'
	String get connectingDescription => 'Initializing communication with the game client.';

	/// en: 'Connected'
	String get connectedTitle => 'Connected';

	/// en: 'Successfully connected to the game client.'
	String get connectedDescription => 'Successfully connected to the game client.';

	/// en: 'Connection error'
	String get errorTitle => 'Connection error';

	/// en: 'Unable to connect to the game client.'
	String get errorDescription => 'Unable to connect to the game client.';

	/// en: 'Reconnect'
	String get errorRetry => 'Reconnect';
}

// Path: gameError
class TranslationsGameErrorEn {
	TranslationsGameErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Unable to connect'
	String get unableToConnectTitle => 'Unable to connect';

	/// en: 'Unknown game state'
	String get unknownTitle => 'Unknown game state';

	/// en: 'The game client could not be reached. Make sure that it is running to interact with the game.'
	String get unableToConnectDescription => 'The game client could not be reached. Make sure that it is running to interact with the game.';

	/// en: 'The game's state could not be accessed due to an unexpected error.'
	String get unknownDescription => 'The game\'s state could not be accessed due to an unexpected error.';
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
			'update.installTooltip' => 'Update',
			'update.availableTitle' => 'Update Available',
			'update.availableDescription' => 'A new version of the application is available. Update now to access the latest features.',
			'update.availableConfirmLabel' => 'Update',
			'update.availableCancelLabel' => 'Later',
			'update.inProgressTitle' => 'Updating...',
			'update.inProgressDescription' => 'Downloading and installing the update. This may take a moment.',
			'update.errorTitle' => 'Update Failed',
			'update.errorDescription' => 'An error occurred while updating. Please try again.',
			'update.errorRetryLabel' => 'Retry',
			'tray.openLabel' => 'Open',
			'tray.quitLabel' => 'Quit',
			'service.startingTitle' => 'Starting...',
			'service.startingDescription' => 'Initializing application components',
			'service.pendingMultipleAddressesTitle' => 'Multiple networks detected',
			'service.pendingMultipleAddressesDescription' => 'The application found more than one network address it can use and will automatically choose one.',
			'service.pendingMultipleAddressesContinue' => 'Continue',
			'service.errorTitle' => 'Startup failed',
			'service.errorNoAddressDescription' => 'No network connection was found. Please check your internet connection and try again.',
			'service.errorUnknownDescription' => 'The application couldn\'t start. This may be due to a missing network connection or another temporary issue.',
			'service.errorRetry' => 'Restart',
			'connection.connectingTitle' => 'Connecting...',
			'connection.connectingDescription' => 'Initializing communication with the game client.',
			'connection.connectedTitle' => 'Connected',
			'connection.connectedDescription' => 'Successfully connected to the game client.',
			'connection.errorTitle' => 'Connection error',
			'connection.errorDescription' => 'Unable to connect to the game client.',
			'connection.errorRetry' => 'Reconnect',
			'gameError.unableToConnectTitle' => 'Unable to connect',
			'gameError.unknownTitle' => 'Unknown game state',
			'gameError.unableToConnectDescription' => 'The game client could not be reached. Make sure that it is running to interact with the game.',
			'gameError.unknownDescription' => 'The game\'s state could not be accessed due to an unexpected error.',
			_ => null,
		};
	}
}
