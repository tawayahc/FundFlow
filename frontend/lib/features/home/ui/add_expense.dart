import 'package:flutter/material.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({Key? key}) : super(key: key);

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  String expenseName = '';
  Color selectedColor = Colors.blue;

  final List<Color> availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มประเภทค่าใช้จ่าย'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'ชื่อประเภทค่าใช้จ่าย',
                hintText: 'กรอกชื่อประเภทค่าใช้จ่าย',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  expenseName = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text('เลือกสี',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: availableColors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: selectedColor == color
                          ? Border.all(width: 3, color: Colors.black)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text('ตัวอย่าง', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            ExpensePreviewCard(expenseName: expenseName, color: selectedColor),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save expense category and navigate back
              },
              child: const Text('เพิ่มประเภทค่าใช้จ่าย'),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpensePreviewCard extends StatelessWidget {
  final String expenseName;
  final Color color;

  const ExpensePreviewCard(
      {Key? key, required this.expenseName, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(width: 10, height: 10, color: color),
          const SizedBox(width: 10),
          Text(
            expenseName.isNotEmpty ? expenseName : 'ตัวอย่างประเภทค่าใช้จ่าย',
            style: TextStyle(
                fontSize: 16, color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
