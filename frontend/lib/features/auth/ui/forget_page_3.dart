import 'package:flutter/material.dart';
import 'package:fundflow/core/widgets/custom_password_input_box.dart';
import 'package:fundflow/core/widgets/custom_button.dart';



class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

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
          'ลืมรหัสผ่าน',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
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
            focusNode: FocusNode()
          ),
          
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'ยืนยัน', 
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ),
        ],
      ),
    );
  }
}