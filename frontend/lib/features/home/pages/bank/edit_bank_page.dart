import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/home/bloc/bank/bank_bloc.dart';
import 'package:fundflow/features/home/bloc/bank/bank_event.dart';
import 'package:fundflow/features/home/bloc/bank/bank_state.dart';
import 'package:fundflow/features/home/models/bank.dart';
import 'package:fundflow/features/home/pages/home_page.dart';
import 'package:fundflow/core/widgets/custom_text_ip.dart';
import 'package:fundflow/core/widgets/custom_button.dart';

class EditBankPage extends StatefulWidget {
  final Bank bank;

  const EditBankPage({Key? key, required this.bank}) : super(key: key);
  

  @override
  _EditBankPageState createState() => _EditBankPageState();
}

class _EditBankPageState extends State<EditBankPage> {
  late String bankName;
  late String selectedBank;
  late Color selectedColor;
  late double bankAmount = 0.0;

  final List<Map<String, Color>> availableBank = [
    {'กสิกรไทย': Colors.blue},
    {'กรุงไทย': Colors.green},
    {'ไทยพาณิชย์': Colors.red},
    {'กรุงเทพ': Colors.orange},
    {'ออมสิน': Colors.purple},
  ];

  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController bankAmountController = TextEditingController();

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
    return GlobalPadding(
      child: Scaffold(
        appBar: AppBar(
          leading: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                iconSize: 20,
                onPressed: () {
                  Navigator.pop(context); // กลับไปหน้าก่อนหน้า (SettingsPage)
                },
              ),
            ],
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
              if (state is BankUpdated) {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Bank updated successfully')),
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
                Row(
                children: [
                  // รูปธนาคาร
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color.fromARGB(255, 7, 39, 156),
                    // backgroundImage: ,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ชื่อธนาคาร
                      Text(
                        widget.bank.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      // ชื่อเต็ม
                      Text(
                        widget.bank.bank_name,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              //---------- **กล่องเงิน
                Container(
                padding: const EdgeInsets.fromLTRB(
                    0, 8, 4, 0), // padding (left, top, right, bottom)
                width: 296, 
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 7, 39, 156),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        SizedBox(width: 16),
                        Text(
                          'ยอดเงินคงเหลือ',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 2,
                      height: 3,
                      indent: 2,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        '฿ ${widget.bank.amount}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'ข้อมูล ณ เวลา 00:00 น.',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
              ),
                const SizedBox(height: 20),
                // Bank Name Input
                   TextInput(
                  controller: bankNameController,
                  hintText: 'กรอกชื่อกล่องธนาคาร(ไม่จำเป็น)',
                  labelText: 'ชื่อกล่องธนาคาร',
                  icon: Icons.edit,
                  onChanged: (value) {
                    setState(() {
                      bankName = value;
                    });
                  },
                ),

                const SizedBox(height: 20),
                // Display the bank's amount (not editable)
                 TextInput(
                  controller: bankAmountController ,
                  hintText: 'กรอกจำนวนเงิน',
                  labelText: 'ระบุจำนวนเงิน',
                  icon: Icons.wallet,
                  onChanged: (value) {
                    setState(() {
                      bankName = value;
                    });
                  },
                ),
                
                const SizedBox(height: 20),
                // Save Button
                CustomButton(
                    text: 'ยืนยันการแก้ไข',
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
                ),
                 Center(child: TextButton(onPressed: () {
                  //make function to delete bank account
                 } , 
                 child: Row(
                        mainAxisSize: MainAxisSize.min,
                          children: const [
                              Icon(Icons.delete,
                                    color: Color(0xFFFF5C5C),),
                              Text('ลบธนาคาร',
                                    style: TextStyle(
                                    color: Color(0xFFFF5C5C),
                                    fontSize: 14,),
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