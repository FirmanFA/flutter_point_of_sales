import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constant/constant.dart';

class HomeController extends GetxController {
  var thisMonthTransaction = RxList<QueryDocumentSnapshot>([]);

  var latest5TransactionData = RxList<QueryDocumentSnapshot>([]);

  var productWithSmallestStock = Rxn<QueryDocumentSnapshot>();

  var formattedThisMonthTransaction = RxList<FlSpot>([]);

  var incomeTotal = 0.obs;
  var transactionCount = 0.obs;
  var productSold = 0.obs;
  var mostSoldProduct = "".obs;

  var maxTransactionCountThisMonth = 0.obs;

  var isLoading = true.obs;

  @override
  onInit() {
    super.onInit();

    getLatest5TransactionData();
    getThisMonthTransactions();
    getSmallestStockProduct();
  }

  getThisMonthTransactions() async {
    isLoading.value = true;

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

      if (transaction.get("status") == "paid") {
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

    getFormattedThisMonthTransactionData();

    isLoading.value = false;
  }

  getFormattedThisMonthTransactionData() {
    // first paramter represent transaction count, second parameter represent date
    // FlSpot(0, 1),

    Map mappedTransactionData = {};

    for (int i = 1; i <= 31; i++) {
      mappedTransactionData[i.toString()] = 0;
    }

    for (var element in thisMonthTransaction) {
      final transactionDate =
          (element.get("timestamp") as Timestamp).toDate().day.toString();

      num productCount = 0;

      if (element.get("status") == "paid") {
        final products = element.get("products") as Map;
        products.forEach((key, value) {
          productCount += value['quantity'];
        });
      }
      mappedTransactionData[transactionDate] += productCount.toInt();
    }

    List<FlSpot> tempFormattedTransactionData = [];
    int tempMaxCount = 0;
    mappedTransactionData.forEach((key, value) {
      tempMaxCount = tempMaxCount > value ? tempMaxCount : value;

      debugPrint("data format $key $value");

      tempFormattedTransactionData
          .add(FlSpot(double.parse(key), double.parse("$value")));
    });

    maxTransactionCountThisMonth.value = tempMaxCount;

    formattedThisMonthTransaction.value = tempFormattedTransactionData;
  }

  getLatest5TransactionData() async {

    isLoading.value = true;

    Future.delayed(Duration(seconds: 1));

    final query = await fDb
        .collection('transactions')
        .orderBy("timestamp", descending: true)
        .limit(5)
        .get();

    List<QueryDocumentSnapshot> tempLatest5Transactions = [];
    for (QueryDocumentSnapshot transaction in query.docs) {
      tempLatest5Transactions.add(transaction);
    }

    latest5TransactionData.value = tempLatest5Transactions;

    isLoading.value = false;

  }

  getSmallestStockProduct() {
    fDb
        .collection("products")
        .where("product_stock", isLessThanOrEqualTo: 20)
        .orderBy("product_stock")
        .limit(1)
        .get()
        .then((value) {
      for (var element in value.docs) {
        productWithSmallestStock.value = element;
      }
    });
  }
}
