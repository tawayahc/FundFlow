import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/custom_input_box.dart';
import 'package:fundflow/core/widgets/custom_button.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';


class ForgetPage extends StatelessWidget {
  ForgetPage({super.key});

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'กรอกอีเมลเพื่อยืนยันตัวตน',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5A5A5A)),
          ),
          const SizedBox(height: 12),
          CustomInputBox(
                    labelText: 'อีเมล', 
                    prefixIcon: Icon(
                      Icons.email,
                      color: Color(0xFFD0D0D0),
                    ),
                  ),
        
      
        const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'ยืนยัน', 
              onPressed: () {
                Navigator.pushNamed(context, '/forget2');
              },
            ),
          ),
      ],
            ),
  );
}
}