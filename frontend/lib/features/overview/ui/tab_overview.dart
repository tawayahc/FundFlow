import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:fundflow/core/widgets/custom_tab.dart';

import '../../../core/themes/app_styles.dart';
import '../../../core/widgets/overview/summary_card.dart';
import 'bar_chart.dart';

class TabOverview extends StatefulWidget {
  const TabOverview({super.key});

  @override
  State<TabOverview> createState() => TabOverviewState();
}

class TabOverviewState extends State<TabOverview>
    with SingleTickerProviderStateMixin {
  String _type = 'daily';
  late TabController _tabController;
  String? selectedValue;

  late SingleValueDropDownController _cnt;
  final List<String> dropDownItems = [
    "เงินเข้า-เงินออก",
    "เงินเข้า",
    "เงินออก"
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = ['daily', 'monthly'].indexOf(_type);
    _cnt = SingleValueDropDownController();

    _tabController.addListener(() {
      setState(() {
        _type = ['daily', 'monthly'][_tabController.index];
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    // _cnt.dispose();
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
          child: const ExpenseBarChart(),
        ),
        const SizedBox(height: 10),
        const Row(
          children: [
            SummaryCard(type: true, title: 'ยอดรวมเงินเข้า (บาท)', amount: 10000.00, items: 5, avgPerMonth: 200.5),
            SummaryCard(type: false, title: 'ยอดรวมเงินออก (บาท)', amount: 10000.00, items: 7, avgPerMonth: 150.56,)
          ],
        ),
        const SizedBox(height: 10),
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
        const SizedBox(height: 8),
        SizedBox(
          height:
              690, // Set a fixed height for the TabBarView to avoid unbounded constraints
          child: TabBarView(
            controller: _tabController,
            children: [
              // --------------** Daily Tab
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text('ประเภทรายการ'),
                          SizedBox(
                            width: 150,
                            child: DropDownTextField(
                              textFieldDecoration: const InputDecoration(
                                hintText: 'เงินเข้า-เงินออก', // Placeholder text
                                hintStyle: TextStyle(
                                  color: Colors.grey, // Text color
                                  fontSize: 16, // Font size
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey, // Border color
                                    width: 1.0, // Border width
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey, // Same color as enabled for consistency
                                    width: 1.0,
                                  ),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey, // Border color
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              controller: _cnt,
                              clearOption: true,
                              clearIconProperty: IconProperty(color: Colors.green),
                              validator: (value) {
                                if (value == null) {
                                  return "Required field";
                                } else {
                                  return null;
                                }
                              },
                              dropDownItemCount: 6,
                              dropDownList: const [
                                DropDownValueModel(name: 'name1', value: "value1"),
                                DropDownValueModel(
                                    name: 'name2',
                                    value: "value2",
                                    toolTipMsg:
                                    "DropDownButton is a widget that we can use to select one unique value from a set of values"),
                                DropDownValueModel(name: 'name3', value: "value3"),
                                DropDownValueModel(
                                    name: 'name4',
                                    value: "value4",
                                    toolTipMsg:
                                    "DropDownButton is a widget that we can use to select one unique value from a set of values"),
                                DropDownValueModel(name: 'name5', value: "value5"),
                                DropDownValueModel(name: 'name6', value: "value6"),
                                DropDownValueModel(name: 'name7', value: "value7"),
                                DropDownValueModel(name: 'name8', value: "value8"),
                              ],
                              onChanged: (val) {},
                            ),
                          )
                        ],
                      ),
                      const Column(
                        children: [
                          Text('ช่วงเวลา'),
                          Text('Date picker here')],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '2567',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate([
                            RoutineSummaryItem(
                                'พ.ย. 67', 9780.94, 8076.00, 1704.94),
                            RoutineSummaryItem(
                                'พ.ย. 67', 9780.94, 8076.00, 1704.94),
                            RoutineSummaryItem(
                                'พ.ย. 67', 9780.94, 8076.00, 1704.94),
                            RoutineSummaryItem(
                                'พ.ย. 67', 9780.94, 8076.00, 1704.94),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // --------------** Monthly Tab
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
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
                  const SizedBox(height: 4),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '2567',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate([
                            RoutineSummaryItem(
                                'พ.ย. 67', 9780.94, 8076.00, 1704.94),
                            RoutineSummaryItem(
                                'พ.ย. 67', 9780.94, 8076.00, 1704.94),
                            RoutineSummaryItem(
                                'พ.ย. 67', 9780.94, 8076.00, 1704.94),
                            RoutineSummaryItem(
                                'พ.ย. 67', 9780.94, 8076.00, 1704.94),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
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

Widget ExpenseTypeDropDown(SingleValueDropDownController _cnt, List<String> dropDownItems) {
  return DropDownTextField(
    textFieldDecoration: const InputDecoration(
      hintText: 'เงินเข้า-เงินออก', // Placeholder text
      hintStyle: TextStyle(
        color: Colors.grey, // Text color
        fontSize: 16, // Font size
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey, // Border color
          width: 1.0, // Border width
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey, // Same color as enabled for consistency
          width: 1.0,
        ),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey, // Border color
          width: 1.0,
        ),
      ),
    ),
    controller: _cnt,
    clearOption: true,
    clearIconProperty: IconProperty(color: Colors.green),
    validator: (value) {
      if (value == null) {
        return "Required field";
      } else {
        return null;
      }
    },
    dropDownItemCount: 6,
    dropDownList: const [
      DropDownValueModel(name: 'name1', value: "value1"),
      DropDownValueModel(
          name: 'name2',
          value: "value2",
          toolTipMsg:
          "DropDownButton is a widget that we can use to select one unique value from a set of values"),
      DropDownValueModel(name: 'name3', value: "value3"),
      DropDownValueModel(
          name: 'name4',
          value: "value4",
          toolTipMsg:
          "DropDownButton is a widget that we can use to select one unique value from a set of values"),
      DropDownValueModel(name: 'name5', value: "value5"),
      DropDownValueModel(name: 'name6', value: "value6"),
      DropDownValueModel(name: 'name7', value: "value7"),
      DropDownValueModel(name: 'name8', value: "value8"),
    ],
    onChanged: (val) {},
  );
}
