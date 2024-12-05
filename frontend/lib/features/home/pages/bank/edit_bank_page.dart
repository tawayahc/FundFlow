import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/custom_modal.dart';
import 'package:fundflow/core/widgets/home/bank_balance_box.dart';
import 'package:fundflow/core/widgets/navBar/main_layout.dart';
import 'package:fundflow/models/bank_model.dart';
import 'package:fundflow/utils/bank_color_util.dart';
import 'package:fundflow/utils/bank_logo_util.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/core/widgets/custom_text_ip.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/features/home/bloc/bank/bank_bloc.dart';
import 'package:fundflow/features/home/bloc/bank/bank_event.dart';
import 'package:fundflow/features/home/bloc/bank/bank_state.dart';

class EditBankPage extends StatefulWidget {
  final Bank bank;

  const EditBankPage({
    super.key,
    required this.bank,
  });

  @override
  _EditBankPageState createState() => _EditBankPageState();
}

class _EditBankPageState extends State<EditBankPage> {
  late String bankName;
  late String selectedBank;
  late TextEditingController bankNameController;
  late TextEditingController bankAmountController;

  @override
  void initState() {
    super.initState();
    bankName = widget.bank.name;
    selectedBank = widget.bank.bankName;
    bankNameController = TextEditingController(text: bankName);
    bankAmountController = TextEditingController(
      text: widget.bank.amount.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    bankNameController.dispose();
    bankAmountController.dispose();
    super.dispose();
  }

  bool _isDialogShowing = false;

  void _showModal(BuildContext context, String text) {
    if (_isDialogShowing) {
      return;
    }

    _isDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.1),
      builder: (BuildContext context) {
        return CustomModal(text: text);
      },
    ).then((_) {
      _isDialogShowing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalPadding(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            iconSize: 20,
            onPressed: () {
              Navigator.pop(context); // Back to the previous page
            },
          ),
          centerTitle: true,
          title: const Text(
            'แก้ไขธนาคาร',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<BankBloc, BankState>(
            listener: (context, state) {
              if (state is BankUpdated || state is BankDeleted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const BottomNavBar()),
                );
              } else if (state is BankError) {
                _showModal(context, 'แก้ไขธนาคารไม่สำเร็จ');
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'เลือกธนาคาร',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // โลโก้ธนาคาร
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          BankLogoUtil.getBankLogo(widget.bank.bankName),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint(
                                'Error loading image for ${widget.bank.bankName}');
                            return const Icon(Icons.error, color: Colors.red);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // ชื่อธนาคารและกล่องยอดเงิน
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.bank.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGrey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.bank.bankName,
                            style: const TextStyle(
                              color: AppColors.darkGrey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
// กล่องยอดเงินคงเหลือ
                Align(
                  alignment: Alignment.center, // จัดชิดซ้าย
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0), // ระยะห่างจากซ้าย
                    child: BankBalanceBox(
                      title: 'ยอดเงินคงเหลือ',
                      amount: widget.bank.amount,
                      color: BankColorUtil.getBankColor(widget.bank.bankName),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                // Bank Name Input
                TextInput(
                  controller: bankNameController,
                  hintText: 'กรอกชื่อกล่องธนาคาร (ไม่จำเป็น)',
                  labelText: 'ชื่อกล่องธนาคาร',
                  icon: Icons.edit,
                  onChanged: (value) {
                    setState(() {
                      bankName = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                // Bank Amount Input
                TextInput(
                  controller: bankAmountController,
                  hintText: 'กรอกจำนวนเงิน',
                  labelText: 'ระบุจำนวนเงิน',
                  icon: Icons.wallet,
                  onChanged: (value) {},
                ),
                const SizedBox(height: 30),
                // Save Button
                CustomButton(
                  text: 'ยืนยันการแก้ไข',
                  onPressed: () {
                    final updatedBank = Bank(
                      id: widget.bank.id,
                      name: bankName,
                      bankName: selectedBank,
                      amount: double.tryParse(bankAmountController.text) ?? 0.0,
                    );

                    BlocProvider.of<BankBloc>(context).add(EditBank(
                      originalBank: widget.bank,
                      bank: updatedBank,
                    ));
                  },
                ),
                const SizedBox(height: 0),
                Center(
                  child: TextButton(
                    onPressed: () {
                      BlocProvider.of<BankBloc>(context).add(DeleteBank(
                        bankId: widget.bank.id,
                      ));
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
