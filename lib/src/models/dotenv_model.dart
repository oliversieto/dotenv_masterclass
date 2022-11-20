import 'dart:io';

import 'package:dotenv_masterclass/src/errors/not_found_error.dart';
import 'package:path/path.dart';

import '../errors/not_initializer_error.dart';

class DotEnvModel {
  String filePath;
  final Map<String, dynamic> _envVars = {};
  DotEnvModel({required this.filePath});

  bool isValidExtensionFile() {
    final extensionFile = extension(filePath);

    return extensionFile.isEmpty;
  }

  Future<void> load() async {
    if (!isValidExtensionFile()) {
      throw const FormatException('Extension should be .env');
    }
    try {
      File file = File(filePath);

      var lines = await file.readAsLines();

      for (var line in lines) {
        var lineWithoutComment = _removeComments(line);
        var keyAndValue = lineWithoutComment?.trim().split('=');
        if (keyAndValue != null) {
          var key = keyAndValue.elementAt(0);
          var value = keyAndValue.elementAt(1);
          _envVars[key] = value;
        }
      }
    } on FileSystemException catch (_) {
      throw const FileSystemException('File Not Found');
    }
  }

  String? _removeComments(String line) {
    var lineRemovedComment = line.replaceAll(RegExp(r'\#.*'), '');
    return lineRemovedComment.isEmpty ? null : lineRemovedComment;
  }

  String getValue(String key) {
    if (_envVars.isEmpty) {
      throw NotInitializedError('Should load before calls get value');
    }

    if (_envVars[key] == null) {
      throw NotFoundError('$key variable not found.');
    }

    return _envVars[key];
  }

  int? getValueAsInteger(String key) {
    var value = getValue(key);
    return int.tryParse(value);
  }

  double? getValueAsDouble(String key) {
    var value = getValue(key);
    return double.tryParse(value);
  }

  bool getValueAsBool(String key) {
    var value = getValue(key);
    return value.toLowerCase() == 'true';
  }
}
