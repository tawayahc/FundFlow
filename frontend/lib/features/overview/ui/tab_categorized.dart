import 'package:flutter/material.dart';
import 'package:fundflow/features/overview/widget/bar_chart.dart';

class TabCategorized extends StatefulWidget {
  const TabCategorized({super.key});

  @override
  State<TabCategorized> createState() => TabCategorizedState();
}

class TabCategorizedState extends State<TabCategorized> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.lightBlueAccent,
          ),
          // child: ExpenseBarChart(),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            SummaryCard(true, 'ยอดรวมเงินเข้า (บาท)', 10000.00, 5, 200.5),
            SummaryCard(false, 'ยอดรวมเงินออก (บาท)', 10000.00, 7, 150.56)
          ],
        ),
        const SizedBox(height: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [Text('ประเภทรายการ'), Text('Dropdown here')],
                ),
                Column(
                  children: [Text('ช่วงเวลา'), Text('Date picker here')],
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 710,
          child: Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    RoutineSummaryItem('พ.ย. 67', 9780.94, 8076.00, 1704.94),
                    RoutineSummaryItem('พ.ย. 67', 9780.94, 8076.00, 1704.94),
                    RoutineSummaryItem('พ.ย. 67', 9780.94, 8076.00, 1704.94),
                    RoutineSummaryItem('พ.ย. 67', 9780.94, 8076.00, 1704.94),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget SummaryCard(
    bool type, String title, double amount, double items, double avgPerMonth) {
  Color numColor;
  type ? numColor = Colors.green : numColor = Colors.red;
  return Expanded(
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              amount.toStringAsFixed(2),
              style: TextStyle(fontSize: 13, color: numColor),
            ),
            Row(
              children: [
                Text(
                  "รายการ",
                  style: TextStyle(fontSize: 9, color: Colors.grey[600]),
                ),
                const Spacer(),
                Text(
                  items.toStringAsFixed(0),
                  style: TextStyle(fontSize: 9, color: numColor),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'เฉลี่ยต่อเดือน',
                  style: TextStyle(fontSize: 9, color: Colors.grey[600]),
                ),
                const Spacer(),
                Text(
                  avgPerMonth.toStringAsFixed(2),
                  style: TextStyle(fontSize: 9, color: numColor),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget RoutineSummaryItem(
    String month, double totalIn, double totalOut, double balance) {
  Color balanceColor;
  totalIn - totalOut > 0
      ? balanceColor = Colors.green
      : balanceColor = Colors.red;
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            month,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800]),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("เงินเข้าทั้งหมด",
                  style: TextStyle(color: Colors.grey[600])),
              Text(totalIn.toStringAsFixed(2),
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("เงินออกทั้งหมด", style: TextStyle(color: Colors.grey[600])),
              Text(totalOut.toStringAsFixed(2),
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("สรุปยอด", style: TextStyle(color: Colors.grey[600])),
              Text(balance.toStringAsFixed(2),
                  style: TextStyle(
                      color: balanceColor, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    ),
  );
}
