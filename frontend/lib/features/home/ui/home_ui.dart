import 'package:flutter/material.dart';
import 'package:fundflow/core/widgets/home/custom_text_button.dart';
import 'package:fundflow/features/home/ui/bank_section.dart';
import 'package:fundflow/features/home/ui/category_section.dart';
import 'package:fundflow/features/home/ui/profile_section.dart';
import 'package:fundflow/core/themes/app_styles.dart';

class HomeUI extends StatelessWidget {
  const HomeUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              const ProfileSection(),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "บัญชีธนาคาร",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF414141)),
                  ),
                  CustomTextButton(
                    text: 'เพิ่มบัญชีธนาคาร +',
                    color: AppColors.pink,
                    fontSize: 12,
                    onPressed: () {
                      Navigator.pushNamed(context, '/addBank');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const BankSection(),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "ประเภทค่าใช้จ่าย",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF414141)),
                  ),
                  CustomTextButton(
                    text: 'เพิ่มประเภทค่าใช้จ่าย +',
                    color: AppColors.pink,
                    fontSize: 12,
                    onPressed: () {
                      Navigator.pushNamed(context, '/addCategory');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const CategorySection(),
            ],
          ),
        ),
      ),
    );
  }
}
