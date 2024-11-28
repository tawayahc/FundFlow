import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';

class CustomPasswordInputBox extends StatefulWidget {
  final String labelText;
  final FocusNode focusNode;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomPasswordInputBox({
    Key? key,
    required this.labelText,
    required this.focusNode,
    required this.controller,
    this.validator,
  }) : super(key: key);

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
              color: AppColors.icon,
            ),
            suffixIcon: widget.focusNode.hasFocus
                ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: _isPasswordVisible
                          ? AppColors.darkBlue
                          : AppColors.icon,
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
