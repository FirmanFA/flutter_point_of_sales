import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constant/constant.dart';

AppBar defaultAppBar(String title){
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark
    ),
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // MaterialButton(
          //     color: primaryColor,
          //     padding: EdgeInsets.all(8),
          //     minWidth: 0,
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(14)),
          //     onPressed: () {},
          //     child: Icon(FontAwesomeIcons.chevronLeft,color: Colors.white,size: 20,)),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF1A72DD),
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
    backgroundColor: Colors.white,
    shadowColor: Colors.transparent,

  );
}
