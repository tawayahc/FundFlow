import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/custom_modal.dart';
import 'package:fundflow/core/widgets/custom_password_input_box.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/auth/bloc/repassword/repassword_bloc.dart';
import 'package:fundflow/features/auth/bloc/repassword/repassword_event.dart';
import 'package:fundflow/features/auth/bloc/repassword/repassword_state.dart';
import 'package:fundflow/features/auth/models/repassword_request.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({super.key, required this.email});

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
    return GlobalPadding(
      child: Scaffold(
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
            padding: const EdgeInsets.all(16.0),
            child: BlocListener<RepasswordBloc, RepasswordState>(
              listener: (context, state) {
                if (state is RepasswordPasswordReset) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                } else if (state is RepasswordFailure) {
                  _showModal(context, 'เปลี่ยนรหัสผ่านไม่สำเร็จ');
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'เปลี่ยนรหัสผ่าน',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightBlack),
                  ),
                  const SizedBox(height: 12),
                  CustomPasswordInputBox(
                    labelText: 'รหัสผ่านใหม่',
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
          )),
    );
  }
}
