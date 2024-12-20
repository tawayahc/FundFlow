import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/custom_input_box.dart';
import 'package:fundflow/core/widgets/custom_modal.dart';
import 'package:fundflow/core/widgets/custom_password_input_box.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/utils/validator.dart';

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
  bool _isDialogShowing = false;

  void _showModal(BuildContext context, String text) {
    if (_isDialogShowing) {
      return;
    }

    _isDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.1),
      builder: (BuildContext context) {
        return CustomModal(text: text);
      },
    ).then((_) {
      _isDialogShowing = false;
    });
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
            } else if (state is AuthenticationFailure) {
              _showModal(context, 'มีบัญชีนี้อยู่แล้ว');
            }
          },
          builder: (context, state) {
            if (state is AuthenticationLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.only(top: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 70),

                    // Change logo based on keyboard visibility
                    Align(
                      alignment: isKeyboardVisible
                          ? Alignment.centerLeft
                          : Alignment.center,
                      child: Image.asset(
                        isKeyboardVisible
                            ? 'assets/logo.png'
                            : 'assets/logo_FundFlow.png',
                        width: isKeyboardVisible ? 180 : 240,
                        height: isKeyboardVisible ? 180 : 240,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'สมัครสมาชิก',
                        style: TextStyle(
                          fontSize: 34,
                          color: AppColors.darkBlue,
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
                        color: AppColors.icon,
                      ),
                      controller: _usernameController,
                    ),

                    const SizedBox(height: 12),

                    // Input for Email
                    CustomInputBox(
                      labelText: 'อีเมล',
                      prefixIcon: const Icon(
                        Icons.email,
                        color: AppColors.icon,
                      ),
                      controller: _emailController,
                    ),

                    const SizedBox(height: 12),

                    // Input for Password
                    CustomPasswordInputBox(
                      labelText: 'รหัสผ่าน',
                      controller: _passwordController,
                      validator: (value) {
                        String result = validatePassword(value ?? '');
                        return result.isEmpty ? null : result;
                      },
                    ),

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

                    // Login prompt
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          text: 'มีบัญชีอยู่แล้วใช่ไหม? ',
                          style: TextStyle(
                            color: AppColors.lightBlack,
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
      ),
    );
  }
}
