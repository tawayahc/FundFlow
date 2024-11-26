import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/custom_tab.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/home/models/transaction.dart';
import 'package:fundflow/features/overview/bloc/overview/overview_bloc.dart';
import 'package:fundflow/features/overview/bloc/overview/overview_event.dart';
import 'package:fundflow/features/overview/ui_test/tab_categorized.dart';
import 'package:fundflow/features/overview/ui_test/tab_overview.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => OverviewPageState();
}

class OverviewPageState extends State<OverviewPage>
    with SingleTickerProviderStateMixin {
  String _type = 'overview';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = ['overview', 'categorized'].indexOf(_type);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _type = ['overview', 'categorized'][_tabController.index];
        });
        context.read<OverviewBloc>().add(FetchTransactionsEvent());
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OverviewBloc>().add(FetchTransactionsEvent());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'สรุปรายรับรายจ่าย',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),),
        centerTitle: true,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: const [
            TabOverview(), // Scrollable content for "ภาพรวม"
            TabCategorized(), // Scrollable content for "หมวดหมู่"
          ],
        ),
      ),
    );
  }
}
