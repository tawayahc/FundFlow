import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/core/widgets/custom_input_box.dart';
import 'package:fundflow/core/widgets/custom_password_input_box.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/utils/validator.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for text fields
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  // Key for form validation
  final _formKey = GlobalKey<FormState>();

  final storage = const FlutterSecureStorage();

  // to get token from local storage
  Future<void> getToken() async {
    var value = await storage.read(key: 'token');
    logger.d(value);
  }

  @override
  Widget build(BuildContext context) {
    // Check if the keyboard is visible
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return GlobalPadding(
      child: Scaffold(
        body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is Authenticated) {
              Navigator.of(context).pushReplacementNamed('/home');
              logger.d('Authenticated');
            } else if (state is AuthenticationFailure) {
              logger.e('AuthenticationFailure: ${state.error}');
            } else {
              logger.d('AuthenticationBloc state: Unknown $state');
            }
          },
          builder: (context, state) {
            if (state is AuthenticationLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 70),

                  // Adjust logo image based on keyboard visibility
                  Align(
                    alignment: isKeyboardVisible
                        ? Alignment.centerLeft
                        : Alignment.center,
                    child: Image.asset(
                      isKeyboardVisible
                          ? 'assets/logo.png'
                          : 'assets/logo_FundFlow.png',
                      width: isKeyboardVisible
                          ? 180
                          : 240, // Smaller when keyboard is visible
                      height: isKeyboardVisible ? 180 : 240,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(
                        color: Color(0xFF41486D),
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomInputBox(
                          labelText: 'ชื่อบัญชีผู้ใช้',
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Color(0xFFD0D0D0),
                          ),
                          controller: _usernameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกชื่อบัญชีผู้ใช้';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomPasswordInputBox(
                          labelText: 'รหัสผ่าน',
                          focusNode: FocusNode(),
                          controller: _passwordController,
                          validator: (value) {
                            String result = validatePassword(value ?? '');
                            return result.isEmpty ? null : result;
                          },
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.topRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/forget1');
                                },
                                child: const Text(
                                  'ลืมรหัสผ่านใช่ไหม?',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFFF9595),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (state is AuthenticationFailure)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              state.error,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        CustomButton(
                          text: 'เข้าสู่ระบบ',
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<AuthenticationBloc>().add(
                                    AuthenticationLoginRequested(
                                      username: _usernameController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                            }
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'มีบัญชีแล้วหรือยัง?',
                              style: TextStyle(
                                color: Color(0xFF5A5A5A),
                                fontSize: 12,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/register');
                              },
                              child: const Text(
                                'สมัครสมาชิก',
                                style: TextStyle(
                                  color: Color(0xFFFF9595),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
