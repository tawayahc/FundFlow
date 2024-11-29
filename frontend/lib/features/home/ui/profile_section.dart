import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/home/bloc/notification/notification_bloc.dart';
import 'package:fundflow/features/home/bloc/notification/notification_state.dart';
import 'package:fundflow/features/home/bloc/profile/profile_bloc.dart';
import 'package:fundflow/features/home/bloc/profile/profile_state.dart';
import 'package:fundflow/features/home/pages/notification/notification.dart';

class ProfileSection extends StatefulWidget {
  final PageController pageController;
  const ProfileSection({super.key, required this.pageController});

  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  bool isNotificationActive = false;
  bool isSettingsActive = false;

  void resetState() {
    setState(() {
      isNotificationActive = false;
      isSettingsActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProfileLoaded) {
          final userProfile = state.userProfile;
          final cashBox = state.cashBox;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(height: 10),
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: userProfile.profileImageUrl?.isNotEmpty ==
                            true
                        ? NetworkImage(userProfile.profileImageUrl!)
                        : const NetworkImage(
                                'https://placehold.co/200x200/png?text=Select')
                            as ImageProvider,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            '฿',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBlue,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formatter.format(cashBox),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 0),
                      Text(
                        userProfile.username ?? 'Unknown User',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  // Notification Icon with Badge
                  BlocBuilder<NotificationBloc, NotificationState>(
                    builder: (context, notificationState) {
                      int unreadCount = 0;
                      if (notificationState is NotificationsLoaded) {
                        unreadCount = notificationState.notifications
                            .where((notification) => !notification.isRead)
                            .length;
                      }

                      return Stack(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.notifications_outlined,
                              color: Colors.grey[800],
                            ),
                            iconSize: 28,
                            onPressed: () {
                              // Navigate to NotificationPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationPage(),
                                ),
                              ).then((_) =>
                                  setState(() {})); // Refresh after returning
                            },
                          ),
                          if (unreadCount > 0)
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 14,
                                  minHeight: 14,
                                ),
                                child: Text(
                                  '$unreadCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(width: 0),
                  IconButton(
                    icon: Icon(
                      isSettingsActive
                          ? Icons.settings
                          : Icons.settings_outlined,
                      color: isSettingsActive
                          ? AppColors.darkBlue
                          : AppColors.darkGrey,
                    ),
                    iconSize: 28,
                    onPressed: () {
                      setState(() {
                        isSettingsActive = !isSettingsActive;
                      });

                      widget.pageController.jumpToPage(3);
                    },
                  ),
                ],
              ),
            ],
          );
        } else if (state is ProfileError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Text('Unknown state');
      },
    );
  }
}
