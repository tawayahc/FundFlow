import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/home/custom_text_button.dart';
import 'package:fundflow/features/home/ui/bank_section.dart';
import 'package:fundflow/features/home/ui/category_section.dart';
import 'package:fundflow/features/home/ui/profile_section.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/features/image_upload/bloc/slip/slip_bloc.dart';
import 'package:fundflow/features/image_upload/bloc/slip/slip_event.dart';

class HomeUI extends StatelessWidget {
  final PageController pageController;
  const HomeUI({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<SlipBloc>().add(DetectAndUploadSlips());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 15),
              ProfileSection(
                pageController: pageController,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "บัญชีธนาคาร",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGrey),
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
                        color: AppColors.darkGrey),
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
              const CategorySection()
            ],
          ),
        ),
      ),
    );
  }
}
