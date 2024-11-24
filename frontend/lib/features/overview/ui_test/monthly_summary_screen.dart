// features/overview/ui/monthly_summary_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import '../bloc/overview/overview_bloc.dart';
import '../bloc/overview/overview_event.dart';
import '../bloc/overview/overview_state.dart';
import 'package:logger/logger.dart';

import '../widget/monthly_summary_view.dart';

class MonthlySummaryScreen extends StatefulWidget {
  const MonthlySummaryScreen({Key? key}) : super(key: key);

  @override
  State<MonthlySummaryScreen> createState() => _MonthlySummaryScreenState();
}

class _MonthlySummaryScreenState extends State<MonthlySummaryScreen> {
  late SingleValueDropDownController _dropDownController;
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _dropDownController = SingleValueDropDownController();

    // Optionally, fetch transactions if not already fetched
    final bloc = context.read<OverviewBloc>();
    if (bloc.state is! OverviewLoaded) {
      bloc.add(FetchTransactionsEvent());
    }
  }

  @override
  void dispose() {
    _dropDownController.dispose();
    super.dispose();
  }

  void _onFilterChanged(String? value) {
    // Implement filtering logic if needed
    logger.d('Filter changed to: $value');
    // For example, dispatch a new event to filter the data
  }

  void _onDateRangeSelected(DateTimeRange? range) {
    // Implement date range filtering logic if needed
    logger.d('Date range selected: $range');
    // For example, dispatch a new event with the selected range
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Summary'),
      ),
      body: BlocBuilder<OverviewBloc, OverviewState>(
        builder: (context, state) {
          if (state is OverviewLoading || state is OverviewInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OverviewLoaded) {
            final monthlySummaries = state.monthlySummaries;

            final sortedMonths = monthlySummaries.keys.toList()
              ..sort((a, b) => b.compareTo(a));

            return MonthlySummaryView(
              monthlySummaries: monthlySummaries,
              dropDownController: _dropDownController,
              onFilterChanged: _onFilterChanged,
              onDateRangeSelected: _onDateRangeSelected,
            );
          } else if (state is OverviewError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            logger.w('Unhandled State in MonthlySummaryScreen: $state');
            return const Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }
}
