import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/setting/bloc/delete_account/delete_account_bloc.dart';
import 'package:fundflow/features/setting/repository/settings_repository.dart';

class DeleteAccountPage extends StatelessWidget {
  final SettingsRepository repository;

  DeleteAccountPage({required this.repository});

  @override
  Widget build(BuildContext context) {
    return GlobalPadding(
      child: BlocProvider(
        create: (context) => DeleteAccountBloc(repository: repository),
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                color: AppColors.darkGrey,
                onPressed: () {
                  Navigator.pop(context); // กลับไปหน้าก่อนหน้า (SettingsPage)
                },
              ),
              centerTitle: true,
              title: const Text(
                'ลบบัญชี FundFlow',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
            ),
            body: const DeleteAccountForm()),
      ),
    );
  }
}

class DeleteAccountForm extends StatefulWidget {
  const DeleteAccountForm({super.key});

  @override
  State<DeleteAccountForm> createState() => _DeleteAccountFormState();
}

class _DeleteAccountFormState extends State<DeleteAccountForm> {
  bool _isOldPasswordVisible = false; // สำหรับจัดการการแสดงรหัสผ่านเดิม

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteAccountBloc, DeleteAccountState>(
        listener: (context, state) {
          if (state is DeleteAccountSuccess) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
          } else if (state is DeleteAccountFailure) {}
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'ใส่รหัสผ่าน',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGrey),
              ),
              const SizedBox(height: 20),
              // รหัสผ่านเดิม
              TextFormField(
                obscureText: !_isOldPasswordVisible, // ซ่อนรหัสผ่าน

                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'รหัสผ่าน',
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.icon,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isOldPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: _isOldPasswordVisible
                          ? AppColors.darkBlue // สีเมื่อแสดงรหัสผ่าน
                          : AppColors.icon, // สีเมื่อซ่อนรหัสผ่าน
                    ),
                    onPressed: () {
                      setState(() {
                        _isOldPasswordVisible =
                            !_isOldPasswordVisible; // สลับสถานะ
                      });
                    },
                  ), // ไม่แสดงไอคอนหากไม่มีโฟกัส
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: AppColors.icon,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: AppColors.darkBlue,
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
                    BlocProvider.of<DeleteAccountBloc>(context).add(
                      SubmitDeleteAccountEvent(_passwordController.text),
                    );
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
        ));
  }
}
