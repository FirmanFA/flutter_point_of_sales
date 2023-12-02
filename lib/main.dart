import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/constant/constant.dart';
import 'package:point_of_sales/presentation/history/history_controller.dart';
import 'package:point_of_sales/presentation/home/home_controller.dart';
import 'package:point_of_sales/presentation/login/login_controller.dart';
import 'package:point_of_sales/presentation/login/login_page.dart';
import 'package:point_of_sales/presentation/main/main_controller.dart';
import 'package:point_of_sales/presentation/product/product_controller.dart';

import 'firebase_option.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  /// initiate firebase with current platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// initiate main tab controller
  Get.lazyPut(()=>LoginController());
  Get.lazyPut(()=>MainController());
  Get.put(ProductController());
  Get.put(HomeController());
  Get.put(HistoryController());

  runApp(GetMaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(),
        primaryColor: primaryColor,
      ),
      debugShowCheckedModeBanner: false,
      /// set login page as the default page when app first opened
      home: const LoginPage()));
}
