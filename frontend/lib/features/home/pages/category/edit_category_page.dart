import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/core/widgets/home/category_card.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_event.dart';
import 'package:fundflow/features/home/bloc/category/category_state.dart';
import 'package:fundflow/features/home/models/category.dart';
import 'package:fundflow/features/home/pages/home_page.dart';

class EditCategoryPage extends StatefulWidget {
  final Category category;

  const EditCategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  late String categoryName;
  late Color selectedColor;
  late double categoryAmount;

  final List<Color> availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  late Category originalCategory;

  @override
  void initState() {
    super.initState();
    // Initialize originalCategory from widget.category
    originalCategory = widget.category;

    // Set the initial state based on the passed category
    categoryName = originalCategory.name;
    selectedColor = originalCategory.color;
    categoryAmount = originalCategory.amount;
  }

  @override
  Widget build(BuildContext context) {
    return GlobalPadding(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('แก้ไขประเภทค่าใช้จ่าย'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<CategoryBloc, CategoryState>(
            listener: (context, state) {
              if (state is CategoryUpdated) {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Category updated successfully')),
                // );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const GlobalPadding(child: HomePage())),
                );
                // Navigator.pop(context); // Go back to the previous screen
              } else if (state is CategoryError) {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Failed to update category')),
                // );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Card Preview
                CategoryCard(
                  category: Category(
                    id: originalCategory.id,
                    name: categoryName,
                    amount: categoryAmount,
                    color: selectedColor,
                  ),
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
                  // controller: TextEditingController(text: categoryName),
                ),
                const SizedBox(height: 20),
                // Category Amount Input
                const Text(
                  'จำนวนเงิน',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  '฿ ${widget.category.amount}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
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
                        final updatedCategory = Category(
                          id: originalCategory.id,
                          name: categoryName,
                          amount: categoryAmount,
                          color: selectedColor,
                        );

                        BlocProvider.of<CategoryBloc>(context).add(
                          EditCategory(
                              originalCategory: originalCategory,
                              category: updatedCategory),
                        );
                      }
                    },
                    child: const Text('อัปเดตประเภทค่าใช้จ่าย'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
