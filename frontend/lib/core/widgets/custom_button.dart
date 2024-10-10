// Example
import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? color;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: icon != null ? Icon(icon, color: AppColors.white) : SizedBox(),
      label: Text(label, style: Theme.of(context).textTheme.labelLarge),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primary,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: AppBorders.medium,
        ),
      ),
    );
  }
}
