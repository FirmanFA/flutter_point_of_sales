import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/presentation/history_detail/history_detail_controller.dart';
import 'package:point_of_sales/widget/default_app_bar.dart';
import 'package:point_of_sales/widget/text_input_widget.dart';

import '../../constant/constant.dart';
import '../../widget/card/ordered_item_card.dart';
import '../payment/payment_page.dart';

class HistoryDetailPage extends StatelessWidget {
  final String orderId;

  const HistoryDetailPage({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HistoryDetailController());

    controller.getOrderDetail(orderId);

    return Obx(() {
      final detailOrderData = controller.detailOrderData.value;

      final orderedProductData =
          controller.detailOrderData.value?.get("products") ?? {};

      final orderedProductKeys = orderedProductData.keys.toList();

      final orderedProductCount = orderedProductKeys.length;

      num amountToPayForPending = 0;

      if (detailOrderData?.get("status") == "pending") {
        orderedProductData.forEach((key, value) {
          amountToPayForPending = amountToPayForPending +
              (value['product_price'] * value['quantity']);
        });
      }

      return Scaffold(
        appBar: defaultAppBar("Detail Order", hasBack: true, actions: [
          PopupMenuButton(
            onSelected: (value) async {
              if (value == 2) {
                Get.defaultDialog(
                  title: "Konfirmasi",
                  middleText: 'Ingin menghapus transaksi ini?',
                  textCancel: "Batal",
                  textConfirm: "Hapus",
                  confirmTextColor: Colors.white,
                  onConfirm: () async {
                    Get.back();
                    await controller.deleteOrder(orderId, () {
                      Get.back();
                      Get.snackbar("Success", "Order deleted succesfully",
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 44));
                    });
                  },
                );
              }
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.trash,
                      color: Colors.red,
                      size: 18,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Hapus Transaksi'),
                  ],
                ),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                FontAwesomeIcons.ellipsisVertical,
                color: primaryColor,
                size: 18,
              ),
            ),
          )
        ]),
        body: controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Text(
                          "Order #${detailOrderData?.get("order_id")}",
                          style: TextStyle(color: Colors.white),
                        ),
                        Spacer(),
                        Text(
                          "Name: ${detailOrderData?.get("name")}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  controller.editMode.value
                      ? Container(
                          margin: EdgeInsets.all(16),
                          child: CustomTextInput(
                              label: "Atas Nama",
                              hint: "Atas nama pembeli",
                              controller: controller.nameCon),
                        )
                      : SizedBox.shrink(),
                  Expanded(
                    child: ListView.separated(
                        padding: EdgeInsets.all(12),
                        itemBuilder: (context, index) {
                          final orderedProduct = controller
                                  .tempEditProduct[orderedProductKeys[index]] ??
                              {};

                          return OrderedItemCard(
                            itemCount: orderedProduct['quantity'] ?? 0,
                            itemName: orderedProduct["product_name"] ?? "",
                            itemPrice: orderedProduct["product_price"] ?? 0,
                            isEdit: controller.editMode.value,
                            onMinusClick: () {
                              controller.decrementOrDeleteProduct(
                                  orderedProductKeys[index]);
                            },
                            onPlusClick: () {
                              controller
                                  .incrementProduct(orderedProductKeys[index]);
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 24,
                            thickness: 1,
                            color: Colors.grey.shade200,
                          );
                        },
                        itemCount: controller.tempEditProduct.keys.length),
                  ),
                ],
              ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(12),
          color: Colors.white,
          child: controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            color: Color(0xFF2A3256),
                            fontSize: 16,
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        Spacer(),
                        AutoSizeText(
                          NumberFormat.simpleCurrency(
                                  locale: "id", name: "Rp. ", decimalDigits: 0)
                              .format(amountToPayForPending == 0
                                  ? detailOrderData?.get("total_amount") ?? 0
                                  : amountToPayForPending),
                          style: TextStyle(
                            color: Color(0xFF2A3256),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                            color: Color(0xFF2A3256),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          decoration: ShapeDecoration(
                            color: detailOrderData?.get("status") == 'paid'
                                ? Color(0xFF35CD1D)
                                : detailOrderData?.get("status") == 'pending'
                                    ? Colors.yellow.shade700
                                    : Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                GetUtils.capitalize(
                                        detailOrderData?.get("status") ?? "") ??
                                    "",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: MaterialButton(
                          onPressed: () {
                            if (controller.editMode.value) {
                              //TODO - edit transaction

                              controller.updateTransaction(orderId, () {
                                controller.getOrderDetail(orderId);
                              });
                            }

                            controller.setEditMode(!controller.editMode.value);
                          },
                          padding: EdgeInsets.all(12),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            controller.editMode.value
                                ? "Selesai Edit"
                                : 'Edit Pesanan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        )),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                            child: MaterialButton(
                          onPressed: () {
                            // Get.to(PaymentPage(
                            //   priceToPay: 1000,
                            // ));

                            controller.setSelectedEditStatus(detailOrderData?.get("status"));

                            Get.bottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      topLeft: Radius.circular(12)),
                                ),
                                backgroundColor: Colors.white,
                                Obx(() => Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              controller.setSelectedEditStatus(
                                                  "paid");
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 5),
                                                  decoration: ShapeDecoration(
                                                    color: Color(0xFF35CD1D),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Paid",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                Radio<String>(
                                                  value: 'paid',
                                                  groupValue: controller
                                                      .selectedEditStatus.value,
                                                  onChanged: (value) {
                                                    controller
                                                        .setSelectedEditStatus(
                                                            value ?? "paid");
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              controller.setSelectedEditStatus(
                                                  "pending");
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 5),
                                                  decoration: ShapeDecoration(
                                                    color:
                                                        Colors.yellow.shade700,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Pending",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                Radio<String>(
                                                  value: 'pending',
                                                  groupValue: controller
                                                      .selectedEditStatus.value,
                                                  onChanged: (value) {
                                                    controller
                                                        .setSelectedEditStatus(
                                                            value ?? "pending");
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              controller.setSelectedEditStatus(
                                                  "cancel");
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 5),
                                                  decoration: ShapeDecoration(
                                                    color: Colors.red,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                Radio<String>(
                                                  value: 'cancel',
                                                  groupValue: controller
                                                      .selectedEditStatus.value,
                                                  onChanged: (value) {
                                                    controller
                                                        .setSelectedEditStatus(
                                                            value ?? "cancel");
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: MaterialButton(
                                              onPressed: () {
                                                if (detailOrderData
                                                        ?.get("status") !=
                                                    "paid") {
                                                  if (controller
                                                          .selectedEditStatus
                                                          .value ==
                                                      "paid") {
                                                    Get.defaultDialog(
                                                        title: "Bayar Pesanan",
                                                        confirmTextColor: Colors.white,
                                                        textConfirm: "Bayar",
                                                        onConfirm: () {
                                                          controller
                                                              .updateTransactionStatus(
                                                              orderId, () {
                                                            Get.back();
                                                            Get.back();
                                                            controller
                                                                .getOrderDetail(orderId);
                                                          });
                                                        },
                                                        content:Obx(() =>  Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            AutoSizeText(
                                                              "Jumlah Bayar: ${NumberFormat.simpleCurrency(locale: "id", name: "Rp. ", decimalDigits: 0).format(detailOrderData?.get("total_amount") ?? 0)}",
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF2A3256),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 12,
                                                            ),
                                                            CustomTextInput(
                                                              label:
                                                              "Masukkan jumlah bayar",
                                                              hint: "10.000",
                                                              inputType:
                                                              TextInputType
                                                                  .number,
                                                              controller: controller
                                                                  .paidAmountCon,
                                                              onChanged:
                                                                  (text) {
                                                                final paidPriceValue = text
                                                                    .replaceAll(
                                                                    "Rp. ",
                                                                    "")
                                                                    .replaceAll(
                                                                    ".",
                                                                    "");

                                                                controller
                                                                    .change
                                                                    .value = (int.parse(paidPriceValue.isEmpty
                                                                    ? "0"
                                                                    : paidPriceValue) -
                                                                    detailOrderData
                                                                        ?.get("total_amount"))
                                                                    .toInt();

                                                                controller
                                                                    .paidAmountCon
                                                                    .text = NumberFormat.simpleCurrency(
                                                                    locale:
                                                                    "id",
                                                                    name:
                                                                    "Rp. ",
                                                                    decimalDigits:
                                                                    0)
                                                                    .format(int.parse(paidPriceValue
                                                                    .isEmpty
                                                                    ? "0"
                                                                    : paidPriceValue));
                                                              },
                                                            ),
                                                            SizedBox(
                                                              height: 8,
                                                            ),
                                                            MaterialButton(
                                                              onPressed: () {
                                                                controller
                                                                    .paidAmountCon
                                                                    .text = NumberFormat.simpleCurrency(
                                                                    locale:
                                                                    "id",
                                                                    name:
                                                                    "Rp. ",
                                                                    decimalDigits:
                                                                    0)
                                                                    .format(
                                                                    detailOrderData?.get("total_amount") ??
                                                                        0);

                                                                final paidPriceValue = controller
                                                                    .paidAmountCon
                                                                    .text
                                                                    .replaceAll(
                                                                    "Rp. ",
                                                                    "")
                                                                    .replaceAll(
                                                                    ".",
                                                                    "");

                                                                controller
                                                                    .change
                                                                    .value = (int.parse(paidPriceValue.isEmpty
                                                                    ? "0"
                                                                    : paidPriceValue) -
                                                                    detailOrderData
                                                                        ?.get("total_amount"))
                                                                    .toInt();
                                                              },
                                                              padding:
                                                              EdgeInsets
                                                                  .all(6),
                                                              minWidth: 0,
                                                              color:
                                                              primaryColor,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      12)),
                                                              child: Text(
                                                                'Uang Pas',
                                                                textAlign:
                                                                TextAlign
                                                                    .center,
                                                                style:
                                                                TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10,
                                                                  fontFamily:
                                                                  'Rubik',
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                                  height: 0,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 12,
                                                            ),
                                                            controller.change
                                                                .value ==
                                                                0
                                                                ? const SizedBox
                                                                .shrink()
                                                                : AutoSizeText(
                                                              "Kembalian: ${NumberFormat.simpleCurrency(locale: "id", name: "Rp. ", decimalDigits: 0).format(controller.change.value)}",
                                                              style:
                                                              TextStyle(
                                                                color: Color(
                                                                    0xFF2A3256),
                                                                fontSize:
                                                                20,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        )));
                                                  }
                                                }else{
                                                  controller
                                                      .updateTransactionStatus(
                                                      orderId, () {
                                                    Get.back();
                                                    controller
                                                        .getOrderDetail(orderId);
                                                  });
                                                }


                                              },
                                              padding: EdgeInsets.all(12),
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: primaryColor,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Text(
                                                'Ubah Status',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 16,
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.w500,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )));
                          },
                          padding: EdgeInsets.all(12),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            'Ubah Status',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        )),
                      ],
                    )
                  ],
                ),
        ),
      );
    });
  }
}
