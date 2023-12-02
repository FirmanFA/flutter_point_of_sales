import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_of_sales/constant/constant.dart';

class HistoryDetailController extends GetxController {

  /// store detail transaction data
  var detailOrderData = Rxn<DocumentSnapshot>();

  /// store user selected status to edit, default is 0
  var selectedEditStatus = "".obs;

  /// controller for name input field
  final nameCon = TextEditingController();

  /// controller for paid amount input field
  final paidAmountCon = TextEditingController();

  /// store money change cashier should give
  var change = 0.obs;

  /// store temporary transaction's product data that has been edited
  var tempEditProduct = RxMap();

  var isLoading = true.obs;

  /// to store if current mode is edit mode or view only mode
  var editMode = false.obs;

  /// function to get transaction detail
  getOrderDetail(String orderId) async {

    /// set loading to true to show loading
    isLoading.value = true;

    /// get transaction detail from firebase
    detailOrderData.value =
        await fDb.collection("/transactions").doc(orderId).get();

    /// set the ordered product to temporary variable to edit
    tempEditProduct.value = detailOrderData.value?.get("products") ?? {};

    /// set buyer name
    nameCon.text = detailOrderData.value?.get("name");

    /// set selected edit status
    selectedEditStatus.value = detailOrderData.value?.get("status");

    /// finish loading
    isLoading.value = false;
  }

  /// function to set edit mode
  setEditMode(bool isEdit) {
    editMode.value = isEdit;
  }

  /// edit the quantity of ordered product by +1
  incrementProduct(String orderId) {

    final tempProductData = Map.of(tempEditProduct);

    /// update the ordered product data quantity
    tempProductData[orderId].update(
        'quantity', (value) => tempEditProduct[orderId]['quantity'] + 1);

    tempEditProduct.value = tempProductData;
  }

  /// edit the quantity of ordered product by -1
  decrementOrDeleteProduct(String orderId) {
    final tempProductData = Map.of(tempEditProduct);

    /// update the ordered product data quantity to -1 if not 0
    if (tempEditProduct[orderId]['quantity'] != 0) {
      tempProductData[orderId].update(
          'quantity', (value) => tempProductData[orderId]['quantity'] - 1);

      tempEditProduct.value = tempProductData;
    }
  }

  /// update transaction data to firebase
  updateTransaction(String orderId, Function() onSuccess) {
    num totalPrice = 0;

    /// loop through edited ordered product
    tempEditProduct.forEach((key, value) async {

      /// calculate the ordered product quantity difference
      /// from edited product and use the value to update
      /// quantity of product data
      /// if the difference is minus, then the stock should decrease
      /// if the difference is plus, then the stock should increase
      final valueToIncreaseOrDecrease =
          detailOrderData.value?.get('products')[key]['quantity'] -
              value['quantity'];

      /// update product quantity using value calculated before
      await fDb.collection("products").doc(key).update(
          {'product_stock': FieldValue.increment(valueToIncreaseOrDecrease)});
    });

    /// count new total price
    tempEditProduct.forEach((key, value) {
      totalPrice = totalPrice + (value['product_price'] * value['quantity']);
    });

    /// remove edited product that has 0 quantity
    tempEditProduct.removeWhere((key, value) {
      return value['quantity'] == 0;
    });

    /// update transaction data to firebase
    fDb.collection('/transactions').doc(orderId).update({
      'name': nameCon.text,
      'order_id': detailOrderData.value?.get("order_id"),
      'products': tempEditProduct,
      'status': detailOrderData.value?.get("status"),
      'total_amount': totalPrice
    }).then((value) {

      /// call a success function in view page
      onSuccess.call();
    });
  }

  /// update transaction status to firebase
  updateTransactionStatus(String orderId, Function() onSuccess) {

    /// detect if stock should increase or decrease
    /// based on old status and new status
    bool shouldStockIncrease = false;
    bool shouldUpdateStock = false;

    if (detailOrderData.value?.get("status") == "cancel") {

      if (selectedEditStatus.value != "cancel") {
        /// decrease stock if status is not cancel
        shouldStockIncrease = false;
        shouldUpdateStock = true;
      } else {
        shouldUpdateStock = false;
      }
    } else {
      /// update stock if new status is cancel
      if (selectedEditStatus.value == "cancel") {
        shouldUpdateStock = true;
        shouldStockIncrease = true;
      } else {
        shouldUpdateStock = false;
      }
    }

    /// update the product stock if the changed value should update stock
    /// for example, changing from cancel to pending need to update the stock
    if (shouldUpdateStock) {
      tempEditProduct.forEach((key, value) async {
        await fDb.collection("products").doc(key).update({
          'product_stock': FieldValue.increment(
              value['quantity'] * (shouldStockIncrease ? 1 : -1))
        });
      });
    }

    /// edit transaction status to firebase
    fDb.collection('/transactions').doc(orderId).update({
      'status': selectedEditStatus.value,
    }).catchError((err){
      debugPrint("something when wrong $err");
    }).then((value) {
      onSuccess.call();
    });
  }

  /// function to delete transaction from firebase
  deleteOrder(String orderId, Function() onSuccess) async {

    /// if status is not cancel, restore pruduct stock
    if (detailOrderData.value?.get("status") != "cancel") {
      tempEditProduct.forEach((key, value) async {
        await fDb.collection("products").doc(key).update(
            {'product_stock': FieldValue.increment(value['quantity'])});
      });
    }

    /// delete transaction data from firebase
    await fDb.collection("/transactions").doc(orderId).delete().then((value) {
      onSuccess.call();
    });
  }

  /// change selected status for edit
  setSelectedEditStatus(String status) {
    selectedEditStatus.value = status;
  }
}
