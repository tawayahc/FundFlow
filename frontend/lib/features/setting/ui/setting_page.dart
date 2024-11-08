import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/features/auth/bloc/auth_bloc.dart';
import 'package:fundflow/features/auth/bloc/auth_event.dart';
import 'package:fundflow/features/setting/ui/change_password.dart';
import 'package:fundflow/features/setting/ui/delete_acc_page.dart';
import 'package:fundflow/features/setting/ui/edit_email_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushNamed(
                  context, '/home'); // ย้อนกลับไปยังหน้าก่อนหน้า
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
              const Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        'https://placehold.co/150/jpg'), // เปลี่ยน URL ของรูปผู้ใช้ตามจริง
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
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
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'อีเมล',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF5A5A5A), // สีดำสำหรับ "อีเมล"
                      ),
                    ),
                    Text(
                      'user01@gmail.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF41486D), // สีน้ำเงินสำหรับอีเมล
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(context,
                      '/setting_page/edit_email'); // ใช้ Navigator เพื่อไปหน้าเปลี่ยนอีเมล
                },
              ),

              ListTile(
                leading:
                    const Icon(Icons.lock_outline, color: Color(0xFF5A5A5A)),
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
                    MaterialPageRoute(
                        builder: (context) => const ChangePasswordPage()),
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
                    MaterialPageRoute(
                        builder: (context) => const DeleteAccPage()),
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
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(AuthenticationLogoutRequested()); // ออกจากระบบ
                },
              ),
              const Divider(thickness: 0.5, color: Colors.grey),
            ],
          ),
        ));
  }
}
