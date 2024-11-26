import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 382,
      child: DropdownButtonFormField<T>(
        value: selectedItem,
        hint: Text(
          hintText,
          style: const TextStyle(
            color: Color(0xFFD0D0D0),
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(displayItem(item)),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          prefixIcon: Icon(
            prefixIcon,
            color: Color(0xFFD0D0D0),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Color(0xFFD0D0D0),
              width: 2,
            ),
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
            ),
          ),
        ),
      ),
    );
  }
}
