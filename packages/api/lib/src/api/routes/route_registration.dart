part of 'router.dart';

extension on ConnectorRoutes {
  void _get(String route, JsonRequestHandler handler) {
    _router.getJson(route, _withFailureReporting(route, handler));
  }

  void _post(String route, JsonRequestHandler handler) {
    _router.postJson(route, _withFailureReporting(route, handler));
  }

  void _mountWs(String route, WebSocketHandler handler) {
    _router.mountWs(
      route,
      handler,
      middleware: _failureMiddleware(route),
    );
  }

  Middleware? _failureMiddleware(String operation) {
    if (_onFailure == null) return null;
    return (handler) => _withFailureReporting(operation, handler);
  }

  FutureOr<T> Function(Request) _withFailureReporting<T extends Response>(
    String operation,
    FutureOr<T> Function(Request) handler,
  ) {
    final observer = _onFailure;
    if (observer == null) return handler;

    void reportFailure(int statusCode, Object? error) {
      try {
        observer(operation, statusCode, error);
      } catch (_) {
        // Diagnostics must leave the connector response intact.
      }
    }

    return (request) async {
      final T response;
      try {
        response = await handler(request);
      } on HijackException {
        rethrow;
      } catch (error) {
        reportFailure(500, error);
        rethrow;
      }

      if (response.statusCode >= 400) {
        reportFailure(response.statusCode, null);
      }
      return response;
    };
  }
}
