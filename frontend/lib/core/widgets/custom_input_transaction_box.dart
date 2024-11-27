import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          width: 382,
          child: TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              labelText: widget.labelText,
              labelStyle: const TextStyle(
                color: Color(0xFFD0D0D0),
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
        ),
      ],
    );
  }
}