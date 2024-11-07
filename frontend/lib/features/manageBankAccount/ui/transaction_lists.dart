class Transaction {
  final double amount;
  final String category;
  final String type;

  Transaction({required this.amount, required this.category, required this.type});
}

List<Transaction> transactions = [
  Transaction(amount: -2500, category: 'อาหาร', type: 'ใบเสร็จ'),
  Transaction(amount: 2500, category: 'ค่ากระเป๋า', type: 'ใบเสร็จ'),
  Transaction(amount: 2500, category: 'ค่ากระเป๋า', type: 'ใบเสร็จ'),
  Transaction(amount: -2500, category: 'ค่ากระเป๋า', type: 'ใบเสร็จ'),
  Transaction(amount: 2500, category: 'ค่ากระเป๋า', type: 'ใบเสร็จ'),
  Transaction(amount: 2500, category: 'ค่ากระเป๋า', type: 'ใบเสร็จ'),
  Transaction(amount: -2500, category: 'ค่ากระเป๋า', type: 'ใบเสร็จ'),
  Transaction(amount: 2500, category: 'ค่ากระเป๋า', type: 'ใบเสร็จ'),
  // Transaction(amount: -2500, description: 'ค่ากระเป๋า', status: 'ใบเสร็จ'),
];
