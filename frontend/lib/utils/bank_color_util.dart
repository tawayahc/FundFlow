import 'package:flutter/material.dart';

class BankColorUtil {
  static const Map<String, Color> _bankColors = {
    'ธนาคารกสิกรไทย': Colors.green,
    'ธนาคารกรุงไทย': Colors.blue,
    'ธนาคารไทยพาณิชย์': Colors.purple,
    'ธนาคารกรุงเทพ': Color.fromARGB(255, 10, 35, 145),
    'ธนาคารกรุงศรี': Color(0xFFffe000),
    'ธนาคารออมสิน': Colors.pink,
    'ธนาคารธนชาติ': Color(0xFFF68B1F),
    'ธนาคารเกียรตินาคิน': Color(0xFF004B87),
    'ธนาคารซิตี้แบงก์': Color(0xFF1E90FF),
  };

  static Color getBankColor(String bankName) {
    return _bankColors[bankName.trim()] ?? Colors.grey;
  }
}
