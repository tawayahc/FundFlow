import 'package:flutter/material.dart';

class AddBankPage extends StatelessWidget {
  const AddBankPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มบัญชีธนาคาร'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('เลือกธนาคาร',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: bankList.length,
                itemBuilder: (context, index) {
                  final bank = bankList[index];
                  return GestureDetector(
                    onTap: () {
                      // Handle bank selection
                    },
                    child: Column(
                      children: [
                        Image.network(bank.logoUrl,
                            height: 50), // Use asset or network images
                        Text(bank.name, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'ชื่อบัญชี',
                hintText: 'กรอกชื่อบัญชีธนาคาร',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                labelText: 'ยอดเงินเริ่มต้น',
                hintText: 'กรอกยอดเงินเริ่มต้น',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save bank account and navigate back
              },
              child: const Text('เพิ่มบัญชีธนาคาร'),
            ),
          ],
        ),
      ),
    );
  }
}

// Example list of banks
final bankList = [
  Bank('ธนาคารกสิกรไทย', 'https://link-to-logo.com/logo1.png'),
  Bank('ธนาคารกรุงไทย', 'https://link-to-logo.com/logo2.png'),
  // Add more banks
];

class Bank {
  final String name;
  final String logoUrl;

  Bank(this.name, this.logoUrl);
}
