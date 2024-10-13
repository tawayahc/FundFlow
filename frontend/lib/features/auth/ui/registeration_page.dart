import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

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

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    // Circular avatar placeholder
                    const CircleAvatar(
                      radius: 160,
                      backgroundColor: Color(0xFF41486D),
                    ),

                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'สมัครสมาชิก',
                        style: TextStyle(
                          fontSize: 34,
                          color: Color(0xFF41486D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
// Input for Username
                    Container(
                      height: 40,
                      width: 328,
                child:TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'ชื่อบัญชีผู้ใช้',
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color(0xFFD0D0D0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFD0D0D0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color(0xFF41486D),
                            width: 2.0,
                          ),
                        ),
                      ),
                      /*validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : 'โปรดกรอกชื่อบัญชีผู้ใช้',*/
                    ),
              ),
                    const SizedBox(height: 12),
                    // Input for email
                Container(
                  height: 40,
                  width: 328,
                  child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'อีเมล',
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color(0xFFD0D0D0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFD0D0D0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color(0xFF41486D),
                            width: 2.0,
                          ),
                        ),
                      ),
                      /*validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : 'โปรดกรอกอีเมล',*/
                    ),
                ),
                    const SizedBox(height: 12),
                    // Input for Password
                Container(
                  height: 40,
                  width: 328,
                  child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'รหัสผ่าน',
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xFFD0D0D0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFD0D0D0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color(0xFF41486D),
                            width: 2.0,
                          ),
                        ),
                      ),
                      obscureText: true, // hide password
                      /*validator: (value) => value != null && value.length >= 6
                          ? null
                          : 'Password must be at least 6 characters',*/
                    ),
                ),
                    const SizedBox(height: 30),
                    // Register button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Trigger registration event
                          context.read<AuthenticationBloc>().add(
                            AuthenticationRegisterRequested(
                              email: _emailController.text,
                              password: _passwordController.text,
                              name: _nameController.text,
                            ),
                          );
                          // หลังจากส่ง event ไปแล้ว นำทางไปหน้า login
                          Navigator.pushNamed(context, '/login');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0),
                        ),
                        backgroundColor: Color(0xFF41486D),
                        fixedSize: const Size(328, 40),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('สมัครสมาชิก',
                          style: TextStyle(
                              fontSize: 16,
                              //fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold
                          ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Login link
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'มีบัญชีอยู่แล้วใช่ไหม? ',
                          style: const TextStyle(
                            color: Color(0xFF5A5A5A),
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(
                              text: 'เข้าสู่ระบบ',
                              style: const TextStyle(
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
            ),
          );
        },
      ),
    );
  }
}