import 'dart:convert';
import 'package:crypto/crypto.dart'; // Add this import
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/navBar/main_layout.dart';
import 'package:fundflow/features/transaction/ui/edit_transaction_page.dart';
import 'package:fundflow/core/widgets/notification/notification_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fundflow/features/home/bloc/notification/notification_bloc.dart';
import 'package:fundflow/features/home/bloc/notification/notification_event.dart';
import 'package:fundflow/features/home/bloc/notification/notification_state.dart';
import 'package:fundflow/features/home/models/notification.dart' as model;

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Set<String> oldNotificationHashes = {};
  bool _hasSavedToLocalStorage = false;

  @override
  void initState() {
    super.initState();
    _loadLocalNotifications(); // Load old notification hashes
    context.read<NotificationBloc>().add(LoadNotifications());
  }

  String getNotificationHash(model.Notification notification) {
    final notificationJson = jsonEncode(notification.toJson());
    final bytes = utf8.encode(notificationJson);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  Future<void> _loadLocalNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final storedHashes = prefs.getStringList('oldNotificationHashes');
    if (storedHashes != null) {
      setState(() {
        oldNotificationHashes = storedHashes.toSet();
      });
      debugPrint("Loaded old notification hashes: $oldNotificationHashes");
    } else {
      debugPrint("No old notification hashes found");
    }
  }

  Future<void> _saveNotificationsToLocalStorageOnce(
      List<model.Notification> notifications) async {
    if (_hasSavedToLocalStorage) return; // Prevent multiple saves

    final notificationHashes = notifications.map((notification) {
      return getNotificationHash(notification);
    }).toSet();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'oldNotificationHashes', notificationHashes.toList());

    if (mounted) {
      setState(() {
        oldNotificationHashes = notificationHashes;
        _hasSavedToLocalStorage = true; // Set flag to true after saving
      });
    }

    debugPrint(
        'Notifications hashes saved to local storage: $oldNotificationHashes');
  }

  void _removeTransaction(model.Notification notification) async {
    final hash = getNotificationHash(notification);
    setState(() {
      oldNotificationHashes.remove(hash);
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'oldNotificationHashes', oldNotificationHashes.toList());

    debugPrint(
        'Updated old notification hashes after removal: $oldNotificationHashes');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        builder: (context, notificationState) {
          if (notificationState is NotificationsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (notificationState is NotificationsLoaded) {
            final sortedNotifications =
                List.from(notificationState.notifications)
                  ..sort((a, b) => b.date.compareTo(a.date));

            final newNotifications = sortedNotifications.where((notification) {
              final hash = getNotificationHash(notification);
              return !oldNotificationHashes.contains(hash);
            }).toList();

            final oldNotifications = sortedNotifications.where((notification) {
              final hash = getNotificationHash(notification);
              return oldNotificationHashes.contains(hash);
            }).toList();

            // Save notifications to local storage once
            _saveNotificationsToLocalStorageOnce(
                notificationState.notifications);

            return ListView(
              children: [
                if (newNotifications.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "New Notifications",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ...newNotifications.map((notification) {
                  return _buildNotificationCard(notification);
                }).toList(),
                if (oldNotifications.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Old Notifications",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ...oldNotifications.map((notification) {
                  return _buildNotificationCard(notification);
                }).toList(),
              ],
            );
          } else {
            return const Center(child: Text('Unknown error'));
          }
        },
      ),
    );
  }

  Widget _buildNotificationCard(model.Notification notification) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditTransactionPage(
              notification: notification,
              onTransactionRemoved: () => _removeTransaction(notification),
            ),
          ),
        );
      },
      child: NotificationCard(notification: notification),
    );
  }
}
