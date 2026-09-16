import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/api_service.dart';
import '../repositories/user_repository.dart';
import '../viewmodels/new_chat_view_model.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(
    ref.watch(apiServiceProvider),
  );
});

final newChatViewModelProvider =
StateNotifierProvider<NewChatViewModel, NewChatState>((ref) {
  return NewChatViewModel(
    ref.watch(userRepositoryProvider),
  );
});