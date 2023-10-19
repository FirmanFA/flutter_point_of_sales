import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_of_sales/constant/constant.dart';

class ProductController extends GetxController
    with GetTickerProviderStateMixin {
  var selectedCategory = 0.obs;
  var selectedInputCategory = 0.obs;
  var categoryCount = 1.obs;

  var productCategoryList = [].obs;

  RxList<QueryDocumentSnapshot> productList = RxList([]);
  var productCount = 0.obs;

  late TabController tabController;

  final searchCon = TextEditingController();
  final nameCon = TextEditingController();
  final priceCon = TextEditingController();
  final stockCon = TextEditingController();

  @override
  onInit() {
    super.onInit();
    productCategoryList.bindStream(fDb
        .collection('product_category')
        .snapshots()
        .map((QuerySnapshot query) {
      List productCategories = ["Semua Kategori"];
      for (QueryDocumentSnapshot productCategory in query.docs) {
        productCategories.add(productCategory.get("category"));
      }
      categoryCount.value = productCategories.length;
      tabController = TabController(length: categoryCount.value, vsync: this);
      return productCategories;
    }));

    productList.bindStream(fDb
        .collection('products')
        .snapshots()
        .map((QuerySnapshot query) {
      List<QueryDocumentSnapshot> products = [];
      for (QueryDocumentSnapshot product in query.docs) {
        products.add(product);
      }
      productCount.value = products.length;
      return products;
    }));
  }

  setSelectedCategory(int index) {
    selectedCategory.value = index;
  }

  setSelectedInputCategory(int index) {
    selectedInputCategory.value = index;
  }

  addProduct (
      {required String name,
      required int price,
      required int stock,
      required String category}) async {
    fDb.collection("products").add({
      'product_category': category,
      'product_name': name,
      'product_price': price,
      'product_stock': stock
    }).then((value) {
      Get.back();
      Get.snackbar("Success", "Product added succesfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 44));
      nameCon.clear();
      priceCon.clear();
      stockCon.clear();
      setSelectedInputCategory(0);
    });
  }
}
