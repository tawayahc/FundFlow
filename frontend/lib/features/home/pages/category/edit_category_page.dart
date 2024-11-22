import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/core/widgets/home/category_card.dart';
import 'package:fundflow/core/widgets/navBar/main_layout.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_event.dart';
import 'package:fundflow/features/home/bloc/category/category_state.dart';
import 'package:fundflow/features/home/models/category.dart';
import 'package:fundflow/features/home/pages/home_page.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/custom_text_ip.dart';

class EditCategoryPage extends StatefulWidget {
  final Category category;

  const EditCategoryPage({super.key, required this.category});

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  late TextEditingController categoryController;
  late Color selectedColor;
  late double categoryAmount;
  late String selectedTag;

  final List<Color> availableColors = [
    Color(0xFFB39DDB), // Purple
    Color(0xFF64B5F6), // Light Blue
    Color(0xFF4DD0E1), // Cyan
    Color(0xFF81C784), // Green
    Color(0xFFAED581), // Light Green
    Color(0xFFFFF176), // Yellow
    Color(0xFFFFA726), // Orange
    Color(0xFFE57373), // Red
    Color(0xFFF06292), // Pink
    Color(0xFFF8BBD0), // Light Pink
    Color(0xFFE0E0E0), // Light Gray
    Color(0xFF757575), // Dark Gray
    Color(0xFF000000), // Black
  ];

  final List<String> categoryTags = [
    'อาหาร',
    'ช็อปปิ้ง',
    'สัตว์เลี้ยง',
    'ที่อยู่',
    'รางวัลตัวเอง',
    'ลูก',
  ];

  late Category originalCategory;

  @override
  void initState() {
    super.initState();
    originalCategory = widget.category;

    categoryController = TextEditingController(text: originalCategory.name);
    selectedColor = originalCategory.color;
    categoryAmount = originalCategory.amount;
    selectedTag = categoryTags.contains(originalCategory.name)
        ? originalCategory.name
        : '';

    // Add listener to update UI when text changes
    categoryController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalPadding(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'แก้ไขหมวดหมู่',
            style: TextStyle(color: Color(0xFF414141)),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<CategoryBloc, CategoryState>(
            listener: (context, state) {
              if (state is CategoryUpdated) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const GlobalPadding(child: BottomNavBar())),
                );
              } else if (state is CategoryError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to update category')),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Category Card Preview
                Center(
                  child: CategoryCard(
                    category: Category(
                      id: originalCategory.id,
                      name: categoryController.text.isNotEmpty
                          ? categoryController.text
                          : 'ตัวอย่างหมวดหมู่',
                      amount: categoryAmount,
                      color: selectedColor,
                    ),
                    height: 120,
                    width: 320,
                    fontSize: 15,
                    amountFontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),

                TextInput(
                  controller: categoryController,
                  hintText: 'กรอกชื่อหมวดหมู่',
                  labelText: 'ระบุหมวดหมู่',
                  icon: Icons.category,
                  onChanged: (value) {
                    setState(() {
                      selectedTag = categoryTags.contains(value) ? value : '';
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Category Tag Selection
                CategoryTagSelection(
                  tags: categoryTags,
                  selectedTag: selectedTag,
                  onTagSelected: (tag) {
                    setState(() {
                      selectedTag = tag;
                      categoryController.text = tag;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Color Selector
                ColorSelector(
                  selectedColor: selectedColor,
                  onColorSelected: (color) {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                ),
                const SizedBox(height: 40),

                // Custom Button
                CustomButton(
                  text: 'ยืนยันการแก้ไข',
                  onPressed: () {
                    if (categoryController.text.isNotEmpty) {
                      final updatedCategory = Category(
                        id: originalCategory.id,
                        name: categoryController.text,
                        amount: categoryAmount,
                        color: selectedColor,
                      );

                      BlocProvider.of<CategoryBloc>(context).add(
                        EditCategory(
                          originalCategory: originalCategory,
                          category: updatedCategory,
                        ),
                      );
                    }
                  },
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      BlocProvider.of<CategoryBloc>(context)
                          .add(DeleteCategory(categoryId: originalCategory.id));
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Color(0xFFFF5C5C),
                        ),
                        Text(
                          'ลบธนาคาร',
                          style: TextStyle(
                            color: Color(0xFFFF5C5C),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
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

// สร้าง CustomTextInput Widget
class CustomTextInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final ValueChanged<String> onChanged;

  const CustomTextInput({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomTextInputState createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  Color iconColor = Color(0xFFD0D0D0);
  Color textColor = Color(0xFFD0D0D0);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF414141),
          ),
        ),
        const SizedBox(height: 10),
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              iconColor = hasFocus ? Color(0xFF41486D) : Color(0xFFD0D0D0);
              textColor = hasFocus ? Color(0xFF414141) : Color(0xFFD0D0D0);
            });
          },
          child: TextField(
            controller: widget.controller,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Color(0xFFD0D0D0)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Color(0xFFD0D0D0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Color(0xFF41486D)),
              ),
              prefixIcon: Icon(
                Icons.category,
                color: iconColor,
              ),
            ),
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }
}

// CategoryTagSelection Widget
class CategoryTagSelection extends StatelessWidget {
  final List<String> tags;
  final String selectedTag;
  final ValueChanged<String> onTagSelected;

  const CategoryTagSelection({
    Key? key,
    required this.tags,
    required this.selectedTag,
    required this.onTagSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Divide tags into two rows with three tags each
    List<List<String>> rows = [
      tags.sublist(0, 3), // First three tags
      tags.sublist(3, 6), // Last three tags
    ];

    return Column(
      children: rows.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: row.map((tag) {
            return Expanded(
              child: GestureDetector(
                onTap: () => onTagSelected(tag),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selectedTag == tag
                          ? Color(0xFF41486D)
                          : Colors.grey.shade300,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: selectedTag == tag
                            ? Color(0xFF41486D)
                            : Color(0xFF414141),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

// ColorSelector Widget
class ColorSelector extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  // Define the colors list
  final List<Color> colors = [
    Color(0xFFB39DDB), // Purple
    Color(0xFF64B5F6), // Light Blue
    Color(0xFF4DD0E1), // Cyan
    Color(0xFF81C784), // Green
    Color(0xFFAED581), // Light Green
    Color(0xFFFFF176), // Yellow
    Color(0xFFFFA726), // Orange
    Color(0xFFE57373), // Red
    Color(0xFFF06292), // Pink
    Color(0xFFF8BBD0), // Light Pink
    Color(0xFFE0E0E0), // Light Gray
    Color(0xFF757575), // Dark Gray
    Color(0xFF000000), // Black
  ];

  ColorSelector({
    Key? key,
    required this.selectedColor,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'เลือกสี',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF414141)),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6, // 6 colors per row
            crossAxisSpacing: 30,
            mainAxisSpacing: 10,
          ),
          itemCount: colors.length,
          itemBuilder: (context, index) {
            final color = colors[index];
            return GestureDetector(
              onTap: () => onColorSelected(color),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: selectedColor == color
                      ? Border.all(width: 2.5, color: const Color(0xFF41486D))
                      : Border.all(
                          width: 1.5,
                          color: const Color.fromARGB(0, 42, 32, 32)),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
