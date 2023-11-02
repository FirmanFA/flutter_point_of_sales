import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/constant/constant.dart';
import 'package:point_of_sales/presentation/payment/payment_controller.dart';
import 'package:point_of_sales/widget/default_app_bar.dart';
import 'package:point_of_sales/widget/text_input_widget.dart';

import '../order/order_controller.dart';
import '../product/product_controller.dart';

class PaymentPage extends GetView {
  final int priceToPay;

  const PaymentPage({Key? key, required this.priceToPay}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final OrderController orderController = Get.find();
    final ProductController productController = Get.find();

    final controller = Get.put(PaymentController());

    return Scaffold(
      appBar: defaultAppBar("Pembayaran"),
      body: Obx(() => SingleChildScrollView(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 12,
                ),
                CustomTextInput(
                  label: "Masukkan atas nama",
                  hint: "Atas nama pembeli",
                  controller: controller.nameCon,
                ),
                SizedBox(
                  height: 12,
                ),
                AutoSizeText(
                  "Jumlah Bayar: ${NumberFormat.simpleCurrency(locale: "id", name: "Rp. ", decimalDigits: 0).format(priceToPay)}",
                  style: TextStyle(
                    color: Color(0xFF2A3256),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                CustomTextInput(
                  label: "Masukkan jumlah bayar",
                  hint: "10.000",
                  inputType: TextInputType.number,
                  controller: controller.paidAmountCon,
                  onChanged: (text) {
                    final paidPriceValue =
                        text.replaceAll("Rp. ", "").replaceAll(".", "");

                    controller.change.value = int.parse(
                            paidPriceValue.isEmpty ? "0" : paidPriceValue) -
                        priceToPay;

                    controller.paidAmountCon.text = NumberFormat.simpleCurrency(
                            locale: "id", name: "Rp. ", decimalDigits: 0)
                        .format(int.parse(
                            paidPriceValue.isEmpty ? "0" : paidPriceValue));
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                MaterialButton(
                  onPressed: () {
                    controller.paidAmountCon.text = NumberFormat.simpleCurrency(
                            locale: "id", name: "Rp. ", decimalDigits: 0)
                        .format(priceToPay);

                    final paidPriceValue = controller.paidAmountCon.text
                        .replaceAll("Rp. ", "")
                        .replaceAll(".", "");

                    controller.change.value = int.parse(
                            paidPriceValue.isEmpty ? "0" : paidPriceValue) -
                        priceToPay;
                  },
                  padding: EdgeInsets.all(12),
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    'Uang Pas',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                controller.change.value == 0
                    ? const SizedBox.shrink()
                    : AutoSizeText(
                        "Kembalian: ${NumberFormat.simpleCurrency(locale: "id", name: "Rp. ", decimalDigits: 0).format(controller.change.value)}",
                        style: TextStyle(
                          color: Color(0xFF2A3256),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ],
            ),
          )),
      bottomNavigationBar: Obx(() => Container(
            padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
            color: Colors.white,
            child: MaterialButton(
              onPressed: () {

                if(!controller.change.isNegative){
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

                  controller.savePaidTransaction(
                      name: controller.nameCon.text,
                      orderedProduct: orderedProductData,
                      totalAmount: priceToPay).then((value){

                        Get.until((route) => route.isFirst);

                  });
                }

              },
              padding: EdgeInsets.all(12),
              color: controller.change.value >= 0 &&
                      controller.paidAmountCon.text.isNotEmpty
                  ? primaryColor
                  : Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Text(
                'Simpan Transaksi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ),
          )),
      // bottomNavigationBar: Container(
      //   padding: const EdgeInsets.only(top: 12, left: 8, right: 9, bottom: 13),
      //   clipBehavior: Clip.antiAlias,
      //   decoration: BoxDecoration(color: Color(0xFFE6E6E6)),
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Row(
      //         mainAxisSize: MainAxisSize.min,
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Expanded(
      //             child: MaterialButton(
      //               height: 48,
      //               padding: const EdgeInsets.all(8),
      //                 color: Colors.white,
      //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      //               onPressed: () {
      //
      //               },
      //               child: Center(
      //                 child:Text(
      //                   '1',
      //                   style: TextStyle(
      //                     color: Colors.black,
      //                     fontSize: 25,
      //                     fontWeight: FontWeight.w400,
      //                   ),
      //                 )
      //               )
      //             ),
      //           ),
      //           const SizedBox(width: 7),
      //           Expanded(
      //             child: Container(
      //                 height: 48,
      //                 padding: const EdgeInsets.all(8),
      //                 decoration: ShapeDecoration(
      //                   color: Colors.white,
      //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      //                   shadows: [
      //                     BoxShadow(
      //                       color: Color(0x3F000000),
      //                       blurRadius: 0,
      //                       offset: Offset(0, 1),
      //                       spreadRadius: 0,
      //                     )
      //                   ],
      //                 ),
      //                 child: Center(
      //                     child:Text(
      //                       '2',
      //                       style: TextStyle(
      //                         color: Colors.black,
      //                         fontSize: 25,
      //                         fontWeight: FontWeight.w400,
      //                       ),
      //                     )
      //                 )
      //             ),
      //           ),
      //           const SizedBox(width: 7),
      //           Expanded(
      //             child: Container(
      //                 height: 48,
      //                 padding: const EdgeInsets.all(8),
      //                 decoration: ShapeDecoration(
      //                   color: Colors.white,
      //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      //                   shadows: [
      //                     BoxShadow(
      //                       color: Color(0x3F000000),
      //                       blurRadius: 0,
      //                       offset: Offset(0, 1),
      //                       spreadRadius: 0,
      //                     )
      //                   ],
      //                 ),
      //                 child: Center(
      //                     child:Text(
      //                       '3',
      //                       style: TextStyle(
      //                         color: Colors.black,
      //                         fontSize: 25,
      //                         fontWeight: FontWeight.w400,
      //                       ),
      //                     )
      //                 )
      //             ),
      //           ),
      //           const SizedBox(width: 7),
      //           Expanded(
      //             child: Container(
      //               height: 48,
      //               decoration: ShapeDecoration(
      //                 color: Color(0xFFD1D1D1),
      //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      //                 shadows: [
      //                   BoxShadow(
      //                     color: Color(0x3F000000),
      //                     blurRadius: 0,
      //                     offset: Offset(0, 1),
      //                     spreadRadius: 0,
      //                   )
      //                 ],
      //               ),
      //               child: Icon(FontAwesomeIcons.deleteLeft),
      //             ),
      //           ),
      //         ],
      //       ),
      //       const SizedBox(height: 8),
      //       Row(
      //         mainAxisSize: MainAxisSize.min,
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Expanded(
      //             child: Container(
      //                 height: 48,
      //                 padding: const EdgeInsets.all(8),
      //                 decoration: ShapeDecoration(
      //                   color: Colors.white,
      //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      //                   shadows: [
      //                     BoxShadow(
      //                       color: Color(0x3F000000),
      //                       blurRadius: 0,
      //                       offset: Offset(0, 1),
      //                       spreadRadius: 0,
      //                     )
      //                   ],
      //                 ),
      //                 child: Center(
      //                     child:Text(
      //                       '4',
      //                       style: TextStyle(
      //                         color: Colors.black,
      //                         fontSize: 25,
      //                         fontWeight: FontWeight.w400,
      //                       ),
      //                     )
      //                 )
      //             ),
      //           ),
      //           const SizedBox(width: 7),
      //           Expanded(
      //             child: Container(
      //                 height: 48,
      //                 padding: const EdgeInsets.all(8),
      //                 decoration: ShapeDecoration(
      //                   color: Colors.white,
      //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      //                   shadows: [
      //                     BoxShadow(
      //                       color: Color(0x3F000000),
      //                       blurRadius: 0,
      //                       offset: Offset(0, 1),
      //                       spreadRadius: 0,
      //                     )
      //                   ],
      //                 ),
      //                 child: Center(
      //                     child:Text(
      //                       '5',
      //                       style: TextStyle(
      //                         color: Colors.black,
      //                         fontSize: 25,
      //                         fontWeight: FontWeight.w400,
      //                       ),
      //                     )
      //                 )
      //             ),
      //           ),
      //           const SizedBox(width: 7),
      //           Expanded(
      //             child: Container(
      //                 height: 48,
      //                 padding: const EdgeInsets.all(8),
      //                 decoration: ShapeDecoration(
      //                   color: Colors.white,
      //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      //                   shadows: [
      //                     BoxShadow(
      //                       color: Color(0x3F000000),
      //                       blurRadius: 0,
      //                       offset: Offset(0, 1),
      //                       spreadRadius: 0,
      //                     )
      //                   ],
      //                 ),
      //                 child: Center(
      //                     child:Text(
      //                       '6',
      //                       style: TextStyle(
      //                         color: Colors.black,
      //                         fontSize: 25,
      //                         fontWeight: FontWeight.w400,
      //                       ),
      //                     )
      //                 )
      //             ),
      //           ),
      //           const SizedBox(width: 7),
      //           Expanded(
      //             child: Container(
      //               height: 48,
      //               decoration: ShapeDecoration(
      //                 color: Color(0xFFD1D1D1),
      //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      //                 shadows: [
      //                   BoxShadow(
      //                     color: Color(0x3F000000),
      //                     blurRadius: 0,
      //                     offset: Offset(0, 1),
      //                     spreadRadius: 0,
      //                   )
      //                 ],
      //               ),
      //               child: Center(
      //                   child:Text(
      //                     'C',
      //                     style: TextStyle(
      //                       color: Colors.black,
      //                       fontSize: 25,
      //                       fontWeight: FontWeight.w400,
      //                     ),
      //                   )
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //       const SizedBox(height: 8),
      //       Row(
      //         mainAxisSize: MainAxisSize.min,
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Expanded(
      //             child: Container(
      //                 height: 48,
      //                 padding: const EdgeInsets.all(8),
      //                 decoration: ShapeDecoration(
      //                   color: Colors.white,
      //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      //                   shadows: [
      //                     BoxShadow(
      //                       color: Color(0x3F000000),
      //                       blurRadius: 0,
      //                       offset: Offset(0, 1),
      //                       spreadRadius: 0,
      //                     )
      //                   ],
      //                 ),
      //                 child: Center(
      //                     child:Text(
      //                       '7',
      //                       style: TextStyle(
      //                         color: Colors.black,
      //                         fontSize: 25,
      //                         fontWeight: FontWeight.w400,
      //                       ),
      //                     )
      //                 )
      //             ),
      //           ),
      //           const SizedBox(width: 7),
      //           Expanded(
      //             child: Container(
      //                 height: 48,
      //                 padding: const EdgeInsets.all(8),
      //                 decoration: ShapeDecoration(
      //                   color: Colors.white,
      //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      //                   shadows: [
      //                     BoxShadow(
      //                       color: Color(0x3F000000),
      //                       blurRadius: 0,
      //                       offset: Offset(0, 1),
      //                       spreadRadius: 0,
      //                     )
      //                   ],
      //                 ),
      //                 child: Center(
      //                     child:Text(
      //                       '8',
      //                       style: TextStyle(
      //                         color: Colors.black,
      //                         fontSize: 25,
      //                         fontWeight: FontWeight.w400,
      //                       ),
      //                     )
      //                 )
      //             ),
      //           ),
      //           const SizedBox(width: 7),
      //           Expanded(
      //             child: Container(
      //                 height: 48,
      //                 padding: const EdgeInsets.all(8),
      //                 decoration: ShapeDecoration(
      //                   color: Colors.white,
      //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      //                   shadows: [
      //                     BoxShadow(
      //                       color: Color(0x3F000000),
      //                       blurRadius: 0,
      //                       offset: Offset(0, 1),
      //                       spreadRadius: 0,
      //                     )
      //                   ],
      //                 ),
      //                 child: Center(
      //                     child:Text(
      //                       '9',
      //                       style: TextStyle(
      //                         color: Colors.black,
      //                         fontSize: 25,
      //                         fontWeight: FontWeight.w400,
      //                       ),
      //                     )
      //                 )
      //             ),
      //           ),
      //           const SizedBox(width: 7),
      //           Expanded(
      //             child: Container(
      //               height: 48,
      //               decoration: ShapeDecoration(
      //                 color: Color(0xFFD1D1D1),
      //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      //                 shadows: [
      //                   BoxShadow(
      //                     color: Color(0x3F000000),
      //                     blurRadius: 0,
      //                     offset: Offset(0, 1),
      //                     spreadRadius: 0,
      //                   )
      //                 ],
      //               ),
      //               child: SizedBox.shrink(),
      //             ),
      //           ),
      //         ],
      //       ),
      //       const SizedBox(height: 8),
      //       Row(
      //         mainAxisSize: MainAxisSize.min,
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Expanded(
      //             child: Container(
      //                 height: 48,
      //                 padding: const EdgeInsets.all(8),
      //                 decoration: ShapeDecoration(
      //                   color: Colors.white,
      //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      //                   shadows: [
      //                     BoxShadow(
      //                       color: Color(0x3F000000),
      //                       blurRadius: 0,
      //                       offset: Offset(0, 1),
      //                       spreadRadius: 0,
      //                     )
      //                   ],
      //                 ),
      //                 child: Center(
      //                     child:Text(
      //                       '00',
      //                       style: TextStyle(
      //                         color: Colors.black,
      //                         fontSize: 25,
      //                         fontWeight: FontWeight.w400,
      //                       ),
      //                     )
      //                 )
      //             ),
      //           ),
      //           const SizedBox(width: 7),
      //           Expanded(
      //             child: Container(
      //                 height: 48,
      //                 padding: const EdgeInsets.all(8),
      //                 decoration: ShapeDecoration(
      //                   color: Colors.white,
      //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      //                   shadows: [
      //                     BoxShadow(
      //                       color: Color(0x3F000000),
      //                       blurRadius: 0,
      //                       offset: Offset(0, 1),
      //                       spreadRadius: 0,
      //                     )
      //                   ],
      //                 ),
      //                 child: Center(
      //                     child:Text(
      //                       '0',
      //                       style: TextStyle(
      //                         color: Colors.black,
      //                         fontSize: 25,
      //                         fontWeight: FontWeight.w400,
      //                       ),
      //                     )
      //                 )
      //             ),
      //           ),
      //           const SizedBox(width: 7),
      //           Expanded(
      //             child: Container(
      //                 height: 48,
      //                 padding: const EdgeInsets.all(8),
      //                 decoration: ShapeDecoration(
      //                   color: Colors.white,
      //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      //                   shadows: [
      //                     BoxShadow(
      //                       color: Color(0x3F000000),
      //                       blurRadius: 0,
      //                       offset: Offset(0, 1),
      //                       spreadRadius: 0,
      //                     )
      //                   ],
      //                 ),
      //                 child: Center(
      //                     child:Text(
      //                       '000',
      //                       style: TextStyle(
      //                         color: Colors.black,
      //                         fontSize: 25,
      //                         fontWeight: FontWeight.w400,
      //                       ),
      //                     )
      //                 )
      //             ),
      //           ),
      //           const SizedBox(width: 7),
      //           Expanded(
      //             child: Container(
      //               height: 48,
      //               decoration: ShapeDecoration(
      //                 color: primaryColor,
      //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      //                 shadows: [
      //                   BoxShadow(
      //                     color: Color(0x3F000000),
      //                     blurRadius: 0,
      //                     offset: Offset(0, 1),
      //                     spreadRadius: 0,
      //                   )
      //                 ],
      //               ),
      //               child: Icon(FontAwesomeIcons.check,color: Colors.white,)
      //             ),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
