import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/custom_modal.dart';
import 'package:fundflow/features/image_upload/bloc/image_upload/image_upload_bloc.dart';
import 'package:fundflow/features/image_upload/bloc/image_upload/image_upload_event.dart';
import 'package:fundflow/features/image_upload/bloc/slip/slip_bloc.dart';
import 'package:fundflow/features/image_upload/bloc/slip/slip_event.dart';
import 'package:fundflow/features/image_upload/bloc/slip/slip_state.dart';
import '../../../core/widgets/navBar/main_layout.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import 'login_page.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    bool _isDialogShowing = false;

    void _showModal(BuildContext context, String text,
        {Color? color, Icon? icon}) {
      if (_isDialogShowing) {
        return;
      }

      _isDialogShowing = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.1),
        builder: (BuildContext context) {
          return CustomModal(text: text, color: color, icon: icon);
        },
      ).then((_) {
        _isDialogShowing = false;
      });
    }

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, authState) {
        if (authState is Authenticated) {
          context.read<SlipBloc>().add(DetectAndUploadSlips());
        }
      },
      builder: (context, authState) {
        if (authState is Authenticated) {
          return BlocListener<SlipBloc, SlipState>(
            listener: (context, slipState) {
              if (slipState is SlipSuccess) {
                final images = slipState.images;
                context.read<ImageBloc>().add(SendImages(images: images));
                _showModal(context, 'Slips detected and uploaded successfully',
                    color: Colors.green, icon: const Icon(Icons.check));
              } else if (slipState is SlipFailure) {
                _showModal(context, 'Error: ${slipState.error}');
                if (slipState.error.contains('No slip images detected')) {
                  // Prompt the user to manually upload slips
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('No Slips Detected'),
                      content: const Text(
                          'Would you like to create a slip manually?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushNamed(context, '/transaction');
                          },
                          child: const Text('Create Manually'),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
            child: const BottomNavBar(),
          );
        } else if (authState is Unauthenticated || authState is AuthInitial) {
          return const LoginPage();
        } else if (authState is AuthenticationLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return const LoginPage();
      },
    );
  }
}
