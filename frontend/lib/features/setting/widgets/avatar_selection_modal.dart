import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/custom_modal.dart';
import 'package:fundflow/features/setting/bloc/user_profile/user_profile_bloc.dart';

class AvatarSelectionModal extends StatelessWidget {
  const AvatarSelectionModal({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<UserProfileBloc>(context);
    bloc.add(FetchAvatarPresets());

    return SizedBox(
      height: 400,
      child: BlocConsumer<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is AvatarChangeSuccess) {
            Navigator.pop(context);
            BlocProvider.of<UserProfileBloc>(context).add(FetchUserProfile());
          } else if (state is AvatarChangeFailure) {
            _showModal(context, 'เปลี่ยนรูปภาพไม่สำเร็จ');
            Navigator.pop(context);
            BlocProvider.of<UserProfileBloc>(context).add(FetchUserProfile());
          }
        },
        builder: (context, state) {
          if (state is AvatarPresetsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AvatarPresetsLoaded) {
            final avatars = state.avatars;
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: avatars.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of columns
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemBuilder: (context, index) {
                final avatar = avatars[index];
                return GestureDetector(
                  onTap: () {
                    bloc.add(ChangeAvatar(avatar));
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(avatar),
                  ),
                );
              },
            );
          } else if (state is UserProfileError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

bool _isDialogShowing = false;

void _showModal(BuildContext context, String text) {
  if (_isDialogShowing) {
    return;
  }

  _isDialogShowing = true;
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.1),
    builder: (BuildContext context) {
      return CustomModal(text: text);
    },
  ).then((_) {
    _isDialogShowing = false;
  });
}
