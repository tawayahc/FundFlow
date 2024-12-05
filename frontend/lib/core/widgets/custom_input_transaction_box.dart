import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';

class CustomInputTransactionBox extends StatefulWidget {
  final String labelText;
  final Icon prefixIcon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CustomInputTransactionBox({
    Key? key,
    required this.labelText,
    required this.prefixIcon,
    required this.controller,
    this.keyboardType,
    this.validator,
  }) : super(key: key);

  @override
  State<CustomInputTransactionBox> createState() =>
      _CustomInputTransactionBoxState();
}

class _CustomInputTransactionBoxState extends State<CustomInputTransactionBox> {
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: widget.controller,
                validator: (value) {
                  final result = widget.validator?.call(value);
                  setState(() {
                    _errorText = result; // Capture the validation result
                  });
                  return null; // Prevent default validator rendering
                },
                keyboardType: widget.keyboardType,
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  labelStyle: const TextStyle(
                    color: AppColors.icon,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  prefixIcon: widget.prefixIcon,
                  contentPadding: const EdgeInsets.symmetric(vertical: 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: _errorText != null
                          ? Colors.red // Set border color to red on error
                          : AppColors.icon,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: _errorText != null
                          ? Colors
                              .red // Set focused border color to red on error
                          : AppColors.darkBlue,
                      width: 2.0,
                    ),
                  ),
                  errorStyle: const TextStyle(
                    height: 0, // Hide the default error message
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_errorText != null) // Display the error message below the field
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              _errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
