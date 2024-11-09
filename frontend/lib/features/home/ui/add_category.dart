import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/home/category_card.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_event.dart';
import 'package:fundflow/features/home/models/category.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({Key? key}) : super(key: key);

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  String categoryName = '';
  Color selectedColor = Colors.blue;

  final List<Color> availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มประเภทค่าใช้จ่าย'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Wrap the content with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Card Preview
            CategoryCard(
              category: Category(
                // Pass the entire Category object
                name: categoryName.isNotEmpty
                    ? categoryName
                    : 'ตัวอย่างประเภทค่าใช้จ่าย',
                amount: 2000.00, // Set a default amount here
                color: selectedColor, // Use selectedColor here
              ),
// Use selectedColor here
            ),
            const SizedBox(height: 20),

            // Category Name Input
            const Text(
              'ชื่อประเภทค่าใช้จ่าย',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                hintText: 'กรอกชื่อประเภทค่าใช้จ่าย',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  categoryName = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Color Selector
            const Text(
              'เลือกสี',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (categoryName.isNotEmpty) {
                    final newCategory = Category(
                      name: categoryName,
                      amount: 0.0, // Set default or user-inputted amount
                      color: selectedColor,
                    );

                    // Dispatch AddCategory event with the entire Category object
                    context
                        .read<CategoryBloc>()
                        .add(AddCategory(category: newCategory));
                    Navigator.pop(context); // Return to the previous screen
                  }
                },
                child: const Text('เพิ่มประเภทค่าใช้จ่าย'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
