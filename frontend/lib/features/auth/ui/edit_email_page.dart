import 'package:flutter/material.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/custom_password_input_box.dart';

class EditEmailPage extends StatelessWidget {
  final FocusNode _newEmailFocusNode = FocusNode();

  // Controllers for text fields
  final TextEditingController _newEmailController = TextEditingController();

  EditEmailPage({super.key});

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
          'เปลี่ยนอีเมล',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
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
            CustomPasswordInputBox(
                labelText: 'อีเมล',
                focusNode: _newEmailFocusNode,
                controller: _newEmailController),
            const SizedBox(height: 30),
            CustomButton(
              text: 'ยืนยัน',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
