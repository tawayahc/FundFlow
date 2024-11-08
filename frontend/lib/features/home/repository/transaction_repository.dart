import 'package:fundflow/features/home/models/transaction.dart';

class TransactionRepository {
  // This function simulates fetching data from an API or a local database
  Future<List<Transaction>> getTransaction() async {
    // Simulating network delay
    await Future.delayed(const Duration(seconds: 1));
    // Return mock data (you can replace this with API call)
    return transactions;
  }
}

List<Transaction> transactions = [
  Transaction(memo: 'ข้าวปลาอาหาร', date: '8-11-2567', amount: -50.00, category: 'ค่าอาหาร'),
  Transaction(memo: 'ซื้อรถ', date: '8-11-2567', amount: -500000.00, category: 'ค่าเดินทาง'),
  Transaction(memo: 'เค้ก', date: '8-11-2567', amount: -100.00, category: 'ค่าอาหาร'),
  Transaction(memo: 'ขายตัว(เธอ)', amount: 100.00, category: 'ค่าของใช้'),
  Transaction(memo: 'ขายเค้ก', date: '8-11-2567', amount: 100.00, category: 'ค่าอาหาร'),
  Transaction(memo: 'ขายขนม', date: '8-11-2567', amount: 200.00, category: 'ค่าอาหาร'),
];