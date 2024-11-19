import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/home/bloc/profile/profile_bloc.dart';
import 'package:fundflow/features/home/bloc/profile/profile_state.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

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
                  // Username and Balance
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatter.format(cashBox),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        userProfile.username ?? 'Unknown User',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Notification and Settings Icons
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.black),
                    onPressed: () {
                      Navigator.pushNamed(context, '/notification');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.black),
                    onPressed: () {
                      Navigator.pushNamed(context, '/setting_page');
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
