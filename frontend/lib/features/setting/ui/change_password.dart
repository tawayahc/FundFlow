import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/custom_password_input_box.dart';
import 'package:fundflow/features/setting/bloc/change_password/change_password_bloc.dart';
import 'package:fundflow/features/setting/repository/settings_repository.dart';

class ChangePasswordPage extends StatelessWidget {
  final SettingsRepository repository;

  ChangePasswordPage({required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordBloc(repository: repository),
      child: Scaffold(
        appBar: AppBar(
          leading: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
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
            ),
          ),
        ),
        body: const ChangePasswordForm(),
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
  final FocusNode _oldPasswordFocusNode = FocusNode();
  final FocusNode _newPasswordFocusNode = FocusNode();

  // Controllers for text fields
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _oldPasswordFocusNode.addListener(_onFocusChange);
    _newPasswordFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _oldPasswordFocusNode.removeListener(_onFocusChange);
    _newPasswordFocusNode.removeListener(_onFocusChange);
    _oldPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {}); // Rebuild UI on focus change
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password changed successfully')));
          Navigator.pop(context);
        } else if (state is ChangePasswordFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
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
            labelText: 'รหัสผ่านเดิม',
            focusNode: _oldPasswordFocusNode,
            controller: _oldPasswordController,
          ),
          const SizedBox(height: 12),
          CustomPasswordInputBox(
            labelText: 'รหัสผ่านใหม่',
            focusNode: _newPasswordFocusNode,
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
    );
  }
}
