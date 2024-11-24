import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/home/bank_balance_box.dart';
import 'package:intl/intl.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/core/widgets/custom_text_ip.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/features/home/models/bank.dart';
import 'package:fundflow/features/home/bloc/bank/bank_bloc.dart';
import 'package:fundflow/features/home/bloc/bank/bank_event.dart';
import 'package:fundflow/features/home/bloc/bank/bank_state.dart';
import 'package:fundflow/features/home/pages/home_page.dart';

class EditBankPage extends StatefulWidget {
  final Bank bank;
  final Map<String, Color> bankColorMap;

  const EditBankPage({
    super.key,
    required this.bank,
    required this.bankColorMap,
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
    selectedBank = widget.bank.bank_name;
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

  @override
  Widget build(BuildContext context) {
    final Color color =
        widget.bankColorMap[widget.bank.bank_name] ?? Colors.grey;

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
              color: Color(0xFF414141),
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
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              } else if (state is BankError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Failed to update bank details')),
                );
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
                      color: Color(0xFF414141)),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Bank Logo
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          _getBankLogo(widget.bank.bank_name),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint(
                                'Error loading image for ${widget.bank.bank_name}');
                            return const Icon(Icons.error, color: Colors.red);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bank Name
                        Text(
                          widget.bank.name,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF414141)),
                        ),
                        // Full Bank Name
                        Text(
                          widget.bank.bank_name,
                          style: const TextStyle(
                              color: Color(0xFF414141), fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // Use BankBalanceBox Widget
                BankBalanceBox(
                  title: 'ยอดเงินคงเหลือ',
                  amount: widget.bank.amount,
                  color: color,
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
                      bank_name: selectedBank,
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

  String _getBankLogo(String bankName) {
    final logos = {
      'ธนาคารกสิกรไทย': 'assets/LogoBank/Kplus.png',
      'ธนาคารกรุงไทย': 'assets/LogoBank/Krungthai.png',
      'ธนาคารไทยพาณิชย์': 'assets/LogoBank/SCB.png',
      'ธนาคารกรุงเทพ': 'assets/LogoBank/Krungthep.png',
      'ธนาคารกรุงศรีอยุธยา': 'assets/LogoBank/krungsri.png',
      'ธนาคารออมสิน': 'assets/LogoBank/GSB.png',
      'ธนาคารธนชาต': 'assets/LogoBank/ttb.png',
      'ธนาคารเกียรตินาคิน': 'assets/LogoBank/knk.png',
      'ธนาคารซิตี้แบงก์': 'assets/LogoBank/city.png',
      'ธนาคารเมกะ': 'assets/LogoBank/make.png',
    };

    return logos[bankName.trim()] ?? 'assets/CashBox.png';
  }
}
