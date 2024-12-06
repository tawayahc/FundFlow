import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/custom_modal.dart';
import 'package:fundflow/core/widgets/custom_password_input_box.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/setting/bloc/change_password/change_password_bloc.dart';
import 'package:fundflow/features/setting/repository/settings_repository.dart';

class ChangePasswordPage extends StatelessWidget {
  final SettingsRepository repository;

  ChangePasswordPage({required this.repository});

  @override
  Widget build(BuildContext context) {
    return GlobalPadding(
      child: BlocProvider(
        create: (context) => ChangePasswordBloc(repository: repository),
        child: Scaffold(
          appBar: AppBar(
            leading: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: AppColors.darkGrey,
                  iconSize: 20,
                  onPressed: () {
                    Navigator.pop(
                        context); // Go back to the previous page (SettingsPage)
                  },
                ),
              ],
            ),
            centerTitle: true,
            title: const Text(
              'เปลี่ยนรหัสผ่าน',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGrey,
              ),
            ),
          ),
          body: const ChangePasswordForm(),
        ),
      ),
    );
  }
}

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  // Controllers for text fields
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
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
    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          Navigator.pop(context);
        } else if (state is ChangePasswordFailure) {
          _showModal(context, 'เปลี่ยนรหัสผ่านไม่สำเร็จ');
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'ใส่รหัสผ่าน',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey),
            ),
            const SizedBox(height: 12),
            CustomPasswordInputBox(
              labelText: 'รหัสผ่านเดิม',
              controller: _oldPasswordController,
            ),
            const SizedBox(height: 12),
            CustomPasswordInputBox(
              labelText: 'รหัสผ่านใหม่',
              controller: _newPasswordController,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'ยืนยัน',
                onPressed: () {
                  BlocProvider.of<ChangePasswordBloc>(context).add(
                    SubmitChangePasswordEvent(
                      oldPassword: _oldPasswordController.text,
                      newPassword: _newPasswordController.text,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
