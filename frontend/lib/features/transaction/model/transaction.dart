import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:fundflow/features/transaction/model/bank_model.dart';
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
    };
  }

  String get transactionHash {
    final transactionJson = jsonEncode(toJson());
    final bytes = utf8.encode(transactionJson);
    final digest = md5.convert(bytes);
    return digest.toString();
  }
}
