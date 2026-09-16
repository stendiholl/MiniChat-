import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/storage/local_storage_service.dart';
import '../models/message.dart';

class MessagesNotifier extends StateNotifier<List<Message>> {
  final int chatId;
  final LocalStorageService storage;

  MessagesNotifier(
      this.chatId,
      this.storage,
      ) : super(storage.loadMessages(chatId));

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch,
      chatId: chatId,
      text: text.trim(),
      time: DateTime.now(),
      isMine: true,
    );

    state = [...state, message];

    await storage.saveMessages(chatId, state);
  }
}

final storageProvider = Provider<LocalStorageService>(
      (ref) => LocalStorageService(),
);

final messagesProvider = StateNotifierProvider.family<
    MessagesNotifier,
    List<Message>,
    int>(
      (ref, chatId) {
    return MessagesNotifier(
      chatId,
      ref.read(storageProvider),
    );
  },
);