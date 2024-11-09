import 'package:flutter/material.dart';

class Bank {
  final String name;
  final String bank_name;
  final double amount;

  Bank({
    required this.name,
    required this.bank_name,
    required this.amount,
  });

  // Add a fromJson method to parse JSON data
  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      name: json['name'] as String,
      bank_name: json['bank_name'] as String,
      amount: (json['amount'] as num).toDouble(),
    );
  }
}
