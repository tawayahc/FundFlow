import 'package:flutter/material.dart';
import 'package:fundflow/features/manageBankAccount/ui/transaction_item.dart';
import 'package:fundflow/features/manageBankAccount/ui/transaction_lists.dart';

import '../../../core/themes/app_styles.dart';

class BankAccountPage extends StatelessWidget {
  const BankAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pushNamed(context, '/pocket_management'); // ย้อนกลับไปยังหน้าก่อนหน้า
              },
            ),
            //---------- **รูปธนาคาร
            Row(
              children: [
                // รูปธนาคาร
                CircleAvatar(
                  radius: 24,
                  // backgroundImage: ,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ชื่อธนาคาร
                    Text(
                      'กสิกร',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    // ชื่อเต็ม
                    Text(
                      'ธนาคารกสิกรไทย',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            //---------- **กล่องเงิน
            Container(
              padding: EdgeInsets.fromLTRB(0, 8, 4, 0), // padding (left, top, right, bottom)
              width: 296, // สุดขอบ
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 16),
                      Text(
                        'ยอดเงินคงเหลือ',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 0),
                  Divider(
                    color: Colors.white,
                    thickness: 2,
                    height: 3,
                    indent: 2,
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      '฿ 1000000.00',
                      style: TextStyle(
                          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
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
            SizedBox(height: 30),
            Text(
              'ประวัติการทำรายการ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            // Transaction ตรงนี้
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final transaction = transactions[index];
                        return TransactionItem(
                          amount: transaction.amount,
                          category: transaction.category,
                          type: transaction.type,
                        );
                      },
                      childCount: transactions.length,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
