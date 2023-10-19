import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/constant/constant.dart';
import 'package:point_of_sales/presentation/product/product_controller.dart';
import 'package:point_of_sales/widget/card/product_card.dart';
import 'package:point_of_sales/widget/default_app_bar.dart';

import '../../widget/card/transaction_card.dart';
import '../../widget/text_input_widget.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());

    controller.onInit();

    return Obx(() => Scaffold(
          appBar: defaultAppBar('Barang'),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                Text(
                  "Jumlah Barang : 12",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                CustomTextInput(
                    label: "",
                    hint: "Masukkan pencarian...",
                    icon: Icon(
                      FontAwesomeIcons.magnifyingGlass,
                      size: 18,
                    ),
                    controller: controller.searchCon),
                SizedBox(
                  height: 22,
                ),
                // TabBar(
                //   indicatorColor: Colors.transparent,
                //   controller: controller.tabController,
                //   isScrollable: true,
                //   labelPadding: const EdgeInsets.only(right: 12),
                //   padding: const EdgeInsets.only(left: 0),
                //   tabs: List.generate(
                //     controller.categoryCount.value,
                //     (index) => Tab(
                //         child: InkWell(
                //       onTap: () {
                //         // kendaraanTabController.animateTo(0);
                //         // kendaraanPageController.jumpToPage(0);
                //
                //         controller.tabController.animateTo(index);
                //
                //         controller.setSelectedCategory(index);
                //       },
                //       child: Container(
                //         padding: const EdgeInsets.symmetric(
                //             horizontal: 12, vertical: 8),
                //         decoration: ShapeDecoration(
                //           color: index == controller.selectedCategory.value
                //               ? primaryColor
                //               : Colors.white,
                //           shape: RoundedRectangleBorder(
                //             side: BorderSide(
                //                 width: 0.50,
                //                 color:
                //                     index == controller.selectedCategory.value
                //                         ? primaryColor
                //                         : const Color(0xFFE0E0E0)),
                //             borderRadius: BorderRadius.circular(12),
                //           ),
                //         ),
                //         child: Center(
                //           child: Text(
                //             toBeginningOfSentenceCase(
                //                     controller.productCategoryList[index]) ??
                //                 "",
                //             style: TextStyle(
                //               color: index == controller.selectedCategory.value
                //                   ? Colors.white
                //                   : const Color(0xFF757575),
                //               fontSize: 14,
                //               fontWeight: FontWeight.w500,
                //             ),
                //           ),
                //         ),
                //       ),
                //     )),
                //   ),
                // ),

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
                        value: controller.selectedCategory.value,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black87),
                        isDense: true,
                        iconEnabledColor: Colors.white,
                        iconDisabledColor: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        onChanged: (value) {
                          controller.setSelectedCategory(value ?? 0);
                        },
                        selectedItemBuilder: (context) {
                          return controller.productCategoryList
                              .map<Text>((dynamic value) {
                            return Text(
                              toBeginningOfSentenceCase(value) ?? "",
                              style: const TextStyle(color: Colors.white),
                            );
                          }).toList();
                        },
                        items: controller.productCategoryList
                            .map<DropdownMenuItem<int>>((dynamic value) {
                          return DropdownMenuItem<int>(
                            value:
                                controller.productCategoryList.indexOf(value),
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

                ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final productDetail = controller.productList[index];

                      return ProductCard(
                        name: productDetail.get("product_name"),
                        stock: productDetail.get("product_stock").toString(),
                        price: NumberFormat.simpleCurrency(
                            locale: "id", name: "Rp. ", decimalDigits: 0)
                            .format(productDetail.get("product_price")) ,
                        category: productDetail.get("product_category"),
                        id: productDetail.id,
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          height: 12,
                        ),
                    itemCount: controller.productCount.value),
                SizedBox(
                  height: 32,
                )
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          floatingActionButton: SpeedDial(
            icon: Icons.add,
            activeIcon: Icons.close,
            direction: SpeedDialDirection.down,
            iconTheme: const IconThemeData(size: 30),
            childPadding: const EdgeInsets.all(5),
            backgroundColor: primaryColor,
            spaceBetweenChildren: 4,
            buttonSize: const Size(55.0, 55.0),
            elevation: 8.0,
            animationCurve: Curves.elasticInOut,
            children: [
              SpeedDialChild(
                labelWidget: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: primaryColor, width: 0.5),
                      color: Colors.white),
                  child: const Padding(
                    padding: EdgeInsets.only(
                        top: 12.0, bottom: 12, left: 16, right: 16),
                    child: Text('Tambah Barang',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.start),
                  ),
                ),
                onTap: () {
                  Get.defaultDialog(
                      title: "Tambah Barang",
                      titlePadding: EdgeInsets.all(16),
                      content: Obx(() => SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Kategori Barang",
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
                                SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            width: 0.50,
                                            color: Color(0xFFE0E0E0)),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<int>(
                                        value: controller
                                            .selectedInputCategory.value,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87),
                                        isDense: true,
                                        // iconEnabledColor: Colors.white,
                                        // iconDisabledColor: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        onChanged: (value) {
                                          controller.setSelectedInputCategory(
                                              value ?? 0);
                                        },
                                        items: controller.productCategoryList
                                            .map<DropdownMenuItem<int>>(
                                                (dynamic value) {
                                          return DropdownMenuItem<int>(
                                            value: controller
                                                .productCategoryList
                                                .indexOf(value),
                                            child: Text(
                                              toBeginningOfSentenceCase(
                                                      value) ??
                                                  "",
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                CustomTextInput(
                                    label: "Nama Barang",
                                    hint: "Masukkan nama barang",
                                    controller: controller.nameCon),
                                SizedBox(
                                  height: 10,
                                ),
                                CustomTextInput(
                                    label: "Harga Barang",
                                    inputType: TextInputType.number,
                                    hint: "Masukkan harga barang",
                                    controller: controller.priceCon),
                                SizedBox(
                                  height: 10,
                                ),
                                CustomTextInput(
                                    label: "Stok",
                                    hint: "Masukkan stok barang",
                                    inputType: TextInputType.number,
                                    controller: controller.stockCon),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          )),
                      contentPadding: EdgeInsets.all(16),
                      textConfirm: "Tambah",
                      onConfirm: () async {
                        if (controller.nameCon.text.isNotEmpty &&
                            controller.priceCon.text.isNotEmpty &&
                            controller.stockCon.text.isNotEmpty) {
                          await controller.addProduct(
                              name: controller.nameCon.text,
                              price: int.parse(controller.priceCon.text),
                              stock: int.parse(controller.stockCon.text),
                              category: controller.productCategoryList[
                                  controller.selectedInputCategory.value]);
                        } else {
                          Get.snackbar("Waring", "All field must be filled",
                              colorText: Colors.white,
                              backgroundColor: Colors.deepOrange,
                              snackPosition: SnackPosition.BOTTOM,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 44));
                        }
                      },
                      confirmTextColor: Colors.white,
                      textCancel: "Batal");
                },
              ),
              SpeedDialChild(
                labelWidget: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: primaryColor, width: 0.5),
                      color: Colors.white),
                  child: const Padding(
                    padding: EdgeInsets.only(
                        top: 12.0, bottom: 12, left: 16, right: 16),
                    child: Text('Edit/Tambah Jenis Barang',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.start),
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ));
  }
}
