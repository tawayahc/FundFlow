import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/home/pages/home_page.dart';
import 'package:fundflow/features/transaction/ui/transaction_page.dart';
import 'package:fundflow/features/overview/ui/overview_page.dart';
import 'package:fundflow/features/setting/ui/setting_page.dart';

class BottomNavBar extends StatefulWidget {
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
      GlobalPadding(
        child: HomePage(
          pageController: _pageController,
        ),
      ),
      GlobalPadding(child: TransactionPage()),
      const OverviewPage(),

      // Sub-page from home
      SettingsPage(pageController: _pageController),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            onNavBarPages.length, (index) => onNavBarPages[index]),
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
            itemLabel: 'Home',
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
            itemLabel: 'Overview',
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
