import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/custom_input_box.dart';
import 'package:fundflow/features/setting/bloc/change_email/change_email_bloc.dart';
import 'package:fundflow/features/setting/repository/settings_repository.dart';

class EditEmailPage extends StatelessWidget {
  final SettingsRepository repository;

  EditEmailPage({required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangeEmailBloc(repository: repository),
      child: Scaffold(
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
      ),
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
    return BlocListener<ChangeEmailBloc, ChangeEmailState>(
      listener: (context, state) {
        if (state is ChangeEmailSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Email changed successfully')));
          Navigator.pop(context);
        } else if (state is ChangeEmailFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
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
                  color: Color(0xFF5A5A5A)),
            ),
            const SizedBox(height: 12),
            CustomInputBox(
              labelText: 'อีเมล',
              controller: _newEmailController,
              prefixIcon: const Icon(
                Icons.email,
              ),
            ),
            const SizedBox(height: 30),
            BlocBuilder<ChangeEmailBloc, ChangeEmailState>(
              builder: (context, state) {
                if (state is ChangeEmailLoading) {
                  return CircularProgressIndicator();
                }
                return CustomButton(
                  text: 'ยืนยัน',
                  onPressed: () {
                    BlocProvider.of<ChangeEmailBloc>(context).add(
                      SubmitChangeEmailEvent(_newEmailController.text),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
