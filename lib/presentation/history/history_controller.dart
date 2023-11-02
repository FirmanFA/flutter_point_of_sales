import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/constant.dart';

class HistoryController extends GetxController
    with GetTickerProviderStateMixin {
  RxList<QueryDocumentSnapshot> filteredTransactionList = RxList([]);
  RxList<QueryDocumentSnapshot> allTransactionList = RxList([]);
  var transactionCount = 0.obs;

  RxList<String> listOfYear = RxList([]);
  RxList<String> listOfMonths = RxList([
    'semua',
    'januari',
    'februari',
    'maret',
    'april',
    'mei',
    'juni',
    'juli',
    'agustus',
    'september',
    'oktober',
    'november',
    'desember',
  ]);

  var selectedYear = "semua".obs;
  var selectedMonth = "semua".obs;

  var selectedStatus = 0.obs;

  late TabController tabController;

  @override
  onInit() {
    super.onInit();

    tabController = TabController(length: 4, vsync: this);

    getTransaction();
    applyFilter();
  }

  setSelectedStatus(int status) {
    selectedStatus.value = status;
  }

  setSelectedYear(String year) {
    selectedYear.value = year;
  }

  setSelectedMonth(String month) {
    selectedMonth.value = month;
  }

  getTransaction() {
    allTransactionList.bindStream(fDb
        .collection('transactions')
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<QueryDocumentSnapshot> transactions = [];
      final tempListOfYear = <String>{"semua"};
      listOfYear.clear();
      for (QueryDocumentSnapshot transaction in query.docs) {
        transactions.add(transaction);
        final date = (transaction.get("timestamp") as Timestamp).toDate();
        tempListOfYear.add(date.year.toString());
      }

      listOfYear.addAll(tempListOfYear.toList());

      // listOfYear.sort();

      debugPrint("data tahun $listOfYear");

      // allTransactionList.value = transactions;

      transactionCount.value = transactions.length;

      return transactions;
    }));
  }

  applyFilter() {
    String status = "";
    switch (selectedStatus.value) {
      case 0:
        status = "";
        break;
      case 1:
        status = "paid";
        break;
      case 2:
        status = "pending";
        break;
      case 3:
        status = "cancel";
        break;
    }
    debugPrint("status $status");

    filteredTransactionList.value = allTransactionList.where((element) {
      bool returnStatus;
      bool returnMonth;
      bool returnYear;

      final transactionDate = (element.get("timestamp") as Timestamp).toDate();

      if (status == "") {
        returnStatus = true;
      } else {
        returnStatus = element.get("status") == status;
      }

      if (selectedMonth.value == "semua") {
        returnMonth = true;
      } else {
        returnMonth =
            transactionDate.month == listOfMonths.indexOf(selectedMonth.value);
        //
        // debugPrint("transaction date ${transactionDate.month}");
        // debugPrint("selected date index ${listOfMonths.indexOf(selectedMonth.value)}");

      }

      if (selectedYear.value == "semua") {
        returnYear = true;
      } else {
        returnYear = transactionDate.year.toString() == selectedYear.value;
      }
      //
      // debugPrint("selected month $selectedMonth");
      // debugPrint("returned month $returnMonth");
      // debugPrint("returned year $returnYear");
      // debugPrint("selected year $selectedYear");

      return returnStatus && returnYear && returnMonth;

    }).toList();
  }
}
