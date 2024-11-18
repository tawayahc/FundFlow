import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/custom_input_box.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/auth/bloc/repassword/repassword_bloc.dart';
import 'package:fundflow/features/auth/bloc/repassword/repassword_event.dart';
import 'package:fundflow/features/auth/bloc/repassword/repassword_state.dart';
import 'package:fundflow/features/auth/models/otp_request.dart';
import 'package:fundflow/features/auth/ui/verification_page.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({super.key});

  @override
  State<ForgetPage> createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  final TextEditingController _emailController = TextEditingController();

  void _submitEmail() {
    final email = _emailController.text.trim();
    if (email.isNotEmpty && _validateEmail(email)) {
      BlocProvider.of<RepasswordBloc>(context)
          .add(GenerateOTPEvent(OTPRequest(email: email)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกอีเมลให้ถูกต้อง')),
      );
    }
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return GlobalPadding(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: const Text(
            'ลืมรหัสผ่าน',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocListener<RepasswordBloc, RepasswordState>(
          listener: (context, state) {
            if (state is RepasswordOTPSent) {
              // Navigate to VerificationPage if OTP is sent successfully
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VerificationPage(email: _emailController.text),
                ),
              );
            } else if (state is RepasswordFailure) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'กรอกอีเมลเพื่อยืนยันตัวตน',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5A5A5A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomInputBox(
                      labelText: 'อีเมล',
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Color(0xFFD0D0D0),
                      ),
                      controller: _emailController,
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: CustomButton(
                        text: 'ยืนยัน',
                        onPressed: _submitEmail,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
