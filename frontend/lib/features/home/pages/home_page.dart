// pages/home_page.dart
import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/custom_modal.dart';
import 'package:fundflow/features/auth/bloc/auth_bloc.dart';
import 'package:fundflow/features/auth/bloc/auth_state.dart';
import 'package:fundflow/features/auth/ui/login_page.dart';
import 'package:fundflow/features/home/bloc/bank/bank_bloc.dart';
import 'package:fundflow/features/home/bloc/bank/bank_event.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_event.dart';
import 'package:fundflow/features/home/bloc/profile/profile_bloc.dart';
import 'package:fundflow/features/home/bloc/profile/profile_event.dart';
import 'package:fundflow/features/home/repository/bank_repository.dart';
import 'package:fundflow/features/home/repository/category_repository.dart';
import 'package:fundflow/features/home/repository/profile_repository.dart';
import 'package:fundflow/features/home/ui/home_ui.dart';
import 'package:fundflow/features/image_upload/bloc/image_upload/image_upload_bloc.dart';
import 'package:fundflow/features/image_upload/bloc/image_upload/image_upload_event.dart';
import 'package:fundflow/features/image_upload/bloc/slip/slip_bloc.dart';
import 'package:fundflow/features/image_upload/bloc/slip/slip_event.dart';
import 'package:fundflow/features/image_upload/bloc/slip/slip_state.dart';

class HomePage extends StatefulWidget {
  final PageController pageController;
  const HomePage({super.key, required this.pageController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SlipBloc _slipBloc;

  _HomePageState();

  @override
  void initState() {
    super.initState();
    _slipBloc = BlocProvider.of<SlipBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _slipBloc.add(DetectAndUploadSlips());
    });
  }

  // Note: Open the gallery app on Android
  Future<void> _openGallery() async {
    if (Platform.isAndroid) {
      const intent = AndroidIntent(
        action: 'android.intent.action.VIEW',
        type: 'image/*',
      );
      await intent.launch();
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BankBloc(
            bankRepository: context.read<BankRepository>(),
          )..add(LoadBanks()),
        ),
        BlocProvider(
          create: (context) => CategoryBloc(
            categoryRepository: context.read<CategoryRepository>(),
          )..add(LoadCategories()),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(
            profileRepository: context.read<ProfileRepository>(),
          )..add(LoadProfile()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is Unauthenticated) {
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              } else if (state is AuthenticationFailure) {
                _showModal(context, 'ไม่สามารถเข้าสู่ระบบได้');
              }
            },
          ),
          // Listener for SlipBloc to handle slip upload states
          BlocListener<SlipBloc, SlipState>(
            listener: (context, state) {
              if (state is SlipSuccess) {
                final images = state.images;
                context.read<ImageBloc>().add(SendImages(images: images));
              } else if (state is SlipFailure) {
                if (state.error.contains('No slip images detected')) {
                  // Prompt the user to manually upload slips
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('ไม่พบ slip'),
                      content:
                          const Text('คุณต้องการเพิ่ม slip ด้วยตนเองหรือไม่?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('ยกเลิก'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            Navigator.pushNamed(context,
                                '/transaction'); // Navigate to manual upload page
                          },
                          child: const Text('เพิ่มด้วยตนเอง'),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
          ),
        ],
        child: HomeUI(
          pageController: widget.pageController,
        ),
      ),
    );
  }
}
