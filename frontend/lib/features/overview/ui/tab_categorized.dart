// features/categorized/ui/tab_categorized.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/overview/bloc/categorized/categorized_bloc.dart';
import 'package:fundflow/features/overview/bloc/categorized/categorized_event.dart';
import 'package:fundflow/features/overview/bloc/categorized/categorized_state.dart';
import 'package:fundflow/features/overview/widget/categorized_summary_view.dart';

class TabCategorized extends StatefulWidget {
  const TabCategorized({Key? key}) : super(key: key);

  @override
  State<TabCategorized> createState() => TabCategorizedState();
}

class TabCategorizedState extends State<TabCategorized> {
  @override
  void initState() {
    super.initState();
    // Dispatch event to fetch categorized transactions
    context.read<CategorizedBloc>().add(FetchCategorizedTransactionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategorizedBloc, CategorizedState>(
      builder: (context, state) {
        logger.d('Current State in TabCategorized: $state');

        if (state is CategorizedLoading || state is CategorizedInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategorizedLoaded) {
          return CategorizedSummaryView(
            categories: state.categories,
            categorizedSummaries: state.categorizedSummaries,
          );
        } else if (state is CategorizedError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          logger.w('Unhandled State in TabCategorized: $state');
          return const Center(child: Text('No data available.'));
        }
      },
    );
  }
}
