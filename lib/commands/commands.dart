import 'package:logging/logging.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';

import '../config/config.dart';

final log = Logger('commands');
typedef TelegramCommand = void Function(TeleDartMessage message);
typedef Command = TelegramCommand Function(TeleDart teledart);

void registerCommands(TeleDart teledart) {
  teledart.onCommand('start').listen(start(teledart));
  teledart.onCommand('share').listen(share(teledart));
}

TelegramCommand start(TeleDart _) => (message) =>
    message.reply('I can help you share music! Start by typing /share.');

TelegramCommand share(TeleDart teledart) => (message) {
      final config = Config();
      log.fine('Received /share command from @${message.from?.username}');
      log.fine('Message: ${message.text}');
      if (!RegExp(r'^\/share\s.*$').hasMatch(message.text!)) {
        // Ignore messages that don't start with /share
        log.fine('Ignoring message that does not start with /share');
        return;
      }
      if (message.from?.firstName == 'Telegram' || message.viaBot != null) {
        // Ignore messages from Telegram or bots
        log.fine(
            "Ignoring message from ${message.from?.firstName ?? 'unknown'} (@${message.from?.username ?? 'unknown'})");
        return;
      }
      if (message.text == null) {
        message.reply('Please send a message with a link to a song.');
        return;
      }
      final text =
          '${message.from?.firstName ?? 'Something'} ${message.from?.lastName ?? 'Went Wrong'} shared a song: ${message.text?.substring(7)}';
      log.info('Message from @${message.from?.username}: $text');
      if (message.chat.type != 'private') {
        teledart.deleteMessage(message.chat.id, message.messageId);
      }
      teledart.sendMessage(config.channelId, text).onError((error, stackTrace) {
        log.severe(
            'Error sending message to channel: $error', error, stackTrace);
        return message.reply('Something went wrong. Please try again later.');
      });
    };