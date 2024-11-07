import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/custom_input_box.dart';
import 'package:fundflow/core/widgets/custom_password_input_box.dart';
import 'package:fundflow/core/widgets/custom_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Listen to authentication state changes
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigate to home page
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is AuthenticationFailure) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthenticationLoading) {
            // Show loading indicator
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                // Circular avatar placeholder
                const CircleAvatar(
                  radius: 120,
                  backgroundColor: Color(0xFF41486D),
                ),
                const SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'เข้าสู่ระบบ',
                    style: TextStyle(
                      color: Color(0xFF41486D),
                      fontSize: 34, // Font size
                      fontWeight: FontWeight.bold, // Bold text
                      //letterSpacing: 2.0, // Spacing between letters
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 12),

                      CustomInputBox(
                        labelText: 'ชื่อบัญชีผู้ใช้',
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color(0xFFD0D0D0),
                        ),
                        controller: _usernameController,
                      ),

                      const SizedBox(height: 12),

                      CustomPasswordInputBox(
                          labelText: 'รหัสผ่าน',
                          focusNode: FocusNode(),
                          controller: _passwordController),

                      //const SizedBox(height: 5),
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/forget1');
                          },
                          child: const Text(
                            'ลืมรหัสผ่านใช่ไหม?',
                            style: TextStyle(
                                fontSize: 12, // Font size
                                color: Color(0xFFFF9595)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      CustomButton(
                        text: 'เข้าสู่ระบบ',
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Trigger login event
                            context.read<AuthenticationBloc>().add(
                                  AuthenticationLoginRequested(
                                    email: _usernameController.text,
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
    );
  }
}
