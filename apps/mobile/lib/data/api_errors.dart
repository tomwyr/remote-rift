sealed class RemoteRiftApiError implements Exception;

class ApiAddressNotSet extends RemoteRiftApiError;

class ApiConnectionTimeout extends RemoteRiftApiError;

class ApiRequestError(final int statusCode) extends RemoteRiftApiError;

class ApiTransportError extends RemoteRiftApiError;
