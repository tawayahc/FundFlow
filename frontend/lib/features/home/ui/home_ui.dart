// ui/home_ui.dart
import 'package:flutter/material.dart';
import 'package:fundflow/features/home/ui/bank_section.dart';
import 'package:fundflow/features/home/ui/expense_section.dart';
import 'package:fundflow/features/home/ui/profile_section.dart';

class HomeUI extends StatelessWidget {
  const HomeUI({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileSection(),
              SizedBox(height: 20),
              Text(
                "บัญชีธนาคาร",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              BankSection(),
              SizedBox(height: 20),
              Text(
                "ประเภทค่าใช้จ่าย",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ExpenseSection(),
            ],
          ),
        ),
      ),
    );
  }
}
