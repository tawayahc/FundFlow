import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/navBar/main_layout.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_event.dart';
import 'package:fundflow/features/home/bloc/category/category_state.dart';
import 'package:fundflow/features/home/models/category.dart';
import 'package:fundflow/core/widgets/custom_text_ip.dart';

class TransferCategoryAmount extends StatelessWidget {
  final Category fromCategory;
  final Category toCategory;

  const TransferCategoryAmount({
    super.key,
    required this.fromCategory,
    required this.toCategory,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = TextEditingController();

    bool isCashBoxInvolved(Category category) => category.id == -1;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width:
            MediaQuery.of(context).size.width * 0.9, // Modal width adjustment
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: BlocListener<CategoryBloc, CategoryState>(
            listener: (context, state) {
              if (state is CategoryTransferred ||
                  state is CategoryAmountUpdated) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BottomNavBar(),
                  ),
                );
              } else if (state is CategoryError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to load categories')),
                );
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title and Close Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ย้ายเงินไป',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGrey, // Text color
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: AppColors.icon, size: 35),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // From and To Categories
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // From Category Icon
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Shadow color
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: fromCategory.id == -1
                                ? Colors.transparent
                                : fromCategory.color,
                            child: fromCategory.id == -1
                                ? ClipOval(
                                    child: Image.asset(
                                      'assets/CashBox.png',
                                      fit: BoxFit.cover,
                                      width: 60,
                                      height: 60,
                                    ),
                                  )
                                : Text(
                                    fromCategory.name[0],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          fromCategory.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    const Icon(Icons.arrow_forward,
                        size: 32, color: Colors.red),
                    const SizedBox(width: 20),
                    // To Category Icon
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: toCategory.color,
                            child: Text(
                              toCategory.name[0],
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          toCategory.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Amount Input
                TextInput(
                  controller: amountController,
                  hintText: 'ระบุจำนวนเงิน',
                  labelText: 'ระบุจำนวนเงิน',
                  icon: Icons.wallet, // Wallet icon
                  onChanged: (value) {},
                ),
                const SizedBox(height: 20),

                // Confirm Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkBlue, // Custom color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(150, 45), // Adjust button size
                  ),
                  onPressed: () {
                    final amount = double.tryParse(amountController.text);
                    if (amount != null && amount > 0) {
                      if (isCashBoxInvolved(fromCategory)) {
                        BlocProvider.of<CategoryBloc>(context).add(
                          UpdateAmount(
                            categoryId: toCategory.id,
                            newAmount: toCategory.amount + amount,
                          ),
                        );
                      } else if (isCashBoxInvolved(toCategory)) {
                        BlocProvider.of<CategoryBloc>(context).add(
                          UpdateAmount(
                            categoryId: fromCategory.id,
                            newAmount: fromCategory.amount - amount,
                          ),
                        );
                      } else {
                        BlocProvider.of<CategoryBloc>(context).add(
                          TransferAmount(
                            fromCategoryId: fromCategory.id,
                            toCategoryId: toCategory.id,
                            amount: amount,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('กรุณากรอกจำนวนเงินที่ถูกต้อง')),
                      );
                    }
                  },
                  child: const Text(
                    'ยืนยัน',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
