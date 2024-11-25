class Bank {
  final int id;
  final String name;
  final String bankName;

  Bank({required this.id, required this.name, required this.bankName});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'],
      name: json['name'],
      bankName: json['bank_name'],
    );
  }
}
