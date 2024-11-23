import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/home/bloc/profile/profile_bloc.dart';
import 'package:fundflow/features/home/bloc/profile/profile_state.dart';

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
                              color: Color(0xFF41486D),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formatter.format(cashBox),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF41486D),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 0),
                      Text(
                        userProfile.username ?? 'Unknown User',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF414141),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isNotificationActive
                          ? Icons.notifications
                          : Icons.notifications_outlined,
                      color: isNotificationActive
                          ? Color(0xFF41486D)
                          : const Color(0xFF414141),
                    ),
                    iconSize: 28,
                    onPressed: () {
                      setState(() {
                        isNotificationActive = !isNotificationActive;
                      });

                      // ทำงานแล้วรีเซ็ตสถานะ
                      Navigator.pushNamed(context, '/notification')
                          .then((_) => resetState());
                    },
                  ),
                  const SizedBox(width: 0),
                  IconButton(
                    icon: Icon(
                      isSettingsActive
                          ? Icons.settings
                          : Icons.settings_outlined,
                      color: isSettingsActive
                          ? Color(0xFF41486D)
                          : const Color(0xFF414141),
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
