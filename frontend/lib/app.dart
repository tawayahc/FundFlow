import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fundflow/features/auth/bloc/repassword/repassword_bloc.dart';
import 'package:fundflow/features/auth/repository/repassword_repo.dart';

import 'package:fundflow/core/widgets/navBar/main_layout.dart';
import 'package:fundflow/features/auth/ui/auth_wrapper.dart';
import 'package:fundflow/features/home/bloc/bank/bank_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_event.dart';
import 'package:fundflow/features/home/bloc/notification/notification_bloc.dart';
import 'package:fundflow/features/home/bloc/notification/notification_event.dart';
import 'package:fundflow/features/home/bloc/profile/profile_bloc.dart';
import 'package:fundflow/features/home/bloc/profile/profile_event.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_bloc.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_event.dart';
import 'package:fundflow/features/home/pages/bank/add_bank_page.dart';
import 'package:fundflow/features/home/pages/notification/notification.dart';

import 'package:fundflow/features/home/repository/notification_repository.dart';
import 'package:fundflow/features/home/repository/transaction_repository.dart';
import 'package:fundflow/features/image_upload/bloc/slip/slip_bloc.dart';
import 'package:fundflow/features/image_upload/bloc/image_upload/image_upload_bloc.dart';
import 'package:fundflow/features/image_upload/repository/image_repository.dart';
import 'package:fundflow/features/image_upload/repository/slip_repository.dart';
import 'package:fundflow/features/overview/bloc/categorized/categorized_bloc.dart';
import 'package:fundflow/features/overview/bloc/overview/overview_bloc.dart';
import 'package:fundflow/features/overview/bloc/overview/overview_event.dart';
import 'package:fundflow/features/setting/bloc/user_profile/user_profile_bloc.dart';
import 'package:fundflow/features/setting/repository/settings_repository.dart';
import 'package:fundflow/features/setting/ui/change_password.dart';
import 'package:fundflow/features/setting/ui/delete_acc_page.dart';
import 'package:fundflow/features/setting/ui/edit_email_page.dart';
import 'package:fundflow/features/auth/ui/forget_page.dart';

import 'package:fundflow/features/home/pages/category/add_category_page.dart';
import 'package:fundflow/utils/api_helper.dart';
import 'package:logger/logger.dart';
import 'core/themes/app_theme.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/repository/auth_repository.dart';
import 'features/auth/ui/login_page.dart';
import 'features/auth/ui/registeration_page.dart';

import 'features/home/repository/bank_repository.dart';
import 'features/home/repository/category_repository.dart';
import 'features/home/repository/profile_repository.dart';
import 'features/transaction/ui/transaction_page.dart';
import 'features/transaction/bloc/transaction_bloc.dart';
import 'features/transaction/repository/transaction_repository.dart';

final logger = Logger(
  printer: PrettyPrinter(
    colors: true,
    printEmojis: true,
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) {
      Logger.level = Level.off;
    } else {
      Logger.level = Level.debug;
    }

    final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080/';

    final apiHelper = ApiHelper(baseUrl: baseUrl);
    final authenticationRepository = AuthenticationRepository(baseUrl: baseUrl);
    final settingsRepository = SettingsRepository(apiHelper: apiHelper);
    final repasswordRepository = RepasswordRepository(baseUrl: baseUrl);
    final categoryRepository = CategoryRepository(apiHelper: apiHelper);
    final profileRepository = ProfileRepository(apiHelper: apiHelper);
    final bankRepository = BankRepository(apiHelper: apiHelper);
    final transactionRepository = TransactionRepository(apiHelper: apiHelper);
    final notificationRepository = NotificationRepository(apiHelper: apiHelper);
    final transactionAddRepository =
        TransactionAddRepository(apiHelper: apiHelper);
    final imageRepository = ImageRepository();
    final slipRepository = SlipRepository();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider.value(value: repasswordRepository),
        RepositoryProvider.value(value: settingsRepository),
        RepositoryProvider.value(value: profileRepository),
        RepositoryProvider.value(value: bankRepository),
        RepositoryProvider.value(
          value: categoryRepository,
        ),
        RepositoryProvider(
            create: (context) => ProfileRepository(apiHelper: apiHelper)),
        RepositoryProvider.value(value: transactionRepository),
        RepositoryProvider.value(value: notificationRepository),
        RepositoryProvider.value(value: transactionAddRepository),
        RepositoryProvider.value(value: imageRepository),
        RepositoryProvider.value(value: slipRepository),
      ],
      child: MultiBlocProvider(
        // Wrap with MultiBlocProvider
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
              settingsRepository: settingsRepository,
            )..add(AppStarted()),
          ),
          BlocProvider<RepasswordBloc>(
            create: (context) => RepasswordBloc(
              repasswordRepository: repasswordRepository,
            ),
          ),
          BlocProvider<UserProfileBloc>(
              create: (context) =>
                  UserProfileBloc(repository: settingsRepository)
                    ..add(FetchUserProfile())),
          BlocProvider<CategoryBloc>(
            create: (context) => CategoryBloc(
              categoryRepository: categoryRepository, // Pass the repository
            )..add(LoadCategories()),
          ),
          BlocProvider<BankBloc>(
            create: (context) => BankBloc(
              bankRepository: bankRepository, // Pass the repository
            ),
          ),
          BlocProvider<TransactionBloc>(
            create: (context) => TransactionBloc(
              transactionRepository: transactionRepository,
            )..add(LoadTransactions()),
          ),
          BlocProvider<NotificationBloc>(
            create: (context) => NotificationBloc(
              transactionAddRepository: transactionAddRepository,
            )..add(LoadNotifications()),
          ),
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(
              profileRepository: profileRepository,
            )..add(LoadProfile()),
          ),
          // Note: OAT's Bloc
          BlocProvider<TransactionAddBloc>(
            create: (context) => TransactionAddBloc(
              repository: transactionAddRepository,
            ),
          ),
          BlocProvider<OverviewBloc>(
            create: (context) => OverviewBloc(
              repository: transactionAddRepository,
            )..add(FetchTransactionsEvent()),
          ),
          BlocProvider<CategorizedBloc>(
            create: (context) => CategorizedBloc(
              repository: transactionAddRepository,
            ),
          ),
          BlocProvider<ImageBloc>(
            create: (context) => ImageBloc(
              imageRepository: imageRepository,
              transactionAddRepository: transactionAddRepository,
            ),
          ),
          BlocProvider<SlipBloc>(
              create: (context) => SlipBloc(
                    slipRepository,
                  )),
        ],
        child: MaterialApp(
          title: 'FundFlow',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: const AuthenticationWrapper(),
          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegistrationPage(),
            '/forget1': (context) => const ForgetPage(),
            '/setting_page/edit_email': (context) =>
                EditEmailPage(repository: settingsRepository),
            '/setting_page/change_password': (context) =>
                ChangePasswordPage(repository: settingsRepository),
            '/setting_page/delete_acc': (context) =>
                DeleteAccountPage(repository: settingsRepository),
            '/home': (context) => const BottomNavBar(),
            '/addBank': (context) => const AddBankPage(),
            '/addCategory': (context) => const AddCategoryPage(),
            '/transaction': (context) => TransactionPage(),
            '/notification': (context) => const NotificationPage(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
