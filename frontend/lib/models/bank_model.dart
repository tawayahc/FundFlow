import 'package:flutter/material.dart';
import 'package:fundflow/utils/bank_color_util.dart';
import 'package:fundflow/utils/bank_logo_util.dart';

class Bank {
  final int id;
  final String name;
  final String bankName;
  final double amount;

  Bank({
    required this.id,
    required this.name,
    required this.bankName,
    required this.amount,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Bank) return false;
    return id == other.id && name == other.name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'],
      name: json['name'],
      bankName: json['bank_name'],
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Color get color {
    return BankColorUtil.getBankColor(bankName);
  }

  String get image {
    return BankLogoUtil.getBankLogo(bankName);
  }
}
