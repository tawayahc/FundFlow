import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/core/widgets/home/category_card.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_event.dart';
import 'package:fundflow/features/home/bloc/category/category_state.dart';
import 'package:fundflow/features/home/models/category.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/custom_text_ip.dart';
import 'package:fundflow/core/widgets/navBar/main_layout.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  TextEditingController categoryController = TextEditingController();
  TextEditingController amountController =
      TextEditingController(); // Controller for amount input
  Color selectedColor =
      const Color(0xFFFFA726); // Default color to match provided colors
  double categoryAmount = 0.00;

  // Updated color palette to match provided colors in the image
  final List<Color> availableColors = [
    const Color(0xFFB39DDB), // Purple
    const Color(0xFF64B5F6), // Light Blue
    const Color(0xFF4DD0E1), // Cyan
    const Color(0xFF81C784), // Green
    const Color(0xFFAED581), // Light Green
    const Color(0xFFFFF176), // Yellow
    const Color(0xFFFFA726), // Orange
    const Color(0xFFE57373), // Red
    const Color(0xFFF06292), // Pink
    const Color(0xFFF8BBD0), // Light Pink
    const Color(0xFFE0E0E0), // Light Gray
    const Color(0xFF757575), // Dark Gray
    const Color(0xFF000000), // Black
  ];

  final List<String> categoryTags = [
    'อาหาร',
    'ช็อปปิ้ง',
    'สัตว์เลี้ยง',
    'ที่อยู่',
    'รางวัลตัวเอง',
    'ลูก',
  ];

  String selectedTag = 'อาหาร';

  @override
  Widget build(BuildContext context) {
    return GlobalPadding(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            iconSize: 20,
            color: AppColors.darkGrey,
            onPressed: () {
              Navigator.pop(context); // กลับไปหน้าก่อนหน้า (SettingsPage)
            },
          ),
          title: const Text('เพิ่มหมวดหมู่',
              style: TextStyle(color: AppColors.darkGrey, fontSize: 24)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<CategoryBloc, CategoryState>(
            listener: (context, state) {
              if (state is CategoryAdded) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const BottomNavBar()),
                );
              } else if (state is CategoryError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to load categories')),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                // Category Card Preview
                Center(
                  child: CategoryCard(
                    category: Category(
                      id: -1,
                      name: categoryController.text.isNotEmpty
                          ? categoryController.text
                          : 'ตัวอย่างประเภทค่าใช้จ่าย',
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

                // Category Name Input
                // Replace CategoryNameInput with CustomTextInput for category name input
                TextInput(
                  controller: categoryController,
                  hintText: 'กรอกชื่อหมวดหมู่',
                  labelText: 'ระบุหมวดหมู่',
                  icon: Icons.category, // Set the icon here
                  onChanged: (value) {
                    setState(() {
                      selectedTag = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                // Category Tag Selection arranged in two rows of three tags
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

                // Replace existing button with CustomButton
                CustomButton(
                  text: 'ยืนยัน',
                  onPressed: () {
                    if (categoryController.text.isNotEmpty) {
                      final newCategory = Category(
                        id: -1,
                        name: categoryController.text,
                        amount: categoryAmount,
                        color: selectedColor,
                      );

                      BlocProvider.of<CategoryBloc>(context)
                          .add(AddCategory(category: newCategory));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Separate widget for Category Name Input with focus styling
class CategoryNameInput extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const CategoryNameInput({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  _CategoryNameInputState createState() => _CategoryNameInputState();
}

class _CategoryNameInputState extends State<CategoryNameInput> {
  Color iconColor = AppColors.icon;
  Color textColor = AppColors.icon;

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'ระบุหมวดหมู่',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

// Category Tag Selection with two rows of three tags, matching width of the input box
class CategoryTagSelection extends StatelessWidget {
  final List<String> tags;
  final String selectedTag;
  final ValueChanged<String> onTagSelected;

  const CategoryTagSelection({
    super.key,
    required this.tags,
    required this.selectedTag,
    required this.onTagSelected,
  });

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
                          ? AppColors.darkBlue
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
                            ? AppColors.darkBlue
                            : AppColors.darkGrey,
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

class ColorSelector extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  // Define the colors list
  final List<Color> colors = [
    const Color(0xFFB39DDB), // Purple
    const Color(0xFF64B5F6), // Light Blue
    const Color(0xFF4DD0E1), // Cyan
    const Color(0xFF81C784), // Green
    const Color(0xFFAED581), // Light Green
    const Color(0xFFFFF176), // Yellow
    const Color(0xFFFFA726), // Orange
    const Color(0xFFE57373), // Red
    const Color(0xFFF06292), // Pink
    const Color(0xFFF8BBD0), // Light Pink
    const Color(0xFFE0E0E0), // Light Gray
    const Color(0xFF757575), // Dark Gray
    const Color(0xFF000000), // Black
  ];

  ColorSelector({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
          'เลือกสี',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
                      ? Border.all(width: 2.5, color: AppColors.darkBlue)
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
