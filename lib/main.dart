import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_colors.dart';
import 'models/chat.dart';
import 'models/user.dart';
import 'screens/dialog_screen.dart';
import 'screens/login_screen.dart';
import 'screens/new_chat_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'data/demo_data.dart';
import 'widgets/avatar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('minichat');

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(
    const ProviderScope(
      child: MiniChatApp(),
    ),
  );
}

/* ============================================================
   ROUTER
   ============================================================ */

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) =>
        const LoginScreen(),
      ),

      GoRoute(
        path: '/register',
        builder: (context, state) =>
        const RegisterScreen(),
      ),

      GoRoute(
        path: '/chats',
        builder: (context, state) =>
        const ChatsScreen(),
      ),

      GoRoute(
        path: '/dialog/:id',
        builder: (context, state) {
          final id = int.parse(
            state.pathParameters['id']!,
          );

          return DialogScreen(
            chatId: id,
          );
        },
      ),

      GoRoute(
        path: '/new-chat',
        builder: (context, state) =>
        const NewChatScreen(),
      ),

      GoRoute(
        path: '/profile',
        builder: (context, state) =>
        const ProfileScreen(),
      ),
    ],
  );
});

/* ============================================================
   APP
   ============================================================ */

class MiniChatApp extends ConsumerWidget {
  const MiniChatApp({super.key});

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'MiniChat',
      debugShowCheckedModeBanner: false,
      routerConfig: router,

      theme: ThemeData(
        useMaterial3: true,

        scaffoldBackgroundColor:
        AppColors.background,

        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),

        fontFamily: '.SF Pro Text',

        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: AppColors.textPrimary,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textPrimary,
          ),
        ),

        inputDecorationTheme:
        const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

/* ============================================================
   BASIC UI COMPONENTS
   ============================================================ */

class Badge extends StatelessWidget {
  final int value;

  const Badge({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    if (value <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: const BoxConstraints(
        minWidth: 22,
        minHeight: 22,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$value',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
        ),
        suffixIcon: suffixIcon,
        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;

  const SearchField({
    super.key,
    this.hint = 'Поиск',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.textSecondary,
        ),
        contentPadding:
        const EdgeInsets.symmetric(
          vertical: 12,
        ),
      ),
    );
  }
}

class NavigationHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  const NavigationHeader({
    super.key,
    required this.title,
    this.onBack,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
              ),
            ),

          if (onBack == null)
            const SizedBox(width: 8),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}

/* ============================================================
   CHAT TILE
   ============================================================ */

class ChatTile extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;

  const ChatTile({
    super.key,
    required this.chat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(
          children: [
            Avatar(
              initials: chat.initials,
              color: chat.color,
              size: 54,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),

                      Text(
                        chat.time,
                        style: const TextStyle(
                          fontSize: 12,
                          color:
                          AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color:
                      AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Badge(value: chat.unread),
          ],
        ),
      ),
    );
  }
}

/* ============================================================
   USER TILE
   ============================================================ */

class UserTile extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap;

  const UserTile({
    super.key,
    required this.contact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(
          children: [
            Avatar(
              initials: contact.initials,
              color: contact.color,
              size: 52,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    contact.username,
                    style: const TextStyle(
                      fontSize: 14,
                      color:
                      AppColors.textSecondary,
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

/* ============================================================
   CHATS
   ============================================================ */

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() =>
      _ChatsScreenState();
}

class _ChatsScreenState
    extends State<ChatsScreen> {
  String search = '';

  List<Chat> chats =
  List<Chat>.from(demoChats);

  @override
  void initState() {
    super.initState();

    _loadLastMessages();
  }

  Future<void> _loadLastMessages() async {
    final box = Hive.box('minichat');

    final updatedChats = <Chat>[];

    for (final chat in demoChats) {
      final value =
      box.get('messages_${chat.id}');

      if (value == null) {
        updatedChats.add(chat);
        continue;
      }

      try {
        final List<dynamic> data =
        jsonDecode(value);

        if (data.isEmpty) {
          updatedChats.add(chat);
          continue;
        }

        final lastMessage =
        Map<String, dynamic>.from(
          data.last,
        );

        final text =
            lastMessage['text']?.toString() ??
                chat.lastMessage;

        final timeValue =
        lastMessage['time']?.toString();

        String time = chat.time;

        if (timeValue != null) {
          final parsedTime =
          DateTime.tryParse(timeValue);

          if (parsedTime != null) {
            time =
            '${parsedTime.hour.toString().padLeft(2, '0')}:'
                '${parsedTime.minute.toString().padLeft(2, '0')}';
          } else {
            time = timeValue;
          }
        }

        updatedChats.add(
          Chat(
            id: chat.id,
            name: chat.name,
            initials: chat.initials,
            color: chat.color,
            lastMessage: text,
            time: time,
            unread: chat.unread,
          ),
        );
      } catch (_) {
        updatedChats.add(chat);
      }
    }

    if (!mounted) return;

    setState(() {
      chats = updatedChats;
    });
  }

  List<Chat> get filteredChats {
    if (search.trim().isEmpty) {
      return chats;
    }

    return chats
        .where(
          (chat) => chat.name
          .toLowerCase()
          .contains(
        search.toLowerCase(),
      ),
    )
        .toList();
  }

  Future<void> _openDialog(
      int chatId,
      ) async {
    await context.push(
      '/dialog/$chatId',
    );

    await _loadLastMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
      FloatingActionButton(
        backgroundColor:
        AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 3,
        onPressed: () {
          context.push('/new-chat');
        },
        child: const Icon(Icons.edit),
      ),

      body: SafeArea(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),

              NavigationHeader(
                title: 'Чаты',
                actions: [
                  IconButton(
                    onPressed: () {
                      context.push(
                        '/profile',
                      );
                    },
                    icon: const Avatar(
                      initials: 'АП',
                      color:
                      AppColors.primary,
                      size: 38,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              SearchField(
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                },
              ),

              const SizedBox(height: 12),

              Expanded(
                child:
                ListView.separated(
                  itemCount:
                  filteredChats.length,
                  separatorBuilder:
                      (_, __) =>
                  const Divider(
                    height: 1,
                    color:
                    AppColors.divider,
                  ),
                  itemBuilder:
                      (context, index) {
                    final chat =
                    filteredChats[index];

                    return ChatTile(
                      chat: chat,
                      onTap: () {
                        _openDialog(
                          chat.id,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}