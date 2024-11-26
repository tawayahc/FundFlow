import 'package:flutter/material.dart';

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
  Color iconColor = const Color(0xFFD0D0D0);
  Color textColor = const Color(0xFFD0D0D0);

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
            color: Color(0xFF414141),
          ),
        ),
        const SizedBox(height: 10),
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              iconColor =
                  hasFocus ? const Color(0xFF41486D) : const Color(0xFFD0D0D0);
              textColor =
                  hasFocus ? const Color(0xFF414141) : const Color(0xFFD0D0D0);
            });
          },
          child: TextField(
            controller: widget.controller,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Color(0xFFD0D0D0)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Color(0xFFD0D0D0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Color(0xFF41486D)),
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
