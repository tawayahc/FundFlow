import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: AppColors.darkBlue, // ปุ่มสีน้ำเงินเข้ม
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Color(0xffffffff)),
        ),
      ),
    );
  }
}
