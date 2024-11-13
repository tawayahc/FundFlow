import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/home/bloc/bank/bank_bloc.dart';
import 'package:fundflow/features/home/bloc/bank/bank_event.dart';
import 'package:fundflow/features/home/bloc/bank/bank_state.dart';
import 'package:fundflow/features/home/models/bank.dart';
import 'package:fundflow/features/home/pages/home_page.dart';

class AddBankPage extends StatefulWidget {
  const AddBankPage({Key? key}) : super(key: key);

  @override
  _AddBankPageState createState() => _AddBankPageState();
}

class _AddBankPageState extends State<AddBankPage> {
  String bankName = '';
  String selectedBank = 'กสิกรไทย';
  Color selectedColor = Colors.blue;
  double bankAmount = 0.0;

  final List<Map<String, Color>> availableBank = [
    {'กสิกรไทย': Colors.blue},
    {'กรุงไทย': Colors.green},
    {'ไทยพาณิชย์': Colors.red},
    {'กรุงเทพ': Colors.orange},
    {'ออมสิน': Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    return GlobalPadding(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('เพิ่มธนาคาร'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<BankBloc, BankState>(
            listener: (context, state) {
              if (state is BankAdded) {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Bank added successfully')),
                // );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const GlobalPadding(child: HomePage())),
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
                // Bank Amount Input
                const Text(
                  'ยอดเงินเริ่มต้น',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'กรอกยอดเงินเริ่มต้น',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      bankAmount = double.tryParse(value) ?? 0.0;
                    });
                  },
                ),
                const SizedBox(height: 20),
                // Save Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (bankName.isNotEmpty && selectedBank.isNotEmpty) {
                        final newBank = Bank(
                          id: -1,
                          name: bankName,
                          bank_name: 'ธนาคาร$selectedBank',
                          amount: bankAmount,
                        );

                        BlocProvider.of<BankBloc>(context)
                            .add(AddBank(bank: newBank));
                      }
                    },
                    child: const Text('เพิ่มธนาคาร'),
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
