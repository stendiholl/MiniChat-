import 'package:flutter_test/flutter_test.dart';

import 'package:minichat/models/message.dart';

void main() {
  test('Message correctly converts to JSON and back', () {
    final message = Message(
      id: 1,
      chatId: 1,
      text: 'Привет!',
      time: DateTime(2026, 9, 16, 14, 30),
      isMine: true,
    );

    final json = message.toJson();
    final restoredMessage = Message.fromJson(json);

    expect(restoredMessage.id, message.id);
    expect(restoredMessage.chatId, message.chatId);
    expect(restoredMessage.text, message.text);
    expect(restoredMessage.time, message.time);
    expect(restoredMessage.isMine, message.isMine);
  });

  test('Message correctly stores incoming message', () {
    final message = Message(
      id: 2,
      chatId: 1,
      text: 'Ответ',
      time: DateTime(2026, 9, 16, 14, 31),
      isMine: false,
    );

    expect(message.text, 'Ответ');
    expect(message.isMine, false);
  });
}