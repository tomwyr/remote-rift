Object? normalizePositionPreference(Map json, String key) {
  final value = json[key];
  return value == null || value == '' ? 'UNSELECTED' : value;
}

Object? normalizeAssignedPosition(Map json, String key) {
  final value = json[key];
  return value == '' ? null : value;
}
