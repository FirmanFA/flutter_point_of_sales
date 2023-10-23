import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:point_of_sales/constant/constant.dart';
import 'package:point_of_sales/presentation/home/home_page.dart';
import 'package:point_of_sales/presentation/login/login_page.dart';
import 'package:point_of_sales/presentation/main/main_controller.dart';
import 'package:point_of_sales/presentation/order/order_page.dart';
import 'package:point_of_sales/presentation/product/product_page.dart';

import '../payment/payment_page.dart';

class MainContainerPage extends GetView<MainController> {
  const MainContainerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> viewContainer = [
      HomePage(),
      ProductPage(),
      HomePage(),
      LoginPage(),
    ];

    return Scaffold(
        body: Obx(() => viewContainer[controller.currentNavigation.value]),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: SizedBox(
            width: 60,
            height: 60,
            child: FloatingActionButton(
              onPressed: () {
                Get.to(OrderPage(),transition: Transition.downToUp);
              },
              shape: CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: const Icon(FontAwesomeIcons.cartPlus),
              ),
              //params
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Obx(
          () => Container(
            color: Colors.white,
            child: AnimatedBottomNavigationBar(
                icons: const [
                  FontAwesomeIcons.houseChimney,
                  FontAwesomeIcons.boxArchive,
                  FontAwesomeIcons.solidFileLines,
                  FontAwesomeIcons.solidUser
                ],
                backgroundColor: Colors.white,
                iconSize: 20,
                activeColor: primaryColor,
                inactiveColor: Colors.grey.shade400,
                activeIndex: controller.currentNavigation.value,
                gapLocation: GapLocation.center,
                notchSmoothness: NotchSmoothness.smoothEdge,
                onTap: (index) => controller.setNav(nav: index)),
          ),
        ));
  }
}
