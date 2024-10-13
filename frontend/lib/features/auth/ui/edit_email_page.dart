import 'package:flutter/material.dart';
import 'package:fundflow/features/auth/ui/setting_page.dart';

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
            TextFormField(
              decoration: InputDecoration(
                labelText: 'อีเมล',
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Color(0xFFD0D0D0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Color(0xFFD0D0D0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF41486D),
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // กลับไปหน้า SettingsPage
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: const Color(0xFF41486D), // ปุ่มสีน้ำเงินเข้ม
                ),
                child: const Text(
                  'ยืนยัน',
                  style: TextStyle(fontSize: 18, color: Color(0xffffffff)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
