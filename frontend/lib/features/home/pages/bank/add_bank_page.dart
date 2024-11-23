import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/core/widgets/navBar/main_layout.dart';
import 'package:fundflow/features/home/bloc/bank/bank_bloc.dart';
import 'package:fundflow/features/home/bloc/bank/bank_event.dart';
import 'package:fundflow/features/home/bloc/bank/bank_state.dart';
import 'package:fundflow/features/home/models/bank.dart';
import 'package:fundflow/features/home/pages/home_page.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/custom_text_ip.dart';

class AddBankPage extends StatefulWidget {
  const AddBankPage({super.key});

  @override
  _AddBankPageState createState() => _AddBankPageState();
}

class _AddBankPageState extends State<AddBankPage> {
  String bankName = '';
  String selectedBank = 'กสิกรไทย';
  String selectedLogo = 'assets/LogoBank/Kplus.png';
  double bankAmount = 0.0;

  final List<Map<String, String>> availableBank = [
    {'กสิกรไทย': 'assets/LogoBank/Kplus.png'},
    {'กรุงไทย': 'assets/LogoBank/Krungthai.png'},
    {'ไทยพาณิชย์': 'assets/LogoBank/SCB.png'},
    {'กรุงเทพ': 'assets/LogoBank/Krungthep.png'},
    {'ออมสิน': 'assets/LogoBank/GSB.png'},
    {'กรุงศรี': 'assets/LogoBank/krungsri.png'},
    {'ธนชาติ': 'assets/LogoBank/ttb.png'},
    {'เกียรตินาคิน': 'assets/LogoBank/knk.png'},
    {'City': 'assets/LogoBank/city.png'},
    {'Make': 'assets/LogoBank/make.png'},
  ];

  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController bankAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GlobalPadding(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            iconSize: 20,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: const Text(
            'เพิ่มธนาคาร',
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
              if (state is BankAdded) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNavBar()),
                );
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
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: availableBank.length,
                  itemBuilder: (context, index) {
                    final bank = availableBank[index];
                    final bankName = bank.keys.first;
                    final bankLogo = bank.values.first;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedBank = bankName;
                          selectedLogo = bankLogo;
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.2), // Shadow color
                                  spreadRadius: 1, // Spread radius
                                  blurRadius: 4, // Blur radius
                                  offset: const Offset(0, 0), // Shadow position
                                ),
                              ],
                              border: Border.all(
                                width: 2,
                                color: selectedBank == bankName
                                    ? Color(0xFF41486D)
                                    : Colors.transparent,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                bankLogo,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons
                                      .error); // Fallback if image fails to load
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            bankName,
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
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
                TextInput(
                  controller: bankAmountController,
                  hintText: 'กรอกจำนวนเงิน',
                  labelText: 'ระบุจำนวนเงิน',
                  icon: Icons.wallet,
                  onChanged: (value) {
                    setState(() {
                      bankAmount = double.tryParse(value) ?? 0.0;
                    });
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'ยืนยัน',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
