import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';

class CustomInputInkwell extends StatelessWidget {
  final IconData prefixIcon;
  final String labelText;
  final VoidCallback onTap;

  const CustomInputInkwell({
    Key? key,
    required this.prefixIcon,
    required this.labelText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 382,
      child: InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            prefixIcon: Icon(
              prefixIcon,
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
              borderSide: const BorderSide(
                color: AppColors.icon,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: AppColors.darkBlue,
              ),
            ),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              labelText,
              style: const TextStyle(
                color: AppColors.icon,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
