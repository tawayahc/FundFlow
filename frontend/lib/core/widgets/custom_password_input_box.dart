import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';

class CustomPasswordInputBox extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomPasswordInputBox({
    Key? key,
    required this.labelText,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  _CustomPasswordInputBoxState createState() => _CustomPasswordInputBoxState();
}

class _CustomPasswordInputBoxState extends State<CustomPasswordInputBox> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    // NOTE: Adjust it without using sized box
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          obscureText: !_isPasswordVisible,
          controller: widget.controller,
          validator: widget.validator,
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: const TextStyle(
              color: AppColors.icon,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.icon,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: _isPasswordVisible ? AppColors.darkBlue : AppColors.icon,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: AppColors.icon,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: AppColors.darkBlue,
                width: 2.0,
              ),
            ),
          ),
          onTap: () {
            setState(() {}); // Refresh visibility icon when the field is tapped
          },
        ),
      ],
    );
  }
}
