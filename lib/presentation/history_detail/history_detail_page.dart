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
                  onConfirm: () {
                    Get.back();
                    controller.deleteOrder(orderId, () {
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
        body: controller.isLoading.value ? Center(child: CircularProgressIndicator(),) : Column(
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
                    final orderedProduct =
                        controller.tempEditProduct[orderedProductKeys[index]]??{};

                    return OrderedItemCard(
                      itemCount: orderedProduct['quantity']??0,
                      itemName: orderedProduct["product_name"]??"",
                      itemPrice: orderedProduct["product_price"]??0,
                      isEdit: controller.editMode.value,
                      onMinusClick: () {
                        controller.decrementOrDeleteProduct(
                            orderedProductKeys[index]);
                      },
                      onPlusClick: () {
                        controller.incrementProduct(orderedProductKeys[index]);
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
          child: Column(
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
                            ? detailOrderData?.get("total_amount")??0
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
                  Expanded(
                      child: MaterialButton(
                    onPressed: () {

                      if(controller.editMode.value){
                        //TODO - edit transaction

                        controller.updateTransaction(orderId, (){
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
                      Get.to(PaymentPage(
                        priceToPay: 1000,
                      ));
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
