import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import '../core/storage/local_storage_service.dart';
import '../core/constants/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final emailController =
  TextEditingController();

  final passwordController =
  TextEditingController();

  bool obscure = true;
  bool showErrors = false;

  String? emailError;
  String? passwordError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
      return 'Пароль должен содержать минимум 8 символов';
    }

    return null;
  }

  void validateFields() {
    setState(() {
      emailError =
          validateEmail(emailController.text);

      passwordError =
          validatePassword(passwordController.text);
    });
  }

  void onFieldChanged() {
    if (!showErrors) return;

    validateFields();
  }

  Future<void> login() async {
    setState(() {
      showErrors = true;
    });

    validateFields();

    final hasErrors =
        emailError != null ||
            passwordError != null;

    if (hasErrors) {
      return;
    }

    await LocalStorageService()
        .setLoggedIn(true);

    if (!mounted) return;

    context.go('/chats');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius:
                    BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.chat_bubble_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'MiniChat',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Общайтесь просто и удобно',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 42),

                _buildField(
                  controller: emailController,
                  hint: 'Email или имя пользователя',
                  keyboardType:
                  TextInputType.emailAddress,
                  errorText:
                  showErrors ? emailError : null,
                  onChanged: (_) =>
                      onFieldChanged(),
                ),

                const SizedBox(height: 14),

                _buildField(
                  controller: passwordController,
                  hint: 'Пароль',
                  obscureText: obscure,
                  errorText:
                  showErrors ? passwordError : null,
                  onChanged: (_) =>
                      onFieldChanged(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color:
                      AppColors.textSecondary,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Align(
                  alignment:
                  Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Забыли пароль?',
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                PrimaryButton(
                  text: 'Войти',
                  onPressed: login,
                ),

                const SizedBox(height: 22),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Нет аккаунта? ',
                      style: TextStyle(
                        color:
                        AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.push('/register');
                      },
                      child: const Text(
                        'Регистрация',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
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
    Widget? suffixIcon,
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
          suffixIcon: suffixIcon,
          onChanged: onChanged,
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