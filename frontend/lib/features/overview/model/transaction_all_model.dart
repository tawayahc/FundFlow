// features/overview/model/transaction_model.dart
import 'package:flutter/material.dart';
import 'package:fundflow/features/overview/model/category_model.dart';

class TransactionAllModel {
  final int id;
  final int bankId;
  final String bankNickname;
  final String bankName;
  final String type;
  final double amount;
  final int categoryId;
  final String metaData;
  final String memo;
  final DateTime createdAt;
  final String categoryName; // Added
  final Color categoryColor; // Added

  TransactionAllModel({
    required this.id,
    required this.bankId,
    required this.bankNickname,
    required this.bankName,
    required this.type,
    required this.amount,
    required this.categoryId,
    required this.metaData,
    required this.memo,
    required this.createdAt,
    required this.categoryName,
    required this.categoryColor,
  });

  factory TransactionAllModel.fromJson(
      Map<String, dynamic> json, CategoryModel category) {
    return TransactionAllModel(
      id: json['id'],
      bankId: json['bank_id'],
      bankNickname: json['bank_nickname'],
      bankName: json['bank_name'],
      type: json['type'],
      amount: (json['amount'] as num).toDouble(),
      categoryId: json['category_id'] ?? 0,
      metaData: json['meta_data'] ?? '',
      memo: json['memo'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      categoryName: category.name,
      categoryColor: category.color,
    );
  }
}
