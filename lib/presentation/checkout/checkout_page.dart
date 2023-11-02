import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/constant/constant.dart';
import 'package:point_of_sales/presentation/checkout/checkout_controller.dart';
import 'package:point_of_sales/presentation/order/order_controller.dart';
import 'package:point_of_sales/presentation/payment/payment_page.dart';
import 'package:point_of_sales/presentation/product/product_controller.dart';
import 'package:point_of_sales/widget/card/ordered_item_card.dart';
import 'package:point_of_sales/widget/default_app_bar.dart';
import 'package:point_of_sales/widget/text_input_widget.dart';

class CheckoutPage extends StatelessWidget {
  final int priceToPay;

  const CheckoutPage({Key? key, required this.priceToPay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find();
    final ProductController productController = Get.find();
    final CheckoutController controller = Get.put(CheckoutController());

    return Scaffold(
      appBar: defaultAppBar("Detail Order", hasBack: true, actions: [
        PopupMenuButton(
          onSelected: (value) async {},
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 2,
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.ban,
                    color: Colors.red,
                    size: 18,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text('Batalkan Pesanan'),
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
      body: ListView.separated(
          padding: EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final orderedProductData =
                productController.allProductList.firstWhere((element) {
              return element.id ==
                  orderController.selectedItemList.keys.toList()[index];
            });

            return OrderedItemCard(
              itemCount:
                  orderController.selectedItemList[orderedProductData.id],
              itemName: orderedProductData.get("product_name"),
              itemPrice: orderedProductData.get("product_price"),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 24,
              thickness: 1,
              color: Colors.grey.shade200,
            );
          },
          itemCount: orderController.selectedItemList.keys.length),
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
                      .format(priceToPay),
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
                    Get.defaultDialog(
                        title: "Selesaikan Transaksi",
                        confirmTextColor: Colors.white,
                        textConfirm: "Konfirmasi",
                        onConfirm: () {

                          final orderedProductData = {};

                          orderController.selectedItemList.forEach((key, value) {

                            final productData = productController.allProductList.firstWhere((element) {
                              return element.id == key;
                            });

                            orderedProductData[key] = {
                              'product_category': productData.get("product_category"),
                              'product_name': productData.get("product_name"),
                              'product_price': productData.get("product_price"),
                              'quantity': value,
                            };

                          });

                          controller.savePendingTransaction(
                              name: controller.nameCon.text,
                              orderedProduct: orderedProductData,).then((value){

                            Get.until((route) => route.isFirst);

                          });

                        },
                        content: CustomTextInput(
                            label: "Masukkan atas nama",
                            hint: "Atas nama pembeli",
                            controller: controller.nameCon));
                  },
                  padding: EdgeInsets.all(12),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: primaryColor, width: 1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    'Bayar Nanti',
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
                      priceToPay: priceToPay,
                    ));
                  },
                  padding: EdgeInsets.all(12),
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    'Bayar Sekarang',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
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
  }
}
