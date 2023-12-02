import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {

  /// store total price buyer need to pay
  var totalPrice = 0.obs;

  /// store buyer ordered products
  var selectedItemList = {}.obs;

  /// store buyer ordered product count
  var selectedItemCount = 0.obs;

  /// function to get ordered product count
  int getItemOrderCount(String id) {
    return selectedItemList[id] ?? 0;
  }

  /// function to count total price buyer should pay
  int countTotalPrice(List<QueryDocumentSnapshot> allProduct) {

    num tempTotalPrice = 0;

    /// get all product that user bought
    final containedProductData = allProduct
        .where((element) => selectedItemList.containsKey(element.id))
        .toList();

    /// count the price for all the buyer bought
    for (QueryDocumentSnapshot element in containedProductData) {
      tempTotalPrice +=
          element.get("product_price") * selectedItemList[element.id];
    }

    return tempTotalPrice.toInt();
  }

  /// function to add a product to selectedItemList
  addToMenuCart(String id) {
    selectedItemList[id] = 1;
  }

  /// function to set selectedItemCount value
  setSelectedItemCount(int count) {
    selectedItemCount.value = count;
  }

  /// function to set totalPrice value
  setTotalPrice(int newTotalPrice) {
    totalPrice.value = newTotalPrice;
  }

  /// function to update ordered product quantity
  setCountMenuCartItem(String id, int count) {
    selectedItemList.update(id, (value) => count);
  }

  /// function to remove product from ordered product
  removeMenuCart(String id) {
    selectedItemList.remove(id);
  }
}
