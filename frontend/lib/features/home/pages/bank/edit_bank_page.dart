import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/core/widgets/navBar/main_layout.dart';
import 'package:fundflow/features/home/bloc/bank/bank_bloc.dart';
import 'package:fundflow/features/home/bloc/bank/bank_event.dart';
import 'package:fundflow/features/home/bloc/bank/bank_state.dart';
import 'package:fundflow/features/home/models/bank.dart';
import 'package:fundflow/features/home/pages/home_page.dart';

class EditBankPage extends StatefulWidget {
  final Bank bank;

  const EditBankPage({super.key, required this.bank});

  @override
  _EditBankPageState createState() => _EditBankPageState();
}

class _EditBankPageState extends State<EditBankPage> {
  late String bankName;
  late String selectedBank;
  late Color selectedColor;

  final List<Map<String, Color>> availableBank = [
    {'กสิกรไทย': Colors.blue},
    {'กรุงไทย': Colors.green},
    {'ไทยพาณิชย์': Colors.red},
    {'กรุงเทพ': Colors.orange},
    {'ออมสิน': Colors.purple},
  ];

  late Bank originalBank;

  @override
  void initState() {
    super.initState();

    originalBank = widget.bank;

    bankName = originalBank.name;
    selectedBank = originalBank.bank_name.replaceFirst('ธนาคาร', '');
    selectedColor = _getBankColor(selectedBank);
  }

  Color _getBankColor(String bankName) {
    switch (bankName) {
      case 'กสิกรไทย':
        return Colors.blue;
      case 'กรุงไทย':
        return Colors.green;
      case 'ไทยพาณิชย์':
        return Colors.red;
      case 'กรุงเทพ':
        return Colors.orange;
      case 'ออมสิน':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขธนาคาร'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<BankBloc, BankState>(
          listener: (context, state) {
            if (state is BankUpdated) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text('Bank updated successfully')),
              // );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BottomNavBar()),
              );
              // Navigator.pop(context); // Go back to the previous screen
            } else if (state is BankError) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text('Failed to load banks')),
              // );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'เลือกธนาคาร',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Bank Color Boxes with Names
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // 5 banks per row
                  childAspectRatio: 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: availableBank.length,
                itemBuilder: (context, index) {
                  final bank = availableBank[index];
                  final bankName = bank.keys.first;
                  final bankColor = bank.values.first;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedBank = bankName;
                        selectedColor = bankColor;
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: bankColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 2,
                                color: selectedColor == bankColor
                                    ? Colors.black
                                    : Colors.transparent),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          bankName,
                          style: const TextStyle(fontSize: 8),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Bank Name Input
              const Text(
                'ชื่อบัญชีธนาคาร',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'กรอกชื่อบัญชีธนาคาร',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    bankName = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Display the bank's amount (not editable)
              const Text(
                'ยอดเงินปัจจุบัน',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                '฿ ${widget.bank.amount}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (bankName.isNotEmpty && selectedBank.isNotEmpty) {
                      final updatedBank = Bank(
                        id: widget.bank.id, // Preserve the original bank ID
                        name: bankName,
                        bank_name: 'ธนาคาร$selectedBank',
                        amount: widget.bank.amount, // Keep the original amount
                      );

                      BlocProvider.of<BankBloc>(context).add(EditBank(
                          originalBank: originalBank, bank: updatedBank));
                    }
                  },
                  child: const Text('บันทึกการเปลี่ยนแปลง'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
