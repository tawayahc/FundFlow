import 'package:flutter/material.dart';
import 'package:fundflow/features/auth/ui/setting_page.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/custom_input_box.dart';

class EditEmailPage extends StatelessWidget {
  const EditEmailPage({Key? key}) : super(key: key); // เพิ่ม Key ใน Constructor

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
            CustomInputBox(
              labelText: 'อีเมล',
              prefixIcon:
                  const Icon(Icons.email_outlined, color: Color(0xFFD0D0D0)),
            ),
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
