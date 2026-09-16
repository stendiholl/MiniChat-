import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_colors.dart';
import '../data/demo_data.dart';
import '../models/chat.dart';
import '../providers/messages_provider.dart';
import '../widgets/avatar.dart';
import '../widgets/message_bubble.dart';

class DialogScreen extends ConsumerStatefulWidget {
  final int chatId;

  const DialogScreen({
    super.key,
    required this.chatId,
  });

  @override
  ConsumerState<DialogScreen> createState() =>
      _DialogScreenState();
}

class _DialogScreenState
    extends ConsumerState<DialogScreen> {
  final controller = TextEditingController();

  final scrollController = ScrollController();

  late Chat chat;

  @override
  void initState() {
    super.initState();

    chat = demoChats.firstWhere(
          (element) => element.id == widget.chatId,
      orElse: () => demoChats.first,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> send() async {
    final text = controller.text;

    if (text.trim().isEmpty) return;

    controller.clear();

    await ref
        .read(
      messagesProvider(widget.chatId).notifier,
    )
        .sendMessage(text);

    if (scrollController.hasClients) {
      await Future.delayed(
        const Duration(milliseconds: 100),
      );

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(
      messagesProvider(widget.chatId),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                    ),
                  ),

                  Avatar(
                    initials: chat.initials,
                    color: chat.color,
                    size: 42,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'в сети',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_horiz,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(
              height: 1,
              color: AppColors.divider,
            ),

            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessageBubble(
                    message: messages[index],
                  );
                },
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(
                12,
                8,
                12,
                10,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: AppColors.divider,
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add_circle_outline,
                    ),
                    color: AppColors.textSecondary,
                  ),

                  Expanded(
                    child: TextField(
                      controller: controller,
                      textInputAction:
                      TextInputAction.send,
                      onSubmitted: (_) => send(),
                      decoration: InputDecoration(
                        hintText: 'Сообщение...',
                        filled: true,
                        fillColor:
                        AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(22),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 6),

                  IconButton(
                    onPressed: send,
                    style: IconButton.styleFrom(
                      backgroundColor:
                      AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(
                      Icons.arrow_upward,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}