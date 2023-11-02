import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/constant/constant.dart';
import 'package:point_of_sales/presentation/product/dialog/input_product_dialog.dart';
import 'package:point_of_sales/presentation/product/product_controller.dart';
import 'package:point_of_sales/widget/card/product_card.dart';
import 'package:point_of_sales/widget/default_app_bar.dart';

import '../../widget/card/transaction_card.dart';
import '../../widget/text_input_widget.dart';

class ProductPage extends GetView<ProductController> {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    controller.onInit();

    return Obx(() => Scaffold(
          appBar: defaultAppBar('Barang'),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                Text(
                  "Jumlah Barang : ${controller.productCount.value}",
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
                    onChanged: (keyword) {
                      controller.getProducts();
                    },
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
                          controller.getProducts();
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

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      controller.onInit();
                      controller.refreshProducts();
                    },
                    child: ListView.separated(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 32),
                        itemBuilder: (context, index) {
                          final productDetail = controller.filteredProductList[index];

                          return ProductCard(
                            name: productDetail.get("product_name"),
                            stock: productDetail.get("product_stock").toString(),
                            price: NumberFormat.simpleCurrency(
                                    locale: "id", name: "Rp. ", decimalDigits: 0)
                                .format(productDetail.get("product_price")),
                            category: productDetail.get("product_category"),
                            id: productDetail.id,
                            data: productDetail,
                            onDeleteClick: (data) {
                              controller.deleteProduct(data);
                            },
                            onUpdateClick: (data) {
                              controller.nameCon.text = data.get("product_name");
                              controller.priceCon.text =
                                  data.get("product_price").toString();
                              controller.stockCon.text =
                                  data.get("product_stock").toString();

                              controller.setSelectedInputCategory(controller
                                  .rawProductCategoryList
                                  .indexOf(controller.rawProductCategoryList
                                      .firstWhere((element) =>
                                          element.get("category") ==
                                          data.get("product_category"))));

                              inputProductDialog(
                                  controller: controller,
                                  isEdit: true,
                                  id: data.id);
                            },
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(
                              height: 12,
                            ),
                        itemCount: controller.productCount.value),
                  ),
                ),
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
                  inputProductDialog(controller: controller, isEdit: false);
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
                onTap: () {
                  Get.bottomSheet(
                    Obx(() => Container(
                          padding: EdgeInsets.all(16),
                          constraints:
                              BoxConstraints(maxHeight: Get.height / 1.5),
                          decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      topLeft: Radius.circular(12)))),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: CustomTextInput(
                                        label: "Tambah Jenis Barang",
                                        hint: "contoh: kosmetik",
                                        controller:
                                            controller.inputCategoryCon),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  MaterialButton(
                                      onPressed: () {
                                        controller.addProductCategory();
                                      },
                                      color: primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: EdgeInsets.all(12),
                                      child: Icon(
                                        FontAwesomeIcons.plus,
                                        color: Colors.white,
                                        size: 20,
                                      ))
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                "Daftar Jenis Barang",
                                style: TextStyle(
                                  color: Color(0xFF2A3256),
                                  fontSize: 16,
                                  letterSpacing: 0.4,
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Expanded(
                                child: ListView.separated(
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.grey.shade200)),
                                        child: Row(
                                          children: [
                                            Text(
                                              controller
                                                  .rawProductCategoryList[index]
                                                  .get("category"),
                                              style: TextStyle(
                                                color: Color(0xFF2A3256),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Spacer(),
                                            PopupMenuButton(
                                              onSelected: (value) async {
                                                if (value == 1) {
                                                  controller.editProductCategory(
                                                      controller
                                                              .rawProductCategoryList[
                                                          index]);
                                                } else {
                                                  controller.deleteProductCategory(
                                                      controller
                                                              .rawProductCategoryList[
                                                          index]);
                                                }
                                              },
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              itemBuilder:
                                                  (BuildContext context) => [
                                                const PopupMenuItem(
                                                  value: 1,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        FontAwesomeIcons
                                                            .solidPenToSquare,
                                                        color: Colors.blue,
                                                        size: 14,
                                                      ),
                                                      SizedBox(
                                                        width: 12,
                                                      ),
                                                      Text('Ubah'),
                                                    ],
                                                  ),
                                                ),
                                                const PopupMenuItem(
                                                  value: 2,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        FontAwesomeIcons.trash,
                                                        color: Colors.red,
                                                        size: 14,
                                                      ),
                                                      SizedBox(
                                                        width: 12,
                                                      ),
                                                      Text('Hapus'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Icon(
                                                  FontAwesomeIcons
                                                      .ellipsisVertical,
                                                  color: Colors.grey.shade400,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                          height: 8,
                                        ),
                                    itemCount: controller
                                        .rawProductCategoryList.length),
                              )
                            ],
                          ),
                        )),
                    isScrollControlled: true,
                  );
                },
              ),
            ],
          ),
        ));
  }
}
