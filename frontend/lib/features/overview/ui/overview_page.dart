import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/overview/ui/tab_categorized.dart';
import 'package:fundflow/features/overview/ui/tab_overview.dart';

import '../../../core/widgets/custom_tab.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<StatefulWidget> createState() => OverviewPageState();
}

class OverviewPageState extends State<OverviewPage> with SingleTickerProviderStateMixin{
  String _type = 'overview';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = ['overview', 'categorized'].indexOf(_type);

    _tabController.addListener(() {
      setState(() {
        _type = ['overview', 'categorized'][_tabController.index];
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
    return GlobalPadding(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 40),
            CustomTab(
              tabController: _tabController,
              tabs: const [
                Tab(text: 'ภาพรวม'),
                Tab(text: 'หมวดหมู่'),
              ],
              shadowOpacity: 0.5,
              blurRadius: 5,
              indicatorDecoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  // Content for the 'Overview' tab
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        TabOverview()
                      ],
                    ),
                  ),
                  // Content for the 'Categorized' tab
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        TabCategorized()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
