import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/core/widgets/navBar/main_layout.dart';
import 'package:fundflow/core/widgets/notification/notification_card.dart';
import 'package:fundflow/features/home/bloc/notification/notification_bloc.dart';
import 'package:fundflow/features/home/bloc/notification/notification_event.dart';
import 'package:fundflow/features/home/bloc/notification/notification_state.dart';
import 'edit_transaction_page.dart';
import 'package:fundflow/app.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(LoadNotifications());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route); // Safely cast to PageRoute
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when this page becomes visible again
    context.read<NotificationBloc>().add(LoadNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return GlobalPadding(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavBar()),
              );
            },
          ),
          centerTitle: true,
          title: const Text(
            'การแจ้งเตือน',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationsLoaded) {
              final notifications = state.notifications;

              if (notifications.isEmpty) {
                return const Center(child: Text('ไม่มีการแจ้งเตือน'));
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<NotificationBloc>().add(LoadNotifications());
                },
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final transaction = notifications[index];
                    return GestureDetector(
                      onTap: () async {
                        final updatedTransaction = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTransactionPage(
                              transaction: transaction,
                            ),
                          ),
                        );
                        if (updatedTransaction != null) {
                          context.read<NotificationBloc>().add(
                                UpdateNotification(
                                    transaction: updatedTransaction),
                              );
                        }
                      },
                      child: NotificationCard(transaction: transaction),
                    );
                  },
                ),
              );
            } else if (state is NotificationsError) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return const Center(child: Text('Unknown error'));
            }
          },
        ),
      ),
    );
  }
}
