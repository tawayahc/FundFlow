import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/custom_input_box.dart';
import 'package:fundflow/core/widgets/custom_modal.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/setting/bloc/user_profile/user_profile_bloc.dart';
import 'package:fundflow/features/setting/repository/settings_repository.dart';
import 'package:fundflow/utils/validator.dart';

class EditEmailPage extends StatelessWidget {
  final SettingsRepository repository;

  EditEmailPage({required this.repository});

  @override
  Widget build(BuildContext context) {
    return GlobalPadding(
      child: Scaffold(
        appBar: AppBar(
          leading: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                color: AppColors.darkGrey,
                iconSize: 20,
                onPressed: () {
                  Navigator.pop(context); // กลับไปหน้าก่อนหน้า (SettingsPage)
                },
              ),
            ],
          ),
          centerTitle: true,
          title: const Text(
            'เปลี่ยนอีเมล',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
          ),
        ),
        body: const EditEmailForm(),
      ),
    );
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

class EditEmailForm extends StatefulWidget {
  const EditEmailForm({super.key});

  @override
  State<EditEmailForm> createState() => _EditEmailFormState();
}

class _EditEmailFormState extends State<EditEmailForm> {
  final TextEditingController _newEmailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileLoaded) {
          Navigator.pop(context);
        } else if (state is UserProfileError) {
          _showModal(context, 'เปลี่ยนอีเมลไม่สำเร็จ');
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'ใส่อีเมลใหม่',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: 12),
            CustomInputBox(
              labelText: 'อีเมล',
              controller: _newEmailController,
              prefixIcon: const Icon(
                Icons.email,
                color: AppColors.icon,
              ),
            ),
            const SizedBox(height: 30),
            BlocBuilder<UserProfileBloc, UserProfileState>(
              builder: (context, state) {
                if (state is UserProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return CustomButton(
                  text: 'ยืนยัน',
                  onPressed: () {
                    final newEmail = _newEmailController.text.trim();
                    if (newEmail.isNotEmpty && isValidEmail(newEmail)) {
                      context.read<UserProfileBloc>().add(
                            SubmitChangeEmailEvent(newEmail),
                          );
                    } else {
                      _showModal(context, 'กรุณากรอกอีเมลให้ถูกต้อง');
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _newEmailController.dispose();
    super.dispose();
  }
}
