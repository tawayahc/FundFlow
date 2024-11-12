import 'package:flutter/material.dart';
import 'package:fundflow/core/widgets/custom_tab.dart';

import '../../../core/themes/app_styles.dart';
import 'bar_chart.dart';

class TabOverview extends StatefulWidget {
  const TabOverview({super.key});

  @override
  State<TabOverview> createState() => TabOverviewState();
}

class TabOverviewState extends State<TabOverview> with SingleTickerProviderStateMixin{
  String _type = 'daily';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = ['daily', 'monthly'].indexOf(_type);

    _tabController.addListener(() {
      setState(() {
        _type = ['daily', 'monthly'][_tabController.index];
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.lightBlueAccent,
          ),
          // -------------- **bar chart here
          child: const ExpenseBarChart(),
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
            SummaryCard(true, 'ยอดรวมเงินเข้า (บาท)', 10000.00, 5, 200.5),
            SummaryCard(false, 'ยอดรวมเงินออก (บาท)', 10000.00, 7, 150.56)
          ],
        ),
        const SizedBox(height: 10,),
        CustomTab(
          tabController: _tabController,
          tabs: const [
            Tab(text: 'รายวัน'),
            Tab(text: 'รายเดือน'),
          ],
          shadowOpacity: 0.5,
          blurRadius: 5,
          indicatorDecoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
        ),
      ],
    );
  }
}

Widget SummaryCard(bool type, String title, double amount, double items, double avgPerMonth) {
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
              style: TextStyle(fontSize: 11, color: Colors.grey[700], fontWeight: FontWeight.bold),
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

Widget Dropdown(String label) {
  return Expanded(
    child: DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: ['เงินเข้า-เงินออก', 'เงินเข้า', 'เงินออก'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {},
    ),
  );
}
