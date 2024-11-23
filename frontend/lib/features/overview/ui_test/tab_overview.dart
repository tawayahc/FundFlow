// features/overview/ui/tab_overview.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:fundflow/core/widgets/overview/summary_card.dart';
import 'package:fundflow/features/overview/bloc/overview_event.dart';
import 'package:fundflow/features/overview/ui_test/daily_summary_screen.dart';
import 'package:fundflow/features/overview/ui_test/monthly_summary_screen.dart';
import 'package:fundflow/features/overview/widget/daily_summary_view.dart';
import 'package:fundflow/features/overview/widget/monthly_summary_view.dart';
import 'package:logger/logger.dart';
import 'package:fundflow/core/widgets/custom_tab.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import '../bloc/overview_bloc.dart';
import '../bloc/overview_state.dart';

class TabOverview extends StatefulWidget {
  const TabOverview({Key? key}) : super(key: key);

  @override
  State<TabOverview> createState() => TabOverviewState();
}

class TabOverviewState extends State<TabOverview>
    with SingleTickerProviderStateMixin {
  String _type = 'daily';
  late TabController _tabController;
  late SingleValueDropDownController _cnt;
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = ['daily', 'monthly'].indexOf(_type);
    _cnt = SingleValueDropDownController();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _type = ['daily', 'monthly'][_tabController.index];
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (context.read<OverviewBloc>().state is OverviewInitial) {
      context.read<OverviewBloc>().add(FetchTransactionsEvent());
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cnt.dispose();
    super.dispose();
  }

  void _navigateToSummary() {
    if (_tabController.index == 0) {
      // Navigate to Daily Summary Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DailySummaryScreen(),
        ),
      );
    } else if (_tabController.index == 1) {
      // Navigate to Monthly Summary Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MonthlySummaryScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverviewBloc, OverviewState>(
      builder: (context, state) {
        logger.d('Current State in TabOverview: $state');

        if (state is OverviewLoading || state is OverviewInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OverviewLoaded) {
          return Column(
            children: [
              // FIX: Replace chart widget
              Container(
                height: 200,
                color: Colors.blueAccent,
                child:
                    const Center(child: Text('Expense Bar Chart Placeholder')),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SummaryCard(
                    type: true,
                    title: 'ยอดรวมเงินเข้า (บาท)',
                    amount: state.summary.totalIncome,
                    items: state.summary.incomeItems,
                    avgPerMonth: state.summary.avgIncomePerMonth,
                  ),
                  SummaryCard(
                    type: false,
                    title: 'ยอดรวมเงินออก (บาท)',
                    amount: state.summary.totalExpense,
                    items: state.summary.expenseItems,
                    avgPerMonth: state.summary.avgExpensePerMonth,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
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
                  IconButton(
                    onPressed: _navigateToSummary,
                    icon: const Icon(Icons.call_made),
                    tooltip: 'Open Summary',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // FIX: implement filtering and date range selection
                    DailySummaryView(
                      dailySummaries: state.dailySummaries,
                      dropDownController: _cnt,
                      onFilterChanged: (value) {
                        // Implement filtering logic if needed
                      },
                      onDateRangeSelected: (range) {
                        // Implement date range filtering if needed
                      },
                    ),
                    MonthlySummaryView(
                      monthlySummaries: state.monthlySummaries,
                      dropDownController: _cnt,
                      onFilterChanged: (value) {
                        // Implement filtering logic if needed
                      },
                      onDateRangeSelected: (range) {
                        // Implement date range filtering if needed
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        } else if (state is OverviewError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          logger.w('Unhandled State in TabOverview: $state');
          return const Center(child: Text('No data available.'));
        }
      },
    );
  }
}
