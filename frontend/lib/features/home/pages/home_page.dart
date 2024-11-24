// pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: Colors.red,
                    ),
                  );
              }
            },
          ),
          // Listener for SlipBloc to handle slip upload states
          BlocListener<SlipBloc, SlipState>(
            listener: (context, state) {
              if (state is SlipSuccess) {
                // Show success message when slips are uploaded successfully
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Slip images uploaded successfully.')),
                );
              } else if (state is SlipFailure) {
                // Show error message when slip upload fails
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Failed to upload slips: ${state.error}')),
                );
                // Check if the failure was due to no slips being detected
                if (state.error.contains('No slip images detected')) {
                  // Prompt the user to manually upload slips
                  // showDialog(
                  //   context: context,
                  //   builder: (context) => AlertDialog(
                  //     title: const Text('No Slips Detected'),
                  //     content: const Text(
                  //         'Would you like to create a slip manually?'),
                  //     actions: [
                  //       TextButton(
                  //         onPressed: () {
                  //           Navigator.of(context).pop(); // Close the dialog
                  //         },
                  //         child: const Text('Cancel'),
                  //       ),
                  //       TextButton(
                  //         onPressed: () {
                  //           Navigator.of(context).pop(); // Close the dialog
                  //           Navigator.pushNamed(context,
                  //               '/manual-slip'); // Navigate to manual upload page
                  //         },
                  //         child: const Text('Create Manually'),
                  //       ),
                  //     ],
                  //   ),
                  // );
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
