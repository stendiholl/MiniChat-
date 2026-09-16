import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_colors.dart';
import '../core/storage/local_storage_service.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  String? nameError;
  String? usernameError;
  String? emailError;
  String? passwordError;
  String? repeatPasswordError;

  bool showErrors = false;

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  String? validateName(String value) {
    final name = value.trim();

    if (name.isEmpty) {
      return 'Введите имя';
    }

    if (name.length < 2) {
      return 'Имя должно содержать минимум 2 символа';
    }

    if (name.length > 50) {
      return 'Имя слишком длинное';
    }

    return null;
  }

  String? validateUsername(String value) {
    final username = value.trim();

    if (username.isEmpty) {
      return 'Введите имя пользователя';
    }

    if (username.length < 3) {
      return 'Минимум 3 символа';
    }

    if (username.length > 20) {
      return 'Максимум 20 символов';
    }

    final usernameRegex =
    RegExp(r'^[a-zA-Z0-9_]+$');

    if (!usernameRegex.hasMatch(username)) {
      return 'Используйте латинские буквы, цифры и _';
    }

    return null;
  }

  String? validateEmail(String value) {
    final email = value.trim();

    if (email.isEmpty) {
      return 'Введите email';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Введите корректный email';
    }

    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Введите пароль';
    }

    if (value.length < 8) {
      return 'Минимум 8 символов';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Добавьте хотя бы одну заглавную букву';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Добавьте хотя бы одну строчную букву';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Добавьте хотя бы одну цифру';
    }

    return null;
  }

  String? validateRepeatPassword(String value) {
    if (value.isEmpty) {
      return 'Повторите пароль';
    }

    if (value != passwordController.text) {
      return 'Пароли не совпадают';
    }

    return null;
  }

  void validateFields() {
    setState(() {
      nameError = validateName(nameController.text);
      usernameError =
          validateUsername(usernameController.text);
      emailError =
          validateEmail(emailController.text);
      passwordError =
          validatePassword(passwordController.text);
      repeatPasswordError =
          validateRepeatPassword(
            repeatPasswordController.text,
          );
    });
  }

  Future<void> register() async {
    setState(() {
      showErrors = true;
    });

    validateFields();

    final hasErrors =
        nameError != null ||
            usernameError != null ||
            emailError != null ||
            passwordError != null ||
            repeatPasswordError != null;

    if (hasErrors) {
      return;
    }

    await LocalStorageService().setLoggedIn(true);

    if (!mounted) return;

    context.go('/chats');
  }

  void onFieldChanged() {
    if (!showErrors) return;

    validateFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            24,
            12,
            24,
            30,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.stretch,
            children: [
              IconButton(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.zero,
                onPressed: () => context.pop(),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Создать аккаунт',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Заполните данные для регистрации',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 30),

              _buildField(
                controller: nameController,
                hint: 'Имя',
                errorText:
                showErrors ? nameError : null,
                onChanged: (_) => onFieldChanged(),
              ),

              const SizedBox(height: 12),

              _buildField(
                controller: usernameController,
                hint: 'Имя пользователя',
                errorText:
                showErrors ? usernameError : null,
                onChanged: (_) => onFieldChanged(),
              ),

              const SizedBox(height: 12),

              _buildField(
                controller: emailController,
                hint: 'Email',
                keyboardType:
                TextInputType.emailAddress,
                errorText:
                showErrors ? emailError : null,
                onChanged: (_) => onFieldChanged(),
              ),

              const SizedBox(height: 12),

              _buildField(
                controller: passwordController,
                hint: 'Пароль',
                obscureText: true,
                errorText:
                showErrors ? passwordError : null,
                onChanged: (_) => onFieldChanged(),
              ),

              const SizedBox(height: 12),

              _buildField(
                controller: repeatPasswordController,
                hint: 'Повторите пароль',
                obscureText: true,
                errorText: showErrors
                    ? repeatPasswordError
                    : null,
                onChanged: (_) => onFieldChanged(),
              ),

              const SizedBox(height: 24),

              PrimaryButton(
                text: 'Создать аккаунт',
                onPressed: register,
              ),

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  const Text(
                    'Уже есть аккаунт? ',
                    style: TextStyle(
                      color:
                      AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    child: const Text('Войти'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required String? errorText,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        AppTextField(
          hint: hint,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
        ),

        if (errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding:
            const EdgeInsets.only(left: 4),
            child: Text(
              errorText,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}