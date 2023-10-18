import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sales/constant/constant.dart';

class CustomTextInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? inputType;
  final bool isPassword;

  const CustomTextInput(
      {Key? key,
      required this.label,
      required this.hint,
      required this.controller,
      this.inputType,
      this.isPassword = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF2A3256),
            fontSize: 16,
            letterSpacing: 0.4,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          cursorColor: primaryColor,
          controller: controller,
          keyboardType: inputType,
          obscureText: isPassword,
          decoration: InputDecoration(
            fillColor: Colors.black.withOpacity(0.05),
            filled: true,
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w400,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(14),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(14),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}
