import 'package:flutter/material.dart';
import 'package:fundflow/features/auth/ui/change_password.dart';
import 'package:fundflow/features/auth/ui/delete_acc_page.dart';
import 'package:fundflow/features/auth/ui/edit_email_page.dart';
import 'package:fundflow/features/auth/ui/login_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context); // ย้อนกลับไปยังหน้าก่อนหน้า
          },
        ),
        centerTitle: true,
        title: const Text(
          'ตั้งค่า',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Information
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150'), // เปลี่ยน URL ของรูปผู้ใช้ตามจริง
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'User01',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF414141), // ใช้สี #414141
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(thickness: 0.5, color: Colors.grey),
            const SizedBox(height: 20),
            // Account Section
            const Text(
              'บัญชี',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF414141), // ใช้สี #414141
              ),
            ),
            ListTile(
              leading:
                  const Icon(Icons.email_outlined, color: Color(0xFF5A5A5A)),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'อีเมล',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF5A5A5A), // สีดำสำหรับ "อีเมล"
                    ),
                  ),
                  Text(
                    'user01@gmail.com',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF41486D), // สีน้ำเงินสำหรับอีเมล
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditEmailPage()),
                ); // ใช้ Navigator เพื่อไปหน้าเปลี่ยนอีเมล
              },
            ),

            ListTile(
              leading: const Icon(Icons.lock_outline, color: Color(0xFF5A5A5A)),
              title: const Text(
                'เปลี่ยนรหัสผ่าน',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF5A5A5A), // สีดำสำหรับ "อีเมล"
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                ); // ใช้ Navigator เพื่อไปหน้าเปลี่ยนอีเมล
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.delete_outline, color: Color(0xFF5A5A5A)),
              title: const Text(
                'ลบบัญชี FundFlow',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF5A5A5A), // สีดำสำหรับ "อีเมล"
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeleteAccPage()),
                ); // ใช้ Navigator เพื่อไปหน้าเปลี่ยนอีเมล
              },
            ),
            const Divider(thickness: 0.5, color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFF5A5A5A)),
              title: const Text(
                'ออกจากระบบ',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF5A5A5A), // สีดำสำหรับ "อีเมล"
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                ); // ใช้ Navigator เพื่อไปหน้าเปลี่ยนอีเมล
              },
            ),
            const Divider(thickness: 0.5, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
