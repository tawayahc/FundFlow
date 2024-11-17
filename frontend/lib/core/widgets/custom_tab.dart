import 'package:flutter/material.dart';

import '../themes/app_styles.dart';

class CustomTab extends StatefulWidget {
  final TabController tabController;
  final List<Tab> tabs;
  final double height;
  final double width;
  final EdgeInsetsGeometry margin;
  final BorderRadiusGeometry borderRadius;
  final Color backgroundColor;
  final BoxDecoration indicatorDecoration;
  final Color labelColor;
  final Color unselectedLabelColor;
  final Color dividerColor;
  final TabBarIndicatorSize indicatorSize;
  final double shadowOpacity;
  final double blurRadius;
  final Offset offset;

  const CustomTab({
    super.key,
    required this.tabController,
    required this.tabs,
    this.height = 40.0,
    this.width = 200.0,
    this.margin = const EdgeInsets.symmetric(horizontal: 20),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.backgroundColor = Colors.white, // Default background color
    this.indicatorDecoration = const BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    this.labelColor = Colors.white,
    this.unselectedLabelColor = Colors.black,
    this.dividerColor = Colors.transparent,
    this.indicatorSize = TabBarIndicatorSize.tab,
    this.shadowOpacity = 0.1,
    this.blurRadius = 4,
    this.offset = const Offset(0, 2),
  });

  @override
  State<CustomTab> createState() => _CustomTabState();
}

class _CustomTabState extends State<CustomTab> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(widget.height),
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: Column(
          children: [
            const SizedBox(height: 8,),
            Container(
              height: widget.height,
              width: widget.width,
              margin: widget.margin,
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                color: widget.backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(widget.shadowOpacity),
                    blurRadius: widget.blurRadius,
                    offset: widget.offset,
                  ),
                ],
              ),
              child: TabBar(
                controller: widget.tabController,
                indicatorSize: widget.indicatorSize,
                dividerColor: widget.dividerColor,
                indicator: widget.indicatorDecoration,
                labelColor: widget.labelColor,
                unselectedLabelColor: widget.unselectedLabelColor,
                tabs: widget.tabs,
              ),
            ),
            const SizedBox(height: 8,)
          ],
        ),
      ),
    );
  }
}
