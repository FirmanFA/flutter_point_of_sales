import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_of_sales/constant/constant.dart';

class CheckoutController extends GetxController {
  final nameCon = TextEditingController();

  Future savePendingTransaction({
    required String name,
    required Map orderedProduct,
    required int priceToPay
  }) async {
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

      await fDb.collection('transactions').add({
        'order_id': (lastOrderId ?? 0) + 1,
        'name': name,
        'products': orderedProduct,
        'status': "pending",
        'timestamp': Timestamp.now(),
        'total_amount': priceToPay
      }).then((value) {
        orderedProduct.forEach((key, value) {
          debugPrint("map data $key $value");
          fDb.collection("products").doc(key).update(
            {'product_stock': FieldValue.increment(value['quantity'] * -1)},
          );
        });

        Get.snackbar("Success", "Transaksi berhasil tersimpan",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 44));
        return null;
      });
    });
  }
}
