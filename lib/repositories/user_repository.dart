import '../core/network/api_service.dart';
import '../models/user.dart';

class UserRepository {
  final ApiService apiService;

  UserRepository(this.apiService);

  Future<List<User>> getUsers() async {
    final data = await apiService.getUsers();

    return data
        .map((json) => User.fromJson(json))
        .toList();
  }
}