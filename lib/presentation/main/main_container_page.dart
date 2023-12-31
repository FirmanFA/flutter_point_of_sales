import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:point_of_sales/constant/constant.dart';
import 'package:point_of_sales/presentation/history/history_page.dart';
import 'package:point_of_sales/presentation/home/home_page.dart';
import 'package:point_of_sales/presentation/login/login_page.dart';
import 'package:point_of_sales/presentation/main/main_controller.dart';
import 'package:point_of_sales/presentation/order/order_page.dart';
import 'package:point_of_sales/presentation/profile/profile_page.dart';
import 'package:point_of_sales/presentation/product/product_page.dart';

import '../payment/payment_page.dart';

class MainContainerPage extends GetView<MainController> {
  const MainContainerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    /// list of page in bottom navigation bar
    final List<Widget> viewContainer = [
      HomePage(),
      ProductPage(),
      HistoryPage(),
      ProfilePage(),
    ];

    return WillPopScope(
      onWillPop: () async {

        await Get.defaultDialog<bool>(
          title: "Konfirmasi",
          middleText: 'Ingin keluar dari aplikasi?',
          textCancel: "Batal",
          textConfirm: "Keluar",
          confirmTextColor: Colors.white,
          onConfirm: () {

            SystemNavigator.pop(animated: true);

          },
        );

        return false;

      },
      child: Scaffold(
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
                  /// change page when bottom navigation is clicked
                  onTap: (index) => controller.setNav(nav: index)),
            ),
          )),
    );
  }
}
