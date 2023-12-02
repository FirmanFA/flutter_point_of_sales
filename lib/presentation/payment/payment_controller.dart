import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_of_sales/constant/constant.dart';

class PaymentController extends GetxController {

  /// to store input name
  final nameCon = TextEditingController();

  /// to store buyer paid amount
  final paidAmountCon = TextEditingController();

  /// store buyer change
  var change = 0.obs;

  /// function to create a paid transaction
  Future savePaidTransaction(
      {required String name,
      required Map orderedProduct,
      required int totalAmount}) async {

    /// get last transaction data to get last order id
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

      /// add transaction to firebase
      await fDb.collection('transactions').add({
        'order_id': (lastOrderId ?? 0) + 1,
        'name': name,
        'products': orderedProduct,
        'status': 'paid',
        'timestamp': Timestamp.now(),
        'total_amount': totalAmount
      }).then((value) {

        /// update product stock for every product sold in this transaction
        orderedProduct.forEach((key, value) async {
          debugPrint("map data $key $value");
          await fDb.collection("products").doc(key).update(
            {'product_stock': FieldValue.increment(value['quantity'] * -1)},
          );
        });

        /// show success message when done
        Get.snackbar("Success", "Transaksi berhasil tersimpan",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 44));
        return null;
      });
    });
  }
}
