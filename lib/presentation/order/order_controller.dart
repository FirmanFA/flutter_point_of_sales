import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  var totalPrice = 0.obs;

  var selectedItemList = {}.obs;

  var selectedItemCount = 0.obs;

  int getItemOrderCount(String id) {
    return selectedItemList[id] ?? 0;
  }

  int countTotalPrice(List<QueryDocumentSnapshot> allProduct) {
    num tempTotalPrice = 0;

    final containedProductData = allProduct
        .where((element) => selectedItemList.containsKey(element.id))
        .toList();

    for (QueryDocumentSnapshot element in containedProductData) {
      tempTotalPrice +=
          element.get("product_price") * selectedItemList[element.id];
    }

    return tempTotalPrice.toInt();
  }

  addToMenuCart(String id) {
    selectedItemList[id] = 1;
  }

  setSelectedItemCount(int count) {
    selectedItemCount.value = count;
  }

  setTotalPrice(int newTotalPrice) {
    totalPrice.value = newTotalPrice;
  }

  setCountMenuCartItem(String id, int count) {
    selectedItemList.update(id, (value) => count);
  }

  removeMenuCart(String id) {
    selectedItemList.remove(id);
  }
}
