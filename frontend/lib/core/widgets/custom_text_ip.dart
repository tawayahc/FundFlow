import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';

// Updated CustomTextInput Widget
class TextInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final ValueChanged<String> onChanged;
  final IconData icon; // Add the icon parameter

  const TextInput({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.onChanged,
    required this.icon, // Make the icon parameter required
  }) : super(key: key);

  @override
  _CustomTextInputState createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<TextInput> {
  Color iconColor = AppColors.icon;
  Color textColor = AppColors.icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
          ),
        ),
        const SizedBox(height: 10),
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              iconColor = hasFocus ? AppColors.darkBlue : AppColors.icon;
              textColor = hasFocus ? AppColors.darkGrey : AppColors.icon;
            });
          },
          child: TextField(
            controller: widget.controller,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: AppColors.icon),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: AppColors.icon),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: AppColors.darkBlue),
              ),
              prefixIcon: Icon(
                widget.icon, // This should use widget.icon
                color: iconColor,
              ),
            ),
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }
}
