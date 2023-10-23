import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../constant/constant.dart';

AppBar defaultAppBar(String title, {bool hasBack = false, List<Widget>? actions}) {
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark),
    centerTitle: true,
    automaticallyImplyLeading: hasBack == true,
    actions: actions,
    iconTheme: IconThemeData(
      color: primaryColor,
    ),
    leading: hasBack ? Icon(FontAwesomeIcons.chevronLeft) :null,
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        title,
        style: TextStyle(
          color: Color(0xFF1A72DD),
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    backgroundColor: Colors.white,
    shadowColor: Colors.transparent,
  );
}
