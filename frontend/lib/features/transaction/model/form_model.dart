import 'package:flutter/material.dart';
import 'package:fundflow/models/category_model.dart';
import 'package:fundflow/models/bank_model.dart';

class CreateIncomeData {
  final Bank bank;
  final double amount;
  final DateTime date;
  final TimeOfDay? time;
  final String note;

  CreateIncomeData({
    required this.bank,
    required this.amount,
    required this.date,
    this.time,
    required this.note,
  });
}

class CreateExpenseData {
  final Bank bank;
  final Category category;
  final double amount;
  final DateTime date;
  final TimeOfDay? time;
  final String note;

  CreateExpenseData({
    required this.bank,
    required this.category,
    required this.amount,
    required this.date,
    this.time,
    required this.note,
  });
}

class CreateTransferData {
  final Bank fromBank;
  final Bank toBank;
  final double amount;
  final DateTime date;
  final TimeOfDay? time;

  CreateTransferData({
    required this.fromBank,
    required this.toBank,
    required this.amount,
    required this.date,
    this.time,
  });
}
