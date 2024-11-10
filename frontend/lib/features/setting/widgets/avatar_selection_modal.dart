import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/change_avatar/change_avatar_bloc.dart';
import '../bloc/change_avatar/change_avatar_event.dart';
import '../bloc/change_avatar/change_avatar_state.dart';

class AvatarSelectionModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ChangeAvatarBloc>(context);
    bloc.add(FetchAvatarPresets());

    return Container(
      height: 400,
      child: BlocConsumer<ChangeAvatarBloc, ChangeAvatarState>(
        listener: (context, state) {
          if (state is AvatarChangeSuccess) {
            Navigator.pop(context);
            BlocProvider.of<ChangeAvatarBloc>(context).add(FetchUserProfile());
          } else if (state is AvatarChangeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Failed to change avatar: ${state.message}')),
            );
            Navigator.pop(context);
            BlocProvider.of<ChangeAvatarBloc>(context).add(FetchUserProfile());
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
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
