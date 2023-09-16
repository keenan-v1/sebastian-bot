import 'dart:io';

import 'package:logging/logging.dart';
import 'package:sebastian_bot/commands/commands.dart';
import 'package:sebastian_bot/config/config.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

final log = Logger('sebastian_bot');

void runBot() async {
  final config = Config();
  final telegram = Telegram(config.botToken);
  final username = (await telegram.getMe()).username;
  final fetcher = LongPolling(telegram, timeout: 60, limit: 1);
  final teledart = TeleDart(config.botToken, Event(username!), fetcher: fetcher);

  log.info('Bot username: @$username');

  ProcessSignal.sigint.watch().listen((signal) {
    log.info('Received signal $signal. Exiting.');
    teledart.stop();
    exit(0);
  });

  teledart.start();
  registerCommands(teledart);
}
