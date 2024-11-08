import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/core/widgets/custom_input_box.dart';
import 'package:fundflow/core/widgets/custom_password_input_box.dart';
import 'package:fundflow/core/widgets/custom_button.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();

  // Key for form validation
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  // Circular avatar placeholder
                  const CircleAvatar(
                    radius: 120,
                    backgroundColor: Color(0xFF41486D),
                  ),

                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'สมัครสมาชิก',
                      style: TextStyle(
                        fontSize: 34,
                        color: Color(0xFF41486D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Input for Username

                  CustomInputBox(
                    labelText: 'ชื่อบัญชีผู้ใช้',
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Color(0xFFD0D0D0),
                    ),
                    controller: _usernameController,
                  ),

                  const SizedBox(height: 12),
                  // Input for email

                  CustomInputBox(
                    labelText: 'อีเมล',
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Color(0xFFD0D0D0),
                    ),
                    controller: _emailController,
                  ),

                  const SizedBox(height: 12),
                  // Input for Password
                  CustomPasswordInputBox(
                      labelText: 'รหัสผ่าน',
                      focusNode: FocusNode(),
                      controller: _passwordController),

                  const SizedBox(height: 30),
                  // Register button
                  CustomButton(
                    text: 'สมัครสมาชิก',
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Trigger registration event
                        context.read<AuthenticationBloc>().add(
                              AuthenticationRegisterRequested(
                                email: _emailController.text,
                                password: _passwordController.text,
                                username: _usernameController.text,
                              ),
                            );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        text: 'มีบัญชีอยู่แล้วใช่ไหม? ',
                        style: TextStyle(
                          color: Color(0xFF5A5A5A),
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text: 'เข้าสู่ระบบ',
                            style: TextStyle(
                              color: Color(0xFFFF9595),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
