import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/custom_input_box.dart';
import 'package:fundflow/features/setting/bloc/user_profile/user_profile_bloc.dart';
import 'package:fundflow/features/setting/repository/settings_repository.dart';
import 'package:fundflow/utils/validator.dart';

class EditEmailPage extends StatelessWidget {
  final SettingsRepository repository;

  EditEmailPage({required this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              iconSize: 20,
              onPressed: () {
                Navigator.pop(context); // กลับไปหน้าก่อนหน้า (SettingsPage)
              },
            ),
          ],
        ),
        centerTitle: true,
        title: const Text(
          'แก้ไขอีเมล',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const EditEmailForm(),
    );
  }
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email changed successfully')),
          );
          Navigator.pop(context);
        } else if (state is UserProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'กรอกอีเมลใหม่',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5A5A5A),
              ),
            ),
            const SizedBox(height: 12),
            CustomInputBox(
              labelText: 'อีเมล',
              controller: _newEmailController,
              prefixIcon: const Icon(
                Icons.email,
               color: Color(0xFFD0D0D0),
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter a valid email')),
                      );
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
