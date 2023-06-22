import 'package:sebastian_bot/logging/logging.dart';
import 'package:sebastian_bot/sebastian_bot.dart' as sebastian_bot;
import 'package:logging/logging.dart';

final _log = Logger('main');

void main(List<String> arguments) {
  initLogging();
  _log.info('Starting bot.');
  sebastian_bot.runBot();
}
