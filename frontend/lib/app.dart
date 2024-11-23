import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fundflow/features/auth/bloc/repassword/repassword_bloc.dart';
import 'package:fundflow/features/auth/repository/repassword_repo.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/core/widgets/navBar/main_layout.dart';
import 'package:fundflow/features/auth/ui/auth_wrapper.dart';
import 'package:fundflow/features/home/bloc/bank/bank_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_event.dart';
import 'package:fundflow/features/home/bloc/profile/profile_bloc.dart';
import 'package:fundflow/features/home/bloc/profile/profile_event.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_bloc.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_event.dart';
import 'package:fundflow/features/home/pages/bank/add_bank_page.dart';
import 'package:fundflow/features/home/pages/notification/notification.dart';
import 'package:fundflow/features/home/pages/notification/test.dart';
import 'package:fundflow/features/home/repository/transaction_repository.dart';
import 'package:fundflow/features/image_upload/bloc/slip/slip_bloc.dart';
import 'package:fundflow/features/image_upload/bloc/image_upload/image_upload_bloc.dart';
import 'package:fundflow/features/image_upload/repository/image_repository.dart';
import 'package:fundflow/features/image_upload/repository/slip_repository.dart';
import 'package:fundflow/features/setting/bloc/user_profile/user_profile_bloc.dart';
import 'package:fundflow/features/setting/repository/settings_repository.dart';
import 'package:fundflow/features/setting/ui/change_password.dart';
import 'package:fundflow/features/setting/ui/delete_acc_page.dart';
import 'package:fundflow/features/setting/ui/edit_email_page.dart';
import 'package:fundflow/features/auth/ui/forget_page.dart';
import 'package:fundflow/features/auth/ui/verification_page.dart';
import 'package:fundflow/features/auth/ui/reset_page.dart';
import 'package:fundflow/features/setting/ui/setting_page.dart';
import 'package:fundflow/features/home/pages/home_page.dart';
import 'package:fundflow/features/manageCategory/ui/category_page.dart';
import 'package:fundflow/features/home/pages/category/add_category_page.dart';
import 'package:fundflow/utils/api_helper.dart';
import 'package:logger/logger.dart';
import 'core/themes/app_theme.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/repository/auth_repository.dart';
import 'features/auth/ui/login_page.dart';
import 'features/auth/ui/registeration_page.dart';
import 'features/auth/ui/forget_page.dart';
import 'features/auth/ui/verification_page.dart';
import 'features/auth/ui/reset_page.dart';
import 'features/manageBankAccount/ui/bank_account_page.dart';
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
    // NOTE: API Helper is use for store the base url and token
    // NOTE: base url is use when we don't have the token
    final apiHelper =
        ApiHelper(baseUrl: dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080/');
    final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080/';
    final authenticationRepository = AuthenticationRepository(baseUrl: baseUrl);
    final settingsRepository = SettingsRepository(apiHelper: apiHelper);
    final repasswordRepository = RepasswordRepository(baseUrl: baseUrl);
    final categoryRepository = CategoryRepository(apiHelper: apiHelper);
    final profileRepository = ProfileRepository(apiHelper: apiHelper);
    final bankRepository = BankRepository(apiHelper: apiHelper);
    final transactionRepository = TransactionRepository(apiHelper: apiHelper);
    final transactionAddRepository =
        TransactionAddRepository(apiHelper: apiHelper);
    final imageRepository = ImageRepository();
    final slipRepository = SlipRepository(
      imageRepository: imageRepository,
      transactionAddRepository: transactionAddRepository,
    );
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
          BlocProvider<ImageBloc>(
            create: (context) => ImageBloc(
              imageRepository: ImageRepository(),
              slipRepository: SlipRepository(
                imageRepository: ImageRepository(),
                transactionAddRepository: transactionAddRepository,
              ),
              transactionAddRepository: transactionAddRepository,
            ),
          ),
          BlocProvider<SlipBloc>(
            create: (context) => SlipBloc(
              slipRepository,
            ),
          ),
        ],
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
            '/forget1': (context) => const ForgetPage(),
            '/setting_page': (context) => const SettingsPage(),
            // '/pocket_management': (context) => CategoryPage(),
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
            // '/manageBankAccount': (context) => const BankAccountPage(bank: bank,),
          },
          // builder: (context, child) => const BottomNavBar(), // Apply padding only to the body
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
