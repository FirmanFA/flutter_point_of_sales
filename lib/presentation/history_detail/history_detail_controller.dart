import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_of_sales/constant/constant.dart';

class HistoryDetailController extends GetxController {
  // DocumentSnapshot? detailOrderData;
  var detailOrderData = Rxn<DocumentSnapshot>();

  var selectedEditStatus = "".obs;

  final nameCon = TextEditingController();

  final paidAmountCon = TextEditingController();

  var change = 0.obs;

  var tempEditProduct = RxMap();

  var isLoading = true.obs;

  var editMode = false.obs;

  getOrderDetail(String orderId) async {
    isLoading.value = true;

    detailOrderData.value =
        await fDb.collection("/transactions").doc(orderId).get();

    tempEditProduct.value = detailOrderData.value?.get("products") ?? {};

    nameCon.text = detailOrderData.value?.get("name");

    selectedEditStatus.value = detailOrderData.value?.get("status");

    isLoading.value = false;
  }

  setEditMode(bool isEdit) {
    editMode.value = isEdit;
  }

  incrementProduct(String orderId) {
    final tempProductData = Map.of(tempEditProduct);

    tempProductData[orderId].update(
        'quantity', (value) => tempEditProduct[orderId]['quantity'] + 1);

    tempEditProduct.value = tempProductData;

    debugPrint("count ++ ${tempEditProduct[orderId]['quantity']}");
  }

  decrementOrDeleteProduct(String orderId) {
    final tempProductData = Map.of(tempEditProduct);

    if (tempEditProduct[orderId]['quantity'] != 0) {
      tempProductData[orderId].update(
          'quantity', (value) => tempProductData[orderId]['quantity'] - 1);
      debugPrint("count -- ${tempProductData[orderId]['quantity']}");

      tempEditProduct.value = tempProductData;
    }
  }

  updateTransaction(String orderId, Function() onSuccess) {
    num totalPrice = 0;

    //TODO - restore or decrease product stock for every product count change

    tempEditProduct.forEach((key, value) async {
      //TODO - add old quantity and new quantity, use its value for update increment

      final valueToIncreaseOrDecrease =
          detailOrderData.value?.get('products')[key]['quantity'] -
              value['quantity'];

      await fDb.collection("products").doc(key).update(
          {'product_stock': FieldValue.increment(valueToIncreaseOrDecrease)});
    });

    if (detailOrderData.value?.get("status") != "pending") {
      tempEditProduct.forEach((key, value) {
        totalPrice = totalPrice + (value['product_price'] * value['quantity']);
      });
    }

    tempEditProduct.removeWhere((key, value) {
      return value['quantity'] == 0;
    });

    fDb.collection('/transactions').doc(orderId).update({
      'name': nameCon.text,
      'order_id': detailOrderData.value?.get("order_id"),
      'products': tempEditProduct,
      'status': detailOrderData.value?.get("status"),
      'total_amount': totalPrice
    }).then((value) {
      onSuccess.call();
    });
  }

  updateTransactionStatus(String orderId, Function() onSuccess) {
    //TODO - detect if stock should increase or decrease based on old status and new status

    bool shouldStockIncrease = false;
    bool shouldUpdateStock = false;

    if (detailOrderData.value?.get("status") == "cancel") {
      if (selectedEditStatus.value != "cancel") {
        //TODO - stock is decreasing
        shouldStockIncrease = false;
        shouldUpdateStock = true;
      } else {
        shouldUpdateStock = false;
      }
    } else {
      if (selectedEditStatus.value == "cancel") {
        //TODO - stock is increasing
        shouldUpdateStock = true;
        shouldStockIncrease = true;
      } else {
        shouldUpdateStock = false;
      }
    }

    if (shouldUpdateStock) {
      tempEditProduct.forEach((key, value) async {
        await fDb.collection("products").doc(key).update({
          'product_stock': FieldValue.increment(
              value['quantity'] * (shouldStockIncrease ? 1 : -1))
        });
      });
    }

    fDb.collection('/transactions').doc(orderId).update({
      'status': selectedEditStatus.value,
    }).then((value) {
      onSuccess.call();
    });
  }

  deleteOrder(String orderId, Function() onSuccess) async {


    //TODO - if status is not cancel, restore pruduct stock

    if (detailOrderData.value?.get("status") != "cancel") {
      tempEditProduct.forEach((key, value) async {
        await fDb.collection("products").doc(key).update(
            {'product_stock': FieldValue.increment(value['quantity'])});
      });
    }

    await fDb.collection("/transactions").doc(orderId).delete().then((value) {
      onSuccess.call();
    });
  }

  setSelectedEditStatus(String status) {
    selectedEditStatus.value = status;
  }
}
