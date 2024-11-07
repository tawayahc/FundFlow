import 'package:flutter/material.dart';

class DeleteAccPage extends StatefulWidget {
  const DeleteAccPage({Key? key}) : super(key: key);

  @override
  _DeleteAccPageState createState() => _DeleteAccPageState();
}

class _DeleteAccPageState extends State<DeleteAccPage> {
  bool _isOldPasswordVisible = false; // สำหรับจัดการการแสดงรหัสผ่านเดิม
  bool _isNewPasswordVisible = false; // สำหรับจัดการการแสดงรหัสผ่านใหม่
  FocusNode _oldPasswordFocusNode = FocusNode(); // สำหรับการจัดการ focus
  FocusNode _newPasswordFocusNode = FocusNode(); // สำหรับการจัดการ focus

  @override
  void dispose() {
    _oldPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    super.dispose();
  }

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
          'ลบบัญชี',
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
              'กรอกรหัสผ่าน',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A5A5A)),
            ),
            const SizedBox(height: 20),
            // รหัสผ่านเดิม
            TextFormField(
              obscureText: !_isOldPasswordVisible, // ซ่อนรหัสผ่าน
              focusNode: _oldPasswordFocusNode,
              decoration: InputDecoration(
                labelText: 'รหัสผ่าน',
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Color(0xFFD0D0D0),
                ),
                suffixIcon: _oldPasswordFocusNode
                        .hasFocus // ตรวจสอบว่ามีโฟกัสอยู่หรือไม่
                    ? IconButton(
                        icon: Icon(
                          _isOldPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: _isOldPasswordVisible
                              ? const Color(0xFF41486D) // สีเมื่อแสดงรหัสผ่าน
                              : const Color(0xFFD0D0D0), // สีเมื่อซ่อนรหัสผ่าน
                        ),
                        onPressed: () {
                          setState(() {
                            _isOldPasswordVisible =
                                !_isOldPasswordVisible; // สลับสถานะ
                          });
                        },
                      )
                    : null, // ไม่แสดงไอคอนหากไม่มีโฟกัส
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
              onTap: () {
                setState(() {}); // รีเฟรชหน้าเมื่อผู้ใช้กดที่ TextField
              },
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: const Color(0xFFFF5C5C), // ปุ่มแดง
                ),
                child: const Text(
                  'ลบบัญชี',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
