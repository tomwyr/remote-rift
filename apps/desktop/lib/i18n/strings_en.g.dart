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
	late final Translations$update$en update = Translations$update$en._(_root);
	late final Translations$tray$en tray = Translations$tray$en._(_root);
	late final Translations$service$en service = Translations$service$en._(_root);
	late final Translations$connection$en connection = Translations$connection$en._(_root);
	late final Translations$settings$en settings = Translations$settings$en._(_root);
	late final Translations$gameError$en gameError = Translations$gameError$en._(_root);
	late final Translations$mcp$en mcp = Translations$mcp$en._(_root);
}

// Path: app
class Translations$app$en {
	Translations$app$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Remote Rift'
	String get title => 'Remote Rift';
}

// Path: update
class Translations$update$en {
	Translations$update$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Application update'
	String get statusEyebrow => 'Application update';

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

	/// en: 'Update complete'
	String get installedTitle => 'Update complete';

	/// en: 'The latest version is ready to use.'
	String get installedDescription => 'The latest version is ready to use.';

	/// en: 'Update failed'
	String get installationFailedTitle => 'Update failed';

	/// en: 'Remote Rift is still running the previous version. Select Update in the header to try again.'
	String get installationFailedDescription => 'Remote Rift is still running the previous version. Select Update in the header to try again.';
}

// Path: tray
class Translations$tray$en {
	Translations$tray$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Open'
	String get openLabel => 'Open';

	/// en: 'Quit'
	String get quitLabel => 'Quit';
}

// Path: service
class Translations$service$en {
	Translations$service$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Service status'
	String get statusEyebrow => 'Service status';

	/// en: 'Starting...'
	String get startingTitle => 'Starting...';

	/// en: 'Initializing application components'
	String get startingDescription => 'Initializing application components';

	/// en: 'Startup failed'
	String get errorTitle => 'Startup failed';

	/// en: 'The application couldn't start. This may be due to a missing network connection or another temporary issue.'
	String get errorUnknownDescription => 'The application couldn\'t start. This may be due to a missing network connection or another temporary issue.';

	/// en: 'Restart'
	String get errorRetry => 'Restart';
}

// Path: connection
class Translations$connection$en {
	Translations$connection$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'League client'
	String get statusEyebrow => 'League client';

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

// Path: settings
class Translations$settings$en {
	Translations$settings$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Close settings'
	String get close => 'Close settings';

	late final Translations$settings$lockfile$en lockfile = Translations$settings$lockfile$en._(_root);
}

// Path: gameError
class Translations$gameError$en {
	Translations$gameError$en._(this._root);

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

// Path: mcp
class Translations$mcp$en {
	Translations$mcp$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'MCP server'
	String get title => 'MCP server';

	/// en: 'Connect an AI host'
	String get connectTitle => 'Connect an AI host';

	/// en: 'For AI hosts to access game state and League actions.'
	String get description => 'For AI hosts to access game state and League actions.';

	/// en: 'Runs locally'
	String get localOnly => 'Runs locally';

	/// en: 'Start server'
	String get enable => 'Start server';

	/// en: 'Stop server'
	String get disable => 'Stop server';

	/// en: 'Reset access'
	String get reset => 'Reset access';

	/// en: 'Resetting MCP server access...'
	String get resetting => 'Resetting MCP server access...';

	/// en: 'Starting MCP server...'
	String get starting => 'Starting MCP server...';

	/// en: 'MCP server is active'
	String get running => 'MCP server is active';

	/// en: 'Couldn't start the server.'
	String get startError => 'Couldn\'t start the server.';

	/// en: 'Couldn't reset access.'
	String get resetError => 'Couldn\'t reset access.';

	/// en: 'Couldn't stop the server.'
	String get stopError => 'Couldn\'t stop the server.';

	/// en: 'Host configuration'
	String get configuration => 'Host configuration';

	/// en: 'Paste this into your AI host to connect it to Remote Rift and your game client.'
	String get configurationDescription => 'Paste this into your AI host to connect it to Remote Rift and your game client.';

	/// en: 'Copy configuration'
	String get copy => 'Copy configuration';

	/// en: 'Configuration copied'
	String get copied => 'Configuration copied';
}

// Path: settings.lockfile
class Translations$settings$lockfile$en {
	Translations$settings$lockfile$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Lockfile location'
	String get title => 'Lockfile location';

	/// en: 'Default location'
	String get defaultLocation => 'Default location';

	/// en: 'Custom location'
	String get customLocation => 'Custom location';

	/// en: 'Using the standard League Client location.'
	String get defaultPath => 'Using the standard League Client location.';

	/// en: 'Using a custom League Client lockfile.'
	String get customPath => 'Using a custom League Client lockfile.';

	/// en: 'Choose custom location'
	String get choose => 'Choose custom location';

	/// en: 'Change location'
	String get change => 'Change location';

	/// en: 'Reset to default'
	String get reset => 'Reset to default';

	/// en: 'Choose a valid League Client lockfile.'
	String get invalid => 'Choose a valid League Client lockfile.';

	/// en: 'Couldn't save the lockfile location. Please try again.'
	String get persistenceFailed => 'Couldn\'t save the lockfile location. Please try again.';
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
			'update.statusEyebrow' => 'Application update',
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
			'update.installedTitle' => 'Update complete',
			'update.installedDescription' => 'The latest version is ready to use.',
			'update.installationFailedTitle' => 'Update failed',
			'update.installationFailedDescription' => 'Remote Rift is still running the previous version. Select Update in the header to try again.',
			'tray.openLabel' => 'Open',
			'tray.quitLabel' => 'Quit',
			'service.statusEyebrow' => 'Service status',
			'service.startingTitle' => 'Starting...',
			'service.startingDescription' => 'Initializing application components',
			'service.errorTitle' => 'Startup failed',
			'service.errorUnknownDescription' => 'The application couldn\'t start. This may be due to a missing network connection or another temporary issue.',
			'service.errorRetry' => 'Restart',
			'connection.statusEyebrow' => 'League client',
			'connection.connectingTitle' => 'Connecting...',
			'connection.connectingDescription' => 'Initializing communication with the game client.',
			'connection.connectedTitle' => 'Connected',
			'connection.connectedDescription' => 'Successfully connected to the game client.',
			'connection.errorTitle' => 'Connection error',
			'connection.errorDescription' => 'Unable to connect to the game client.',
			'connection.errorRetry' => 'Reconnect',
			'settings.title' => 'Settings',
			'settings.close' => 'Close settings',
			'settings.lockfile.title' => 'Lockfile location',
			'settings.lockfile.defaultLocation' => 'Default location',
			'settings.lockfile.customLocation' => 'Custom location',
			'settings.lockfile.defaultPath' => 'Using the standard League Client location.',
			'settings.lockfile.customPath' => 'Using a custom League Client lockfile.',
			'settings.lockfile.choose' => 'Choose custom location',
			'settings.lockfile.change' => 'Change location',
			'settings.lockfile.reset' => 'Reset to default',
			'settings.lockfile.invalid' => 'Choose a valid League Client lockfile.',
			'settings.lockfile.persistenceFailed' => 'Couldn\'t save the lockfile location. Please try again.',
			'gameError.unableToConnectTitle' => 'Unable to connect',
			'gameError.unknownTitle' => 'Unknown game state',
			'gameError.unableToConnectDescription' => 'The game client could not be reached. Make sure that it is running to interact with the game.',
			'gameError.unknownDescription' => 'The game\'s state could not be accessed due to an unexpected error.',
			'mcp.title' => 'MCP server',
			'mcp.connectTitle' => 'Connect an AI host',
			'mcp.description' => 'For AI hosts to access game state and League actions.',
			'mcp.localOnly' => 'Runs locally',
			'mcp.enable' => 'Start server',
			'mcp.disable' => 'Stop server',
			'mcp.reset' => 'Reset access',
			'mcp.resetting' => 'Resetting MCP server access...',
			'mcp.starting' => 'Starting MCP server...',
			'mcp.running' => 'MCP server is active',
			'mcp.startError' => 'Couldn\'t start the server.',
			'mcp.resetError' => 'Couldn\'t reset access.',
			'mcp.stopError' => 'Couldn\'t stop the server.',
			'mcp.configuration' => 'Host configuration',
			'mcp.configurationDescription' => 'Paste this into your AI host to connect it to Remote Rift and your game client.',
			'mcp.copy' => 'Copy configuration',
			'mcp.copied' => 'Configuration copied',
			_ => null,
		};
	}
}
