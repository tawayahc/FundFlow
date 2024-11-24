import 'dart:convert'; // For JSON encoding
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/transaction/ui/transaction_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For local storage
import 'package:fundflow/core/widgets/notification/notification_card.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_state.dart';
import 'package:fundflow/features/home/bloc/notification/notification_bloc.dart';
import 'package:fundflow/features/home/bloc/notification/notification_event.dart';
import 'package:fundflow/features/home/bloc/notification/notification_state.dart';
import 'package:fundflow/features/home/models/category.dart';
import 'package:fundflow/features/home/models/notification.dart' as model;

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> localNotifications = [];
  bool _hasSavedToLocalStorage = false; // Flag to prevent multiple saves

  @override
  void initState() {
    super.initState();
    _loadLocalNotifications(); // Load notifications from local storage
    context.read<NotificationBloc>().add(LoadNotifications());
  }

  /// Load notifications from local storage
  Future<void> _loadLocalNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString('notifications');
    if (storedData != null) {
      final decodedData = jsonDecode(storedData) as List;
      localNotifications = decodedData.cast<Map<String, dynamic>>();
      print("Loaded Local Notifications: $localNotifications");
    } else {
      print("No Local Notifications Found");
    }
  }

  /// Save notifications to local storage without duplicating
  Future<void> _saveNotificationsToLocalStorageOnce(
      List<model.Notification> notifications) async {
    if (_hasSavedToLocalStorage) return; // Prevent multiple saves

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Combine local and new notifications, avoiding duplicates
    final combinedNotifications = [
      ...localNotifications,
      ...notifications.where((newNotification) {
        return !localNotifications.any((localNotification) =>
            localNotification['date'] == newNotification.date &&
            localNotification['time'] == newNotification.time);
      }).map((notification) => notification.toJson()) // Use toJson here
    ];

    final notificationsJson = jsonEncode(combinedNotifications);
    await prefs.setString('notifications', notificationsJson);

    setState(() {
      localNotifications = combinedNotifications.cast<Map<String, dynamic>>();
      _hasSavedToLocalStorage = true; // Set flag to true after saving
    });

    debugPrint('Notifications saved to local storage: $localNotifications');
  }

  @override
  Widget build(BuildContext context) {
    return GlobalPadding(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('การแจ้งเตือน'),
          centerTitle: true,
        ),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, notificationState) {
            if (notificationState is NotificationsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (notificationState is NotificationsLoaded) {
              final sortedNotifications =
                  List.from(notificationState.notifications)
                    ..sort((a, b) => b.date.compareTo(a.date));

              final newNotifications =
                  sortedNotifications.where((notification) {
                return !localNotifications.any((localNotification) =>
                    localNotification['date'] == notification.date &&
                    localNotification['time'] == notification.time);
              }).toList();

              final oldNotifications =
                  sortedNotifications.where((notification) {
                return localNotifications.any((localNotification) =>
                    localNotification['date'] == notification.date &&
                    localNotification['time'] == notification.time);
              }).toList();

              // Save notifications to local storage once
              _saveNotificationsToLocalStorageOnce(
                  notificationState.notifications);

              return BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, categoryState) {
                  return ListView(
                    children: [
                      // New Notifications Section
                      if (newNotifications.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            children: [
                              const Text(
                                "การแจ้งเตือนใหม่",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF414141),
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.info_outline_rounded, // Tap icon
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "แตะเพื่อแก้ไข",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ...newNotifications.map((notification) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8.0), // เพิ่มระยะห่างที่นี่
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TransactionPage(),
                                  ),
                                );
                              },
                              child: _buildNotificationCard(
                                  notification, categoryState),
                            ),
                          );
                        }).toList(),

                        // Show Divider only if oldNotifications is not empty
                        if (oldNotifications.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: const Divider(
                              thickness: 1,
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                        ],
                      ],

                      // Old Notifications Section
                      if (oldNotifications.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            children: [
                              const Text(
                                "การแจ้งเตือนเก่า",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF414141),
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.info_outline_rounded, // Info icon
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "แตะเพื่อแก้ไข",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ...oldNotifications.map((notification) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8.0), // เพิ่มระยะห่างที่นี่
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TransactionPage(),
                                  ),
                                );
                              },
                              child: _buildNotificationCard(
                                  notification, categoryState),
                            ),
                          );
                        }).toList(),
                      ],
                    ],
                  );
                },
              );
            } else if (notificationState is NotificationsLoadError) {
              return Center(child: Text(notificationState.message));
            } else {
              return const Center(child: Text('Unknown error'));
            }
          },
        ),
      ),
    );
  }

  /// Helper method to build a notification card
  Widget _buildNotificationCard(
      model.Notification notification, CategoryState categoryState) {
    // Retrieve the matching Category object based on the notification categoryId
    Category category = Category(
      id: 0,
      name: 'undefined',
      amount: 0.0,
      color: Colors.grey,
    );

    if (notification.categoryId != 0 && categoryState is CategoriesLoaded) {
      category = categoryState.categories.firstWhere(
        (cat) => cat.id == notification.categoryId,
        orElse: () => category,
      );
    }

    return NotificationCard(notification: notification);
  }
}
