import 'package:flutter/material.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/custom_password_input_box.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  FocusNode _oldPasswordFocusNode = FocusNode();
  FocusNode _newPasswordFocusNode = FocusNode();

  // Controllers for text fields
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _oldPasswordFocusNode.addListener(_onFocusChange);
    _newPasswordFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _oldPasswordFocusNode.removeListener(_onFocusChange);
    _newPasswordFocusNode.removeListener(_onFocusChange);
    _oldPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {}); // Rebuild UI on focus change
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
          'เปลี่ยนรหัสผ่าน',
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
              'ใส่รหัสผ่าน',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A5A5A)),
            ),
            const SizedBox(height: 20),
            // Old Password
            CustomPasswordInputBox(
              labelText: 'รหัสผ่านเดิม',
              focusNode: _oldPasswordFocusNode,
              controller: _oldPasswordController,
            ),
            const SizedBox(height: 12),
            // New Password
            CustomPasswordInputBox(
              labelText: 'รหัสผ่านใหม่',
              focusNode: _newPasswordFocusNode,
              controller: _newPasswordController,
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
