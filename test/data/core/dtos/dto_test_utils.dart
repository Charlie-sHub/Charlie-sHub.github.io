import 'dart:convert';
import 'dart:io';

/// Loads and deep-copies a JSON fixture from the repository.
Map<String, dynamic> loadJsonFixture(String relativePath) {
  final jsonString = File(relativePath).readAsStringSync();

  return deepCopyJsonMap(
    jsonDecode(jsonString) as Map<String, dynamic>,
  );
}

/// Creates a mutable deep copy of a decoded JSON map.
Map<String, dynamic> deepCopyJsonMap(Map<String, dynamic> source) =>
    jsonDecode(jsonEncode(source)) as Map<String, dynamic>;
