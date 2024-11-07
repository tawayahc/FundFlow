import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final VoidCallback onPressed;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.color,
    required this.fontSize,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero, // Remove any extra padding
        minimumSize: const Size(0, 0), // Control the button size if needed
        textStyle: TextStyle(
          fontSize: fontSize,
          color: color,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: FontWeight.normal, // Ensure it’s not bold
        ),
      ),
    );
  }
}
