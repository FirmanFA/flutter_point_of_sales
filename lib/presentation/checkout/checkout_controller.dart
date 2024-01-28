import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_of_sales/constant/constant.dart';

class CheckoutController extends GetxController {

  /// to store name user input
  final nameCon = TextEditingController();


  /// function to make a pending transction
  Future savePendingTransaction({
    /// name of buyer
    required String name,
    /// list of product ordered, including the quantity
    required Map orderedProduct,
    /// total price needs to pay
    required int priceToPay
  }) async {

    /// get last transaction to get the last order id
    await fDb
        .collection("transactions")
        .orderBy("order_id", descending: true)
        .limit(1)
        .get()
        .then((value) async {
      int? lastOrderId;

      for (var element in value.docs) {
        lastOrderId = element.get("order_id");
      }

      /// add transaction to firebase with pending status
      await fDb.collection('transactions').add({
        /// set the order id to last order id got from before + 1
        'order_id': (lastOrderId ?? 0) + 1,
        'name': name,
        'products': orderedProduct,
        'status': "pending",
        'timestamp': Timestamp.now(),
        'total_amount': priceToPay
      }).then((value)  {

        /// when done create transaction, update
        /// product stock from list of ordered product
        ///
        /// loop through ordered product
        orderedProduct.forEach((key, value) async {

          /// update product stock according to ordered quantity
          await fDb.collection("products").doc(key).update(
            /// FieldValue is the original field of product_stock
            /// since firebase don't support decrement,
            /// * -1 is to make the increment minus, so the stock can decrease
            ///
            {'product_stock': FieldValue.increment(value['quantity'] * -1)},
          );
        });

        /// show a success message when done
        Get.snackbar("Success", "Transaksi berhasil tersimpan",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 44));
        return null;
      });
    });
  }
}
