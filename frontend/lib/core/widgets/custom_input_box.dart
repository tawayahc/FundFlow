import 'package:flutter/material.dart';

class CustomInputBox extends StatefulWidget {
  final String labelText;
  final Icon prefixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomInputBox({
    Key? key,
    required this.labelText,
    required this.prefixIcon,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  State<CustomInputBox> createState() => _CustomInputBoxState();
}

class _CustomInputBoxState extends State<CustomInputBox> {
  @override
  Widget build(BuildContext context) {
    // NOTE: Adjust it without using sized box
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget
              .controller, // Use widget.controller to access the controller passed in
          validator: widget.validator,
          decoration: InputDecoration(
            labelText: widget.labelText,
            prefixIcon: widget.prefixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Color(0xFFD0D0D0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Color(0xFF41486D),
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
