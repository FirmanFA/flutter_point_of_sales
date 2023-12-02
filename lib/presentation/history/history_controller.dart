import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/constant.dart';

class HistoryController extends GetxController
    with GetTickerProviderStateMixin, StateMixin<List<QueryDocumentSnapshot>> {

  /// variable to store filtered transaction data
  RxList<QueryDocumentSnapshot> filteredTransactionList = RxList([]);

  /// variable to store unfiltered transaction data
  RxList<QueryDocumentSnapshot> allTransactionList = RxList([]);

  /// variable to store transaction count
  var transactionCount = 0.obs;

  /// variable to indicate a loading state
  var isLoading = false.obs;

  /// variable to store all year in transction data
  RxList<String> listOfYear = RxList([]);

  /// variable to store list of months
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

  /// variable to store selected filter year, default value is 'semua'
  var selectedYear = "semua".obs;

  /// variable to store selected filter month, default value is 'semua'
  var selectedMonth = "semua".obs;

  /// variable to store selected filter status,
  /// default value is 0 for all status
  var selectedStatus = 0.obs;

  /// a tab controller for status filtering
  late TabController tabController;

  @override
  onInit() {
    super.onInit();
    /// init the tab controller
    tabController = TabController(length: 4, vsync: this);
    getTransaction();
  }

  /// function to change selected status filter
  setSelectedStatus(int status) {
    selectedStatus.value = status;
  }

  /// function to change selected year filter
  setSelectedYear(String year) {
    selectedYear.value = year;
  }

  /// function to change selected year filter
  setSelectedMonth(String month) {
    selectedMonth.value = month;
  }

  /// function to get transaction data from firebase
  getTransaction() async {

    /// set loading to true to indicate a network request
    isLoading.value = true;

    /// get 'transactions' collection from firebase order by latest date
    final query = await fDb
        .collection('transactions')
        .orderBy("timestamp", descending: true).get();

    List<QueryDocumentSnapshot> transactions = [];

    /// a set data type to store available year in transaction data
    final tempListOfYear = <String>{"semua"};
    listOfYear.clear();

    /// loop through transaction data to get all the transaction year
    for (QueryDocumentSnapshot transaction in query.docs) {
      transactions.add(transaction);
      final date = (transaction.get("timestamp") as Timestamp).toDate();
      tempListOfYear.add(date.year.toString());
    }

    /// set the listOfYear from temporary variable
    listOfYear.addAll(tempListOfYear.toList());

    /// set the transactionCount
    transactionCount.value = transactions.length;

    /// set the transaction data
    allTransactionList.value = transactions;

    /// call apply filter function to filter the transacton data
    applyFilter();

    /// set loading to false to indicate finish loading
    isLoading.value = false;

  }


  /// function to refresh transaction list
  /// refer to getTransaction() function since it is using the same logic
  refreshList() async {
    
    change(null, status: RxStatus.loading());
    final query = await fDb
        .collection('transactions')
        .orderBy("timestamp", descending: true).get();

    List<QueryDocumentSnapshot> transactions = [];
    final tempListOfYear = <String>{"semua"};
    listOfYear.clear();
    for (QueryDocumentSnapshot transaction in query.docs) {
      transactions.add(transaction);
      final date = (transaction.get("timestamp") as Timestamp).toDate();
      tempListOfYear.add(date.year.toString());
    }

    listOfYear.addAll(tempListOfYear.toList());

    transactionCount.value = transactions.length;

    allTransactionList.value = transactions;

    applyFilter();
  }

  /// function to filtering the transaction data based on user input
  applyFilter() {

    /// set selected status to filterable string
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

    /// filter the transaction data
    filteredTransactionList.value = allTransactionList.where((element) {

      /// transaction data needs to all the three
      /// to return true in order to pass the filtering process
      bool returnStatus;
      bool returnMonth;
      bool returnYear;

      /// get current transaction date
      final transactionDate = (element.get("timestamp") as Timestamp).toDate();

      /// filtering the transaction status
      if (status == "") {
        returnStatus = true;
      } else {
        returnStatus = element.get("status") == status;
      }

      /// filtering the transaction month
      if (selectedMonth.value == "semua") {
        returnMonth = true;
      } else {
        returnMonth =
            transactionDate.month == listOfMonths.indexOf(selectedMonth.value);
      }

      /// filtering the transaction year
      if (selectedYear.value == "semua") {
        returnYear = true;
      } else {
        returnYear = transactionDate.year.toString() == selectedYear.value;
      }

      /// all three need to be true to pass the filtering
      return returnStatus && returnYear && returnMonth;

    }).toList();

    change(filteredTransactionList, status: RxStatus.success());
    
  }
}
