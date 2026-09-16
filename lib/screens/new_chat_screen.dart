import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/new_chat_provider.dart';
import '../viewmodels/new_chat_view_model.dart';

class NewChatScreen extends ConsumerStatefulWidget {
  const NewChatScreen({super.key});

  @override
  ConsumerState<NewChatScreen> createState() =>
      _NewChatScreenState();
}

class _NewChatScreenState
    extends ConsumerState<NewChatScreen> {
  final TextEditingController searchController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(newChatViewModelProvider.notifier)
          .loadUsers();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newChatViewModelProvider);

    final searchText =
    searchController.text.toLowerCase().trim();

    final filteredUsers = state.users.where((user) {
      return user.name.toLowerCase().contains(searchText) ||
          user.username.toLowerCase().contains(searchText);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Новый чат'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Поиск пользователя',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Expanded(
            child: _buildContent(
              state,
              filteredUsers,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
      NewChatState state,
      List users,
      ) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Ошибка загрузки пользователей:\n\n'
                '${state.error}',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (users.isEmpty) {
      return const Center(
        child: Text('Пользователи не найдены'),
      );
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        return ListTile(
          leading: CircleAvatar(
            child: Text(
              user.name.isNotEmpty
                  ? user.name[0].toUpperCase()
                  : '?',
            ),
          ),
          title: Text(user.name),
          subtitle: Text('@${user.username}'),
          trailing: const Icon(
            Icons.chevron_right,
          ),
          onTap: () {
            context.push('/dialog/${user.id}');
          },
        );
      },
    );
  }
}