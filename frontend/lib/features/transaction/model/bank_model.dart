class Bank {
  final int id;
  final String name;
  final String bankName;

  Bank({required this.id, required this.name, required this.bankName});

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
    );
  }
}
