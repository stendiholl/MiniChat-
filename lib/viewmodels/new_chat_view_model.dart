import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../repositories/user_repository.dart';

class NewChatState {
  final List<User> users;
  final bool isLoading;
  final String? error;

  const NewChatState({
    this.users = const [],
    this.isLoading = false,
    this.error,
  });
}

class NewChatViewModel extends StateNotifier<NewChatState> {
  final UserRepository repository;

  NewChatViewModel(this.repository)
      : super(const NewChatState());

  Future<void> loadUsers() async {
    state = NewChatState(
      users: state.users,
      isLoading: true,
    );

    try {
      final users = await repository.getUsers();

      state = NewChatState(
        users: users,
        isLoading: false,
      );
    } catch (e) {
      state = NewChatState(
        users: state.users,
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}