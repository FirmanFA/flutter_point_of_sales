import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constant/constant.dart';

class HomeController extends GetxController {

  var thisMonthTransaction = RxList<QueryDocumentSnapshot>([]);

  var incomeTotal = 0.obs;
  var transactionCount = 0.obs;
  var productSold = 0.obs;
  var mostSoldProduct = "".obs;

  getThisMonthTransactions() async {

    incomeTotal.value = 0;
    transactionCount.value = 0;
    productSold.value = 0;
    mostSoldProduct.value = "";

    final now = DateTime.now();

    final firstDateOfMonth = DateTime(now.year, now.month, 1);

    final lastDateOfMonth = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 0)
        : DateTime(now.year + 1, 1, 0);

    final firstDateOfMonthTimestamp = Timestamp.fromDate(firstDateOfMonth);
    final lastDateOfMonthTimestamp = Timestamp.fromDate(lastDateOfMonth);

    final query = await fDb
        .collection('transactions')
        .where('timestamp', isGreaterThanOrEqualTo: firstDateOfMonthTimestamp)
        .where('timestamp', isLessThanOrEqualTo: lastDateOfMonthTimestamp)
        .orderBy("timestamp")
        .get();

    List<QueryDocumentSnapshot> tempThisMonthTransactions = [];
    for (QueryDocumentSnapshot transaction in query.docs) {
      debugPrint(
          "transaction date ${(transaction.get("timestamp") as Timestamp).toDate().toIso8601String()}");

      if(transaction.get("status") == "paid"){
        incomeTotal += transaction.get("total_amount");
        transactionCount += 1;

        // String mostSoldProductKey = "";

        final products = transaction.get("products") as Map;
        products.forEach((key, value) {
          productSold += value['quantity'];
        });

      }

      tempThisMonthTransactions.add(transaction);
    }

    thisMonthTransaction.value = tempThisMonthTransactions;


  }
}
