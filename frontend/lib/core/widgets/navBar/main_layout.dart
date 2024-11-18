import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/home/models/bank.dart';
import 'package:fundflow/features/home/models/transaction.dart';
import 'package:fundflow/features/home/pages/bank/add_bank_page.dart';
import 'package:fundflow/features/home/pages/home_page.dart';
import 'package:fundflow/features/manageBankAccount/ui/bank_account_page.dart';
import 'package:fundflow/features/manageCategory/ui/category_page.dart';
import 'package:fundflow/features/transaction/ui/transaction_page.dart';
import 'package:fundflow/features/overview/ui/overview_page.dart';
import 'package:fundflow/features/setting/ui/setting_page.dart';

class BottomNavBar extends StatefulWidget {
  // final Bank bank;
  // final Category category;
  // final Transaction transaction;
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _NavBarState();
}

class _NavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController(initialPage: 0);
  late NotchBottomBarController _controller;
  final int maxPage = 3;

  @override
  void initState() {
    super.initState();
    _controller = NotchBottomBarController(index: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> onNavBarPages = [
      const HomePage(),
      TransactionPage(),
      const OverviewPage()
    ];

    return Scaffold(
      body: GlobalPadding(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
              onNavBarPages.length, (index) => onNavBarPages[index]),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(
              Icons.home_filled,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              Icons.home_filled,
              color: Colors.blueAccent,
            ),
            itemLabel: 'Page 1',
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.add_circle_outline,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              Icons.add_circle_outline,
              color: Colors.blueAccent,
            ),
            itemLabel: 'Adding',
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.insert_chart_outlined_rounded,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              Icons.insert_chart_outlined_rounded,
              color: Colors.blueAccent,
            ),
            itemLabel: 'Page 3',
          ),
        ],
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
        kIconSize: 24,
        kBottomRadius: 20,
      ),
    );
  }
}
