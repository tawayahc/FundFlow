import 'package:flutter/material.dart';

class CustomInputBox extends StatelessWidget {
  final String labelText;
  final Icon prefixIcon;
  final TextEditingController? controller;

  const CustomInputBox({
    super.key,
    required this.labelText,
    required this.prefixIcon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 328,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: prefixIcon,
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
    );
  }
}
