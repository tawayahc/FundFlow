import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  final String? title;
  final IconData icon;

  const TabItem({
    super.key,
    this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (title != null) // Only add Text if title is not null
            Text(
              title!,
              overflow: TextOverflow.ellipsis,
            ),
          Icon(
            icon,
            size: 20,
          ),
        ],
      ),
    );
  }
}
