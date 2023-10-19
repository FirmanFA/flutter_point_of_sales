import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:point_of_sales/constant/constant.dart';
import 'package:point_of_sales/widget/default_app_bar.dart';

class PaymentPage extends GetView {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 12, left: 8, right: 9, bottom: 13),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: Color(0xFFE6E6E6)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: MaterialButton(
                    height: 48,
                    padding: const EdgeInsets.all(8),
                      color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    onPressed: () {
                      
                    },
                    child: Center(
                      child:Text(
                        '1',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    )
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Container(
                      height: 48,
                      padding: const EdgeInsets.all(8),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 0,
                            offset: Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                          child:Text(
                            '2',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                      )
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Container(
                      height: 48,
                      padding: const EdgeInsets.all(8),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 0,
                            offset: Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                          child:Text(
                            '3',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                      )
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: ShapeDecoration(
                      color: Color(0xFFD1D1D1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      shadows: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 0,
                          offset: Offset(0, 1),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Icon(FontAwesomeIcons.deleteLeft),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                      height: 48,
                      padding: const EdgeInsets.all(8),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 0,
                            offset: Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                          child:Text(
                            '4',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                      )
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Container(
                      height: 48,
                      padding: const EdgeInsets.all(8),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 0,
                            offset: Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                          child:Text(
                            '5',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                      )
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Container(
                      height: 48,
                      padding: const EdgeInsets.all(8),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 0,
                            offset: Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                          child:Text(
                            '6',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                      )
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: ShapeDecoration(
                      color: Color(0xFFD1D1D1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      shadows: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 0,
                          offset: Offset(0, 1),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Center(
                        child:Text(
                          'C',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                      height: 48,
                      padding: const EdgeInsets.all(8),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 0,
                            offset: Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                          child:Text(
                            '7',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                      )
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Container(
                      height: 48,
                      padding: const EdgeInsets.all(8),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 0,
                            offset: Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                          child:Text(
                            '8',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                      )
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Container(
                      height: 48,
                      padding: const EdgeInsets.all(8),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 0,
                            offset: Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                          child:Text(
                            '9',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                      )
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: ShapeDecoration(
                      color: Color(0xFFD1D1D1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      shadows: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 0,
                          offset: Offset(0, 1),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: SizedBox.shrink(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                      height: 48,
                      padding: const EdgeInsets.all(8),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 0,
                            offset: Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                          child:Text(
                            '00',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                      )
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Container(
                      height: 48,
                      padding: const EdgeInsets.all(8),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 0,
                            offset: Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                          child:Text(
                            '0',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                      )
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Container(
                      height: 48,
                      padding: const EdgeInsets.all(8),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 0,
                            offset: Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                          child:Text(
                            '000',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                      )
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: ShapeDecoration(
                      color: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      shadows: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 0,
                          offset: Offset(0, 1),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Icon(FontAwesomeIcons.check,color: Colors.white,)
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
