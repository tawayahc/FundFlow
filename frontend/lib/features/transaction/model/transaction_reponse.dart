import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:fundflow/models/bank_model.dart';
import 'package:fundflow/features/transaction/model/category_model.dart';

class TransactionResponse {
  String metadata;
  String bank;
  String type;
  double amount;
  int categoryId;
  String? date;
  String? time;
  String? memo;

  // Optional fields for processing
  int? bankId;
  List<Bank>? possibleBanks;
  List<Category>? possibleCategories;

  bool isRead;

  TransactionResponse({
    required this.metadata,
    required this.bank,
    required this.type,
    required this.amount,
    required this.categoryId,
    this.date,
    this.time,
    this.memo,
    this.possibleBanks,
    this.possibleCategories,
    this.isRead = false,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      metadata: json['metadata'] as String,
      bank: json['bank'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      categoryId: json['category_id'] as int,
      date: json['date'] as String?, // Allow null
      time: json['time'] as String?, // Allow null
      memo: json['memo'] as String?, // Allow null
      isRead: json['is_read'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metadata': metadata,
      'bank': bank,
      'type': type,
      'amount': amount,
      'category_id': categoryId,
      'date': date,
      'time': time,
      'memo': memo,
      'is_read': isRead,
    };
  }

  String get transactionHash {
    final transactionJson = jsonEncode(toJson());
    final bytes = utf8.encode(transactionJson);
    final digest = md5.convert(bytes);
    return digest.toString();
  }
}
