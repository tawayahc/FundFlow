import 'package:flutter/material.dart';
import 'package:fundflow/features/home/models/bank.dart';

class BankRepository {
  // This function simulates fetching data from an API or a local database
  Future<List<Bank>> getBanks() async {
    // Simulating network delay
    await Future.delayed(Duration(seconds: 1));

    // Return mock data (you can replace this with API call)
    return [
      Bank(name: 'กสิกรไทย', balance: 1085800555888.00, color: Colors.green),
      Bank(name: 'กรุงไทย', balance: 20234.00, color: Colors.blue),
      Bank(name: 'ไทยพาณิชย์', balance: 1340.00, color: Colors.purple),
    ];
  }
}
