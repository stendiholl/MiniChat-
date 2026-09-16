import 'package:dio/dio.dart';

class ApiService {
  final Dio dio;

  ApiService()
      : dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );

  Future<List<dynamic>> getUsers() async {
    final response = await dio.get(
      '/users',
      options: Options(
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    return response.data as List<dynamic>;
  }
}