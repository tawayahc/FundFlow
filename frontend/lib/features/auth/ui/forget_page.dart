import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/custom_input_box.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
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
        SnackBar(content: Text('Please enter a valid email address')),
      );
    }
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context); // กลับไปหน้าก่อนหน้า (SettingsPage)
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
      body: BlocConsumer<RepasswordBloc, RepasswordState>(
        listener: (context, state) {
          if (state is RepasswordOTPSent) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    VerificationPage(email: _emailController.text)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'กรอกอีเมลเพื่อยืนยันตัวตน',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5A5A5A)),
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
                CustomButton(
                  text: 'ยืนยัน',
                  onPressed: _submitEmail,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}