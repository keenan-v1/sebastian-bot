import 'dart:io';

import 'package:logging/logging.dart';
import 'package:yaml/yaml.dart';

final _log = Logger('config');

enum Environment { production, development }

class ConfigOptionNotSetException implements Exception {
  final String message;
  ConfigOptionNotSetException(this.message);
}

class Config {
  static final Config _singleton = Config._internal();
  final String _configPath =
      Platform.environment['CONFIG_PATH'] ?? 'config.yaml';
  YamlMap? _doc;

  factory Config() {
    return _singleton;
  }

  Config._internal() {
    final file = File(_configPath);
    _doc = loadYaml(file.readAsStringSync());
    _log.info(
        'Loaded config from $_configPath. Set the CONFIG_PATH environment variable to change this.');
  }

  dynamic _require(String key) {
    final value = _doc?[key];
    if (value == null) {
      throw ConfigOptionNotSetException(
          'Config option `$key` is not set in `$_configPath`.');
    }
    return value;
  }

  String get botToken => _require('bot_token');
  String get channelId => '${_require('channel_id')}';
  Environment get environment =>
      Environment.values.firstWhere((e) => e.toString() == _doc?['environment'],
          orElse: () => Environment.production);
  bool get ansiColorDisabled =>
      _doc?['ansi_color_disabled'] == 'true' ||
      environment == Environment.production;
  Level get logLevel =>
      Level.LEVELS.firstWhere((l) => l.name == _doc?['log_level'],
          orElse: () => Level.INFO);
}
