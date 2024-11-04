import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/core/widgets/navBar/main_layout.dart';
import 'package:fundflow/features/auth/ui/auth_wrapper.dart';
import 'package:fundflow/features/auth/ui/change_password.dart';
import 'package:fundflow/features/auth/ui/delete_acc_page.dart';
import 'package:fundflow/features/auth/ui/edit_email_page.dart';
import 'package:fundflow/features/auth/ui/forget_page_1.dart';
import 'package:fundflow/features/auth/ui/forget_page_2.dart';
import 'package:fundflow/features/auth/ui/forget_page_3.dart';
import 'package:fundflow/features/auth/ui/setting_page.dart';
import 'package:fundflow/features/home/pages/home_page.dart';
import 'package:fundflow/features/manageCategory/ui/category_page.dart';
import 'package:fundflow/features/home/ui/add_category.dart';
import 'package:logger/logger.dart';
import 'package:fundflow/features/transaction/ui/gallery_page.dart';
import 'core/themes/app_theme.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/repository/auth_repository.dart';
import 'features/auth/ui/login_page.dart';
import 'features/auth/ui/registeration_page.dart';
import 'features/auth/ui/forget_page_1.dart';
import 'features/auth/ui/forget_page_2.dart';
import 'features/auth/ui/forget_page_3.dart';
import 'features/manageBankAccount/ui/bank_account_page.dart';
import 'features/home/repository/bank_repository.dart';
import 'features/home/repository/category_repository.dart';
import 'features/home/repository/profile_repository.dart';
import 'features/home/ui/add_bank.dart';
import 'features/home/ui/home_page.dart';
import 'features/transaction/ui/transaction_page.dart';
import 'features/transaction/bloc/transaction_bloc.dart';
import 'features/transaction/repository/transaction_repository.dart';
import 'package:dio/dio.dart';

final logger = Logger(
  printer: PrettyPrinter(
    colors: true,
    printEmojis: true,
  ),
);

class MyApp extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;

  const MyApp({super.key, required this.authenticationRepository});

  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) {
      Logger.level = Level.off;
    } else {
      Logger.level = Level.debug;
    }
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider(create: (context) => BankRepository()),
        RepositoryProvider(create: (context) => CategoryRepository()),
        RepositoryProvider(create: (context) => ProfileRepository()),
      ],
      child: BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(
            authenticationRepository: authenticationRepository)
          ..add(AppStarted()), // Handle the authentication flow
        child: MaterialApp(
          title: 'FundFlow',
          theme: AppTheme.lightTheme, // Apply the Poppins light theme
          darkTheme: AppTheme.darkTheme, // Apply the Poppins dark theme
          themeMode: ThemeMode.system,
          home:
              const AuthenticationWrapper(), // Decide whether to show login or HomePage
          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegistrationPage(),
            '/forget1': (context) => ForgetPage(),
            '/forget2': (context) => const VerificationPage(),
            '/forget3': (context) => ResetPasswordPage(),
            '/setting_page': (context) => const SettingsPage(),
            '/pocket_management': (context) => const CategoryPage(),
            '/setting_page/edit_email': (context) => EditEmailPage(),
            '/setting_page/change_password': (context) =>
                const ChangePasswordPage(),
            '/setting_page/delete_acc': (context) => const DeleteAccPage(),
            '/home': (context) => const BottomNavBar(),
            '/addBank': (context) => const AddBankPage(),
            '/addCategory': (context) => const AddCategoryPage(),
            '/manageBankAccount': (context) => const BankAccountPage(),
            '/transaction_page': (context) => TransactionPage(),
            '/gallery': (context) => GalleryPage(),
          },
          // builder: (context, child) => const BottomNavBar(), // Apply padding only to the body
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
