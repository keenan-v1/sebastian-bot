import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:logging/logging.dart';

import '../config/config.dart';

AnsiPen _getColorForLevel(Level level) {
  switch (level) {
    case Level.FINEST:
    case Level.FINER:
    case Level.FINE:
      return AnsiPen()..blue();
    case Level.INFO:
      return AnsiPen()..green();
    case Level.WARNING:
      return AnsiPen()..yellow();
    case Level.SEVERE:
      return AnsiPen()..red();
    case Level.SHOUT:
      return AnsiPen()
        ..magenta(bold: true)
        ..white(bg: true);
    default:
      return AnsiPen()..white(bold: true);
  }
}

initLogging() {
  final config = Config();
  ansiColorDisabled = config.ansiColorDisabled;
  Logger.root.level = config.logLevel;
  Logger.root.onRecord.listen((LogRecord rec) {
    final l = _getColorForLevel(rec.level);
    final sep = AnsiPen()..yellow(bold: true);
    final name = AnsiPen()..white(bold: true);
    final time = AnsiPen()..white();
    final msg = AnsiPen()..white();
    final message = '[${l(rec.level.name)}] ${time(rec.time)} ${name(rec.loggerName)} ${sep('::')} ${msg(rec.message)}\n';
    if (rec.level >= Level.SEVERE) {
      stderr.write(message);
    } else {
      stdout.write(message);
    }
  });
}
