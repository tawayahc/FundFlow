import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

          return Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30,),
                    const Icon(
                      Icons.lock,
                      color: Color(0xFF41486D),
                      size: 100
                    ),
                  
                    Container(
                      width: 328,
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xFF41486D),
                          fontSize: 30, // Font size
                          fontWeight: FontWeight.bold, // Bold text
                          //letterSpacing: 2.0, // Spacing between letters
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          Container(
                            height: 40,
                            width: 328,
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Color(0xFF41486D),
                              ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Color(0xFF41486D)
                                  )
                              )),
                              validator: (value) => value != null && value.contains('@')
                                  ? null
                                  : 'Enter a valid email',
                            ),
                          ),

                          const SizedBox(height: 10),
                          Container(
                            height: 40,
                            width: 328,
                            child: TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Color(0xFF41486D),
                              ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Color(0xFF41486D)
                                  )
                              )),
                              obscureText: true,
                              validator: (value) => value != null && value.length >= 6
                                  ? null
                                  : 'Password must be at least 6 characters',
                            ),
                          ),
                          
                          const SizedBox(height: 5),
                          Container(
                            width: 328,
                            alignment: Alignment.topRight,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/forget1');
                                },
                                child: const Text(
                                  'Forget password?',
                                  style: TextStyle(
                                    fontSize: 15, // Font size
                                    color: Colors.red
                                  ),
                                ),
                              ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                // Trigger login event
                                context.read<AuthenticationBloc>().add(
                                      AuthenticationLoginRequested(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      ),
                                    );
                              }
                            }, 
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color(0xFF41486D),
                              fixedSize: const Size(328, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22), // Rounded corners
                              ),
                            ),
                            label: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                //fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold
                              ),)),
                              
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Don\'t have an account?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/register');
                                },
                                child: const Text(
                                  'Register now',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                  ),
                              ),
                            ],
                          ),
                        ],
                    ),
                  ),
                ],)
            ),
          );
        },
      ),
    );
  }
}
