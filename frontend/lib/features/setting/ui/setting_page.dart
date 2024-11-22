import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/auth/bloc/auth_bloc.dart';
import 'package:fundflow/features/auth/bloc/auth_event.dart';
import 'package:fundflow/features/auth/bloc/auth_state.dart';
import 'package:fundflow/features/home/pages/home_page.dart';
import 'package:fundflow/features/setting/bloc/user_profile/user_profile_bloc.dart';
import 'package:fundflow/features/setting/widgets/avatar_selection_modal.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    // Ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final changeAvatarBloc = BlocProvider.of<UserProfileBloc>(context);
      changeAvatarBloc.add(FetchUserProfile());
    });
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
                MaterialPageRoute(
                    builder: (context) =>
                        const GlobalPadding(child: HomePage())),
              );
            },
          ),
          centerTitle: true,
          title: const Text(
            'ตั้งค่า',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<UserProfileBloc, UserProfileState>(
              buildWhen: (previous, current) {
                return current is UserProfileLoading ||
                    current is UserProfileLoaded ||
                    current is UserProfileError;
              },
              builder: (context, state) {
                if (state is UserProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserProfileLoaded) {
                  final user = state.userProfile;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Information
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showChangeAvatarModal(context);
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: user
                                          .profileImageUrl?.isNotEmpty ==
                                      true
                                  ? NetworkImage(user.profileImageUrl!)
                                  : const NetworkImage(
                                          'https://placehold.co/200x200/png?text=Select')
                                      as ImageProvider,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.username?.isEmpty ?? true
                                      ? 'ชื่อผู้ใช้'
                                      : user.username!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF414141),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const Divider(thickness: 0.5, color: Colors.grey),
                      const SizedBox(height: 20),
                      // Account Section
                      const Text(
                        'บัญชี',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF414141),
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.email_outlined,
                            color: Color(0xFF5A5A5A)),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'อีเมล',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF5A5A5A),
                              ),
                            ),
                            Text(
                              user.email,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF41486D),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/setting_page/edit_email');
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.lock_outline,
                            color: Color(0xFF5A5A5A)),
                        title: const Text(
                          'เปลี่ยนรหัสผ่าน',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF5A5A5A), // สีดำสำหรับ "อีเมล"
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, "/setting_page/change_password");
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.delete_outline,
                            color: Color(0xFF5A5A5A)),
                        title: const Text(
                          'ลบบัญชี FundFlow',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF5A5A5A), // สีดำสำหรับ "อีเมล"
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, "/setting_page/delete_acc");
                        },
                      ),
                      const Divider(thickness: 0.5, color: Colors.grey),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading:
                            const Icon(Icons.logout, color: Color(0xFF5A5A5A)),
                        title: const Text(
                          'ออกจากระบบ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF5A5A5A), // สีดำสำหรับ "อีเมล"
                          ),
                        ),
                        onTap: () {
                          BlocProvider.of<AuthenticationBloc>(context).add(
                              AuthenticationLogoutRequested()); // ออกจากระบบ
                        },
                      ),
                      const Divider(thickness: 0.5, color: Colors.grey),
                    ],
                  );
                } else if (state is UserProfileError) {
                  return Center(child: Text('Error: ${state.error}'));
                } else {
                  return Center(child: Text('Error: Unknown state'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showChangeAvatarModal(BuildContext context) {
    final changeAvatarBloc = BlocProvider.of<UserProfileBloc>(context);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext modalContext) {
        return BlocProvider.value(
          value: changeAvatarBloc,
          child: AvatarSelectionModal(),
        );
      },
    );
  }
}
