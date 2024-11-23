// features/overview/ui/expense_type_dropdown.dart
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class ExpenseTypeDropDown extends StatelessWidget {
  final SingleValueDropDownController controller;
  final Function(String?) onChanged;

  const ExpenseTypeDropDown({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropDownTextField(
      textFieldDecoration: const InputDecoration(
        hintText: 'เงินเข้า-เงินออก',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 11,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      controller: controller,
      clearOption: true,
      clearIconProperty: IconProperty(color: Colors.green),
      validator: (value) {
        if (value == null) {
          return "Required field";
        } else {
          return null;
        }
      },
      dropDownItemCount: 3,
      dropDownList: const [
        DropDownValueModel(name: 'เงินเข้า-เงินออก', value: "all"),
        DropDownValueModel(name: 'เงินเข้า', value: "income"),
        DropDownValueModel(name: 'เงินออก', value: "expense"),
      ],
      textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 11,
      ),
      onChanged: (val) {
        onChanged(val?.value as String?);
      },
    );
  }
}
