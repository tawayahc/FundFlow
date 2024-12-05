import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';

class CustomDropdown<T> extends StatefulWidget {
  final IconData prefixIcon;
  final String hintText;
  final T? selectedItem;
  final List<T> items;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final String Function(T) displayItem;

  const CustomDropdown({
    Key? key,
    required this.prefixIcon,
    required this.hintText,
    required this.selectedItem,
    required this.items,
    required this.onChanged,
    required this.displayItem,
    this.validator,
  }) : super(key: key);

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          width: 382,
          child: DropdownButtonFormField<T>(
            value: widget.selectedItem,
            hint: Text(
              widget.hintText,
              style: const TextStyle(
                color: AppColors.icon,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            items: widget.items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(widget.displayItem(item)),
              );
            }).toList(),
            onChanged: widget.onChanged,
            validator: (value) {
              final result = widget.validator?.call(value);
              setState(() {
                _errorText = result; // Capture the validation result
              });
              return null; // Prevent default validator rendering
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              prefixIcon: Icon(
                widget.prefixIcon,
                color: AppColors.icon,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: AppColors.icon,
                  width: 2,
                ),
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
                      ? Colors.red // Set focused border color to red on error
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
        if (_errorText != null) // Display the error message below the dropdown
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
