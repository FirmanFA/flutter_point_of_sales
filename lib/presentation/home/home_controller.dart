import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dio_client;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../constant/constant.dart';

class HomeController extends GetxController {

  List<Placemark> placemarks = [];

  /// variable to store this month transactions list
  var thisMonthTransaction = RxList<QueryDocumentSnapshot>([]);

  /// variable to store up to last 5 transactions
  var latest5TransactionData = RxList<QueryDocumentSnapshot>([]);

  /// variable to store product data with smallest stock (under 20)
  var productWithSmallestStock = Rxn<QueryDocumentSnapshot>();

  /// variable to store this month transactions to show in chart
  var formattedThisMonthTransaction = RxList<FlSpot>([]);

  /// variable to store income total for this month transactions
  var incomeTotal = 0.obs;

  /// variable to store this month transactions count
  var transactionCount = 0.obs;

  /// variable to store this month transactions product sold
  var productSold = 0.obs;

  /// variable to store this month transactions most sold product
  var mostSoldProduct = "".obs;

  /// variable to store most transactions is a day at this month
  var maxTransactionCountThisMonth = 0.obs;

  /// variable to store is currently loading a data
  var isLoading = true.obs;

  @override
  onInit() {
    super.onInit();

    getLatest5TransactionData();
    getThisMonthTransactions();
    getSmallestStockProduct();
  }


  /// this function used to get this month transactions
  getThisMonthTransactions() async {
    /// set loading to true to indicate a network loading
    isLoading.value = true;

    /// reset the data
    incomeTotal.value = 0;
    transactionCount.value = 0;
    productSold.value = 0;
    mostSoldProduct.value = "";

    final now = DateTime.now();

    /// get the first date of month
    final firstDateOfMonth = DateTime(now.year, now.month, 1);

    /// get the last date of month (30, 31, 29, or 28 depending on the month)
    final lastDateOfMonth = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 0)
        : DateTime(now.year + 1, 1, 0);

    /// set a Timestamp (a data type used in firebase to store a date)
    /// from date set before
    final firstDateOfMonthTimestamp = Timestamp.fromDate(firstDateOfMonth);
    final lastDateOfMonthTimestamp = Timestamp.fromDate(lastDateOfMonth);

    /// get data from 'transactions' collection where the timestamp is
    /// after first date of the month and before last date of the month
    final query = await fDb
        .collection('transactions')
        .where('timestamp', isGreaterThanOrEqualTo: firstDateOfMonthTimestamp)
        .where('timestamp', isLessThanOrEqualTo: lastDateOfMonthTimestamp)
        .orderBy("timestamp")
        .get();

    List<QueryDocumentSnapshot> tempThisMonthTransactions = [];

    /// loop through this month transactions data
    for (QueryDocumentSnapshot transaction in query.docs) {
      /// calculate total income, product sold, and transaction count
      /// from paid transaction only
      if (transaction.get("status") == "paid") {
        /// increment the total income with current
        /// transaction 'total_amount' value
        incomeTotal += transaction.get("total_amount");

        /// increment transaction count
        transactionCount += 1;

        final products = transaction.get("products") as Map;

        /// loop through products bought for current transaction data
        products.forEach((key, value) {
          /// increment product sold with
          /// quantity bought for every product sold
          productSold += value['quantity'];
        });
      }

      /// store this month transaction data to temporary variable
      tempThisMonthTransactions.add(transaction);
    }

    /// set this month transaction data to variable
    thisMonthTransaction.value = tempThisMonthTransactions;

    /// call a function to format the transaction data to show it on chart
    getFormattedThisMonthTransactionData();

    isLoading.value = false;
  }

  /// a function to format the transaction data to show it on chart
  /// the chart need a list of (int, int) to represent transaction date,
  /// and transaction count
  /// so, this function will be converting raw transaction data from firebase
  /// to (date, product sold) format for the chart to read
  getFormattedThisMonthTransactionData() {
    /// first parameter represent transaction count, second parameter represent date
    /// FlSpot(0, 1),

    Map mappedTransactionData = {};

    /// make a list from 1 to 31 to represent date for a month
    /// with default value = 0
    for (int i = 1; i <= 31; i++) {
      mappedTransactionData[i.toString()] = 0;
    }

    /// loop through this month transactions data
    for (var element in thisMonthTransaction) {
      /// get the transaction date day for current transaction data
      final transactionDate =
          (element.get("timestamp") as Timestamp).toDate().day.toString();

      num productCount = 0;

      /// count product sold for current transaction data is status is paid
      if (element.get("status") == "paid") {
        final products = element.get("products") as Map;
        products.forEach((key, value) {
          productCount += value['quantity'];
        });
      }

      /// set the sold product to the date
      mappedTransactionData[transactionDate] += productCount.toInt();
    }

    List<FlSpot> tempFormattedTransactionData = [];
    int tempMaxCount = 0;

    /// loop through a month to add the data to chart,
    /// and calculate the max transaction count of the month
    mappedTransactionData.forEach((key, value) {
      /// change the tempMaxCount value to current value if
      /// the value is greater than tempMaxCount
      tempMaxCount = tempMaxCount > value ? tempMaxCount : value;

      /// change the mapptedTransactionData to chart readable data type (FlSpot)
      tempFormattedTransactionData
          .add(FlSpot(double.parse(key), double.parse("$value")));
    });

    /// set the max count from the temporary variable
    maxTransactionCountThisMonth.value = tempMaxCount;

    /// set the formatted transaction data from temporary variable
    formattedThisMonthTransaction.value = tempFormattedTransactionData;
  }

  /// a function to get last 5 transaction data
  getLatest5TransactionData() async {
    /// set loading to true to indicate network loading
    isLoading.value = true;

    /// get data from 'transactions' collection in firebase
    /// order the data by the latest date and limit to first 5 data
    final query = await fDb
        .collection('transactions')
        .orderBy("timestamp", descending: true)
        .limit(5)
        .get();

    /// loop through the query result and add it to temporary variable
    List<QueryDocumentSnapshot> tempLatest5Transactions = [];
    for (QueryDocumentSnapshot transaction in query.docs) {
      tempLatest5Transactions.add(transaction);
    }

    /// set the latest5TransactionData from temporary variable
    latest5TransactionData.value = tempLatest5Transactions;

    /// set loading to false to indicate finished network request
    isLoading.value = false;
  }

  /// a function to get a product data with smallest stock under 20
  getSmallestStockProduct() {
    /// get data from 'products' collection in firebase with stock under 20
    /// order the data by the stock and limit to 1 data
    fDb
        .collection("products")
        .where("product_stock", isLessThanOrEqualTo: 20)
        .orderBy("product_stock")
        .limit(1)
        .get()
        .then((value) {
      /// add the result to productWithSmallestStock
      for (var element in value.docs) {
        productWithSmallestStock.value = element;
      }
    });
  }

}
