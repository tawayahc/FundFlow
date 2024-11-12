import 'package:flutter/material.dart';

class CustomPasswordInputBox extends StatefulWidget {
  final String labelText;
  final FocusNode focusNode;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomPasswordInputBox({
    super.key,
    required this.labelText,
    required this.focusNode,
    required this.controller,
    this.validator,
  });

  @override
  _CustomPasswordInputBoxState createState() => _CustomPasswordInputBoxState();
}

class _CustomPasswordInputBoxState extends State<CustomPasswordInputBox> {
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    if (!widget.focusNode.hasFocus && _isPasswordVisible) {
      setState(() {
        _isPasswordVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // NOTE: Adjust it without using sized box
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          obscureText: !_isPasswordVisible,
          focusNode: widget.focusNode,
          controller: widget.controller,
          validator: widget.validator,
          decoration: InputDecoration(
            labelText: widget.labelText,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: Color(0xFFD0D0D0),
            ),
            suffixIcon: widget.focusNode.hasFocus
                ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: _isPasswordVisible
                          ? const Color(0xFF41486D)
                          : const Color(0xFFD0D0D0),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                : null,
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
          onTap: () {
            setState(() {}); // Refresh visibility icon when the field is tapped
          },
        ),
      ],
    );
  }
}
