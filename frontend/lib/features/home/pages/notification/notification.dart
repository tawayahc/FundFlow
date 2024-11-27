import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/core/widgets/navBar/main_layout.dart';
import 'package:fundflow/core/widgets/notification/notification_card.dart';
import 'package:fundflow/features/home/bloc/notification/notification_bloc.dart';
import 'package:fundflow/features/home/bloc/notification/notification_event.dart';
import 'package:fundflow/features/home/bloc/notification/notification_state.dart';
import 'package:fundflow/features/home/models/transaction.dart';
import 'edit_transaction_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
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
            'Notifications',
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
                return const Center(child: Text('No notifications.'));
              }

              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return GestureDetector(
                    onTap: () async {
                      final updatedTransaction = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTransactionPage(
                            transaction: notification,
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
                    child: NotificationCard(transaction: notification),
                  );
                },
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
