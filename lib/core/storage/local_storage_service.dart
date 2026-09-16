import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../data/demo_data.dart';
import '../../models/message.dart';

class LocalStorageService {
  final Box box = Hive.box('minichat');

  Future<void> saveMessages(
      int chatId,
      List<Message> messages,
      ) async {
    final data = messages
        .map((message) => message.toJson())
        .toList();

    await box.put(
      'messages_$chatId',
      jsonEncode(data),
    );
  }

  List<Message> loadMessages(int chatId) {
    final value = box.get('messages_$chatId');

    if (value == null) {
      return demoMessages
          .where((message) => message.chatId == chatId)
          .toList();
    }

    try {
      final decoded = jsonDecode(value);

      if (decoded is! List) {
        return [];
      }

      return decoded
          .map(
            (item) => Message.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList();
    } catch (_) {
      return demoMessages
          .where((message) => message.chatId == chatId)
          .toList();
    }
  }

  Future<void> setLoggedIn(bool value) async {
    await box.put('logged_in', value);
  }

  bool get isLoggedIn {
    return box.get(
      'logged_in',
      defaultValue: false,
    );
  }
}