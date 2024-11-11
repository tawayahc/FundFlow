import 'package:flutter/material.dart';
import 'package:fundflow/features/home/models/category.dart';
import 'package:fundflow/features/home/pages/edit_category_page.dart'; // Import the EditCategoryPage

class CategoryTransactionPage extends StatelessWidget {
  final Category category;

  const CategoryTransactionPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // Navigate to the EditCategoryPage and get the updated category
              final updatedCategory = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCategoryPage(category: category),
                ),
              );

              // If there's an updated category, do something with it (e.g., update the list)
              if (updatedCategory != null) {
                // Handle updated category (e.g., update the state, show a message, etc.)
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Category Name: ${category.name}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Amount: ฿ ${category.amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            // Add more details about the category here if needed
          ],
        ),
      ),
    );
  }
}
