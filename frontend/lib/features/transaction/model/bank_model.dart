class Bank {
  final int id;
  final String name;

  Bank({required this.id, required this.name});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'],
      name: json['name'],
    );
  }
}
