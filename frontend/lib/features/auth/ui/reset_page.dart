import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/custom_password_input_box.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/features/auth/bloc/repassword/repassword_bloc.dart';
import 'package:fundflow/features/auth/bloc/repassword/repassword_event.dart';
import 'package:fundflow/features/auth/bloc/repassword/repassword_state.dart';
import 'package:fundflow/features/auth/models/repassword_request.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  ResetPasswordPage({required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();

  void _resetPassword() {
    final password = _passwordController.text;
    if (password.isNotEmpty) {
      BlocProvider.of<RepasswordBloc>(context).add(ResetPasswordEvent(
        RepasswordRequest(email: widget.email, newPassword: password),
      ));
    }
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
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: BlocListener<RepasswordBloc, RepasswordState>(
            listener: (context, state) {
              if (state is RepasswordPasswordReset) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Password reset successfully')),
                );
                Navigator.popUntil(context, (route) => route.isFirst);
              } else if (state is RepasswordFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'เปลี่ยนรหัสผ่าน',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5A5A5A)),
                ),
                const SizedBox(height: 12),
                CustomPasswordInputBox(
                  labelText: 'รหัสผ่านใหม่',
                  focusNode: FocusNode(),
                  controller: _passwordController,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'ยืนยัน',
                    onPressed: _resetPassword,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
