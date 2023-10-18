import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/constant/constant.dart';
import 'package:point_of_sales/presentation/login/login_controller.dart';
import 'package:point_of_sales/presentation/login/login_page.dart';
import 'package:point_of_sales/presentation/main/main_controller.dart';

import 'counter_controller.dart';
import 'firebase_option.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.lazyPut(()=>LoginController());
  Get.lazyPut(()=>MainController());

  runApp(GetMaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(),
        primaryColor: primaryColor,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(context) {
    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final Controller c = Get.put(Controller());

    return Scaffold(
        // Use Obx(()=> to update Text() whenever count is changed.
        appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

        // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
        body: Center(
            child: ElevatedButton(
                child: Text("Go to Other"),
                onPressed: () =>
                    Get.to(Other(), transition: Transition.rightToLeft))),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add), onPressed: c.increment));
  }
}

class Other extends StatelessWidget {
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.
  final Controller c = Get.find();

  Other({super.key});

  @override
  Widget build(context) {
    // Access the updated count variable
    return Scaffold(body: Center(child: Text("${c.count}")));
  }
}
