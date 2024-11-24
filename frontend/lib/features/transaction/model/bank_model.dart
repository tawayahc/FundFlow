import 'package:flutter/material.dart';


const Map<String, Color> bankColors = {
  'ธนาคารกรุงไทย': Colors.blue,
  'ธนาคารไทยพาณิชย์': Colors.purple,
  'ธนาคารออมสิน': Colors.pink,
};

const Map<String, String> bankImages = {
  'ธนาคารกรุงไทย': 'lib/images/Krungthai.png',
  'ธนาคารไทยพาณิชย์': 'lib/images/SCB.png',
  'ธนาคารออมสิน': 'lib/images/GSB.png',
};

class Bank {
  final int id;
  final String name;
  final String bankName;

  Bank({required this.id, required this.name, required this.bankName});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'],
      name: json['name'],
      bankName: json['bank_name']
    );
  }

  Color get color {
    return bankColors[bankName] ?? Colors.grey;
  }

  String get image {
    return bankImages[bankName] ?? 'lib/images/GSB.png';
  }
}
