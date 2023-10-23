import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/constant/constant.dart';
import 'package:point_of_sales/presentation/checkout/checkout_page.dart';
import 'package:point_of_sales/presentation/order/dialog/cart_dialog.dart';
import 'package:point_of_sales/presentation/order/order_controller.dart';
import 'package:point_of_sales/presentation/payment/payment_page.dart';
import 'package:point_of_sales/presentation/product/dialog/input_product_dialog.dart';
import 'package:point_of_sales/widget/card/product_card.dart';
import 'package:point_of_sales/widget/card/product_transaction_card.dart';
import 'package:point_of_sales/widget/default_app_bar.dart';
import 'package:badges/badges.dart' as badges;

import '../../widget/card/transaction_card.dart';
import '../../widget/text_input_widget.dart';
import '../product/product_controller.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find();

    final controller = Get.put(OrderController());

    productController.onInit();

    return Obx(() => Scaffold(
          appBar: defaultAppBar('Kasir', hasBack: true),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                CustomTextInput(
                    label: "",
                    hint: "Masukkan pencarian...",
                    onChanged: (keyword) {
                      productController.getProducts();
                    },
                    icon: Icon(
                      FontAwesomeIcons.magnifyingGlass,
                      size: 18,
                    ),
                    controller: productController.searchCon),
                SizedBox(
                  height: 22,
                ),
                Text(
                  "Filter Kategori",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: primaryColor,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 0.50, color: Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: productController.selectedCategory.value,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black87),
                        isDense: true,
                        iconEnabledColor: Colors.white,
                        iconDisabledColor: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        onChanged: (value) {
                          productController.setSelectedCategory(value ?? 0);
                          productController.getProducts();
                        },
                        selectedItemBuilder: (context) {
                          return productController.productCategoryList
                              .map<Text>((dynamic value) {
                            return Text(
                              toBeginningOfSentenceCase(value) ?? "",
                              style: const TextStyle(color: Colors.white),
                            );
                          }).toList();
                        },
                        items: productController.productCategoryList
                            .map<DropdownMenuItem<int>>((dynamic value) {
                          return DropdownMenuItem<int>(
                            value: productController.productCategoryList
                                .indexOf(value),
                            child: Text(
                              toBeginningOfSentenceCase(value) ?? "",
                              style: const TextStyle(color: Colors.black87),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
                Expanded(
                  child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 32),
                      itemBuilder: (context, index) {
                        final productDetail =
                            productController.filteredProductList[index];

                        return ProductTransactionCard(
                          name: productDetail.get("product_name"),
                          stock: productDetail.get("product_stock").toString(),
                          price: NumberFormat.simpleCurrency(
                                  locale: "id", name: "Rp. ", decimalDigits: 0)
                              .format(productDetail.get("product_price")),
                          category: productDetail.get("product_category"),
                          id: productDetail.id,
                          data: productDetail,
                          onPlusClick: (data) {
                            final currentCount =
                                controller.getItemOrderCount(data.id);

                            if (currentCount == 0) {
                              controller.addToMenuCart(data.id);
                            } else {
                              controller.setCountMenuCartItem(
                                  data.id,
                                  currentCount == data.get("product_stock")
                                      ? currentCount
                                      : currentCount + 1);
                            }

                            debugPrint("produk ${controller.selectedItemList}");
                          },
                          onMinusClick: (data) {
                            final currentCount =
                                controller.getItemOrderCount(data.id);

                            if (currentCount == 1) {
                              controller.removeMenuCart(data.id);
                            } else {
                              controller.setCountMenuCartItem(
                                  data.id,
                                  currentCount == 0
                                      ? currentCount
                                      : currentCount - 1);
                            }
                          },
                          cartCount:
                              controller.getItemOrderCount(productDetail.id),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                            height: 12,
                          ),
                      itemCount: productController.productCount.value),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      // dialogMenuCart(context);

                      cartDialog(
                          productController: productController,
                          controller: controller);
                    },
                    child: Container(
                      // width: 44,
                      // height: 44,
                      padding: const EdgeInsets.all(12),
                      decoration: ShapeDecoration(
                        color: primaryColor.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                                color: Colors.grey.withOpacity(0.1),
                                width: 0.2)),
                      ),
                      child: badges.Badge(
                        showBadge: controller.selectedItemList.isNotEmpty,
                        badgeContent: Text(
                            "${controller.selectedItemList.length}",
                            style: const TextStyle(
                                fontSize: 14, color: primaryColor)),
                        position: badges.BadgePosition.topEnd(top: -16),
                        badgeStyle: const badges.BadgeStyle(
                          padding: EdgeInsets.all(6),
                          badgeColor: Colors.white,
                        ),
                        child: const Icon(
                          FontAwesomeIcons.bagShopping,
                          color: primaryColor,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: InkWell(
                          onTap: () async {
                            if (controller.countTotalPrice(
                                    productController.allProductList) ==
                                0) {
                              Get.snackbar(
                                  "Warning", "Add something to cart first",
                                  backgroundColor: Colors.orange,
                                  colorText: Colors.white);
                            } else {
                              Get.defaultDialog(
                                title: "Konfirmasi",
                                middleText: "Pastikan semua produk sudah benar",
                                confirmTextColor: Colors.white,
                                textConfirm: "Konfirmasi",
                                onConfirm: () {
                                  Get.off(CheckoutPage());
                                },
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: ShapeDecoration(
                              color: primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 0.5),
                                        end: const Offset(0.0, 0.0),
                                      ).animate(animation),
                                      child: child,
                                    );
                                  },
                                  child: Text(
                                    NumberFormat.simpleCurrency(
                                            locale: "id",
                                            name: "Rp. ",
                                            decimalDigits: 0)
                                        .format(controller.countTotalPrice(
                                            productController.allProductList)),
                                    key: ValueKey(NumberFormat.simpleCurrency(
                                            locale: "id",
                                            name: "Rp. ",
                                            decimalDigits: 0)
                                        .format(controller.countTotalPrice(
                                            productController.allProductList))),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Icon(FontAwesomeIcons.circleArrowRight,
                                    color: Colors.white, size: 20)
                              ],
                            ),
                          )
                          // child: bigButton(
                          //   context,
                          //   title: NumberFormat.simpleCurrency(
                          //           locale: "id", name: "Rp ", decimalDigits: 0)
                          //       .format(int.parse("$totalPrice")),
                          //   icon: FontAwesomeIcons.circleArrowRight,
                          //   colorBackground: mainCulinaryColor
                          // )
                          )),
                ],
              ),
            ),
          ),
        ));
  }
}
