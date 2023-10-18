import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sales/constant/constant.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final Function() onPressed;

  const PrimaryButton({Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
      ),
      padding: EdgeInsets.all(16),
      onPressed: onPressed,
      child: label == "" ? SizedBox(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.white,),) : Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Rubik',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
