part of 'mcp_tools.dart';

typedef McpToolCallHandler = Future<Map<String, dynamic>> Function(Map<String, dynamic> args);

extension on McpServer {
  void register(
    McpToolCallHandler handler, {
    required String name,
    required String description,
    Map<String, JsonSchema> properties = const {},
  }) {
    registerTool(
      name,
      description: description,
      inputSchema: JsonSchema.object(properties: properties, required: properties.keys.toList()),
      callback: (args, _) async => await _call(handler, args),
    );
  }

  Future<CallToolResult> _call(McpToolCallHandler handler, Map<String, dynamic> args) async {
    try {
      return .fromStructuredContent(await handler(args));
    } on RemoteRiftStateError catch (error) {
      return _error(error.mcpMessage);
    } on ArgumentError catch (error) {
      return _error(error.message?.toString() ?? 'Invalid tool arguments.');
    }
  }

  CallToolResult _error(String message) {
    return CallToolResult(content: [TextContent(text: message)], isError: true);
  }

  Map<String, dynamic> completion(String action) {
    return {'action': action, 'completed': true};
  }
}

extension on RemoteRiftStateError {
  String get mcpMessage => switch (this) {
    .notPreGame => 'Queues are available only before a lobby is created.',
    .notIdleState => 'This action requires an idle lobby.',
    .notSearchingState => 'This action requires active matchmaking.',
    .notPendingState => 'This action requires a pending ready check.',
    .notChampionSelect => 'This action requires champion select.',
    .championSelectUnavailable => 'Champion select data is unavailable.',
    .championSelectActionUnavailable => 'This champion select action is unavailable.',
    .championSelectActionRejected => 'The champion select action was rejected.',
    .rolePreferencesUnavailable => 'Role preferences are unavailable in this lobby.',
    .invalidRolePreferences => 'Primary and secondary roles must differ.',
  };
}

extension on Map<String, dynamic> {
  int intValue(String name) {
    if (this[name] case int value) return value;
    throw ArgumentError.value(this[name], name, 'A whole number is required.');
  }

  String stringValue(String name) {
    if (this[name] case String value) return value;
    throw ArgumentError.value(this[name], name, 'A string is required.');
  }
}
