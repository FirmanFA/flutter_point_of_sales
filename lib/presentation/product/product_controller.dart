import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_of_sales/constant/constant.dart';
import 'package:point_of_sales/widget/text_input_widget.dart';

class ProductController extends GetxController
    with GetTickerProviderStateMixin {
  var selectedCategory = 0.obs;
  var selectedInputCategory = 0.obs;
  var categoryCount = 1.obs;

  var productCategoryList = [].obs;

  RxList<QueryDocumentSnapshot> rawProductCategoryList = RxList([]);

  RxList<QueryDocumentSnapshot> filteredProductList = RxList([]);
  RxList<QueryDocumentSnapshot> allProductList = RxList([]);
  var productCount = 0.obs;

  late TabController tabController;

  final searchCon = TextEditingController();

  final searchKeyWord = "".obs;

  final nameCon = TextEditingController();
  final priceCon = TextEditingController();
  final stockCon = TextEditingController();

  final inputCategoryCon = TextEditingController();

  @override
  onInit() {
    super.onInit();

    getProductCategories();
    getProducts();
  }

  refreshProducts() async {
    filteredProductList.value = await fDb.collection('products').get().then((query){

      List<QueryDocumentSnapshot> products = [];
      for (QueryDocumentSnapshot product in query.docs) {
        products.add(product);
      }

      allProductList.value = products;

      final filteredProductList = products.where((element) {
        final String productName = element.get("product_name").toLowerCase();
        final String productCategory = element.get("product_category");

        debugPrint("name $productName $productCategory");

        return productName.contains(searchCon.text.toLowerCase()) &&
            productCategory.contains(selectedCategory.value == 0
                ? ""
                : productCategoryList[selectedCategory.value]);
      }).toList();

      productCount.value = filteredProductList.length;

      return filteredProductList;

    });
  }

  getProducts() {
    filteredProductList.bindStream(
        fDb.collection('products').snapshots().map((QuerySnapshot query) {
      List<QueryDocumentSnapshot> products = [];
      for (QueryDocumentSnapshot product in query.docs) {
        products.add(product);
      }

      allProductList.value = products;

      final filteredProductList = products.where((element) {
        final String productName = element.get("product_name").toLowerCase();
        final String productCategory = element.get("product_category");

        debugPrint("name $productName $productCategory");

        return productName.contains(searchCon.text.toLowerCase()) &&
            productCategory.contains(selectedCategory.value == 0
                ? ""
                : productCategoryList[selectedCategory.value]);
      }).toList();

      productCount.value = filteredProductList.length;

      return filteredProductList;
    }));
  }

  getProductCategories() {
    productCategoryList.bindStream(fDb
        .collection('product_category')
        .orderBy("category")
        .snapshots()
        .map((QuerySnapshot query) {
      List productCategories = ["Semua Kategori"];
      rawProductCategoryList.clear();
      for (QueryDocumentSnapshot productCategory in query.docs) {
        productCategories.add(productCategory.get("category"));
        rawProductCategoryList.add(productCategory);
      }

      categoryCount.value = productCategories.length;
      tabController = TabController(length: categoryCount.value, vsync: this);
      return productCategories;
    }));
  }

  setSelectedCategory(int index) {
    selectedCategory.value = index;
  }

  setSelectedInputCategory(int index) {
    selectedInputCategory.value = index;
  }

  addProduct(
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

  editProduct(
      {required String id,
      required String name,
      required int price,
      required int stock,
      required String category}) async {
    fDb.collection("products").doc(id).set({
      'product_category': category,
      'product_name': name,
      'product_price': price,
      'product_stock': stock
    }).then((value) {
      Get.back();
      Get.snackbar("Success", "Product edited succesfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 44));
      nameCon.clear();
      priceCon.clear();
      stockCon.clear();
      setSelectedInputCategory(0);
      onInit();
    });
  }

  deleteProduct(QueryDocumentSnapshot data) async {
    Get.defaultDialog(
      title: "Konfirmasi",
      middleText: 'Ingin menghapus produk ini?',
      textCancel: "Batal",
      textConfirm: "Hapus",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        fDb.collection("products").doc(data.id).delete().then((value) {
          Get.snackbar("Success", "Product deleted succesfully",
              backgroundColor: Colors.green,
              colorText: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 44));
        });
      },
    );
  }

  addProductCategory() async {
    if (inputCategoryCon.text.isEmpty) {
      Get.snackbar("Error", "Input category name first",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 44));
    } else {
      fDb.collection("product_category").add({
        'category': inputCategoryCon.text,
      }).then((value) {
        Get.snackbar("Success", "Product category added succesfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 44));
        inputCategoryCon.clear();
      });
    }
  }

  editProductCategory(QueryDocumentSnapshot data) async {
    inputCategoryCon.text = data.get("category");

    Get.defaultDialog(
        title: "Update",
        textConfirm: "Ubah",
        confirmTextColor: Colors.white,
        onConfirm: () {
          if (inputCategoryCon.text.isEmpty) {
            Get.snackbar("Error", "Input category name first",
                backgroundColor: Colors.red,
                colorText: Colors.white,
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 44));
          } else {
            fDb
                .collection('products')
                .where("product_category", isEqualTo: data.get("category"))
                .get()
                .then((value) async {
              for (var element in value.docs) {
                final newData = element.data();

                newData['product_category'] = inputCategoryCon.text;

                await fDb.collection("products").doc(element.id).set(newData);
              }
              fDb
                  .collection("product_category")
                  .doc(data.id)
                  .set({'category': inputCategoryCon.text}).then((value) {
                Get.back();
                Get.snackbar("Success",
                    "Product category and its products updated succesfully",
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 44));
              });
            });
          }
        },
        contentPadding: EdgeInsets.all(12),
        content: CustomTextInput(
            label: "Kategori",
            hint: "Kategori baru",
            controller: inputCategoryCon));
  }

  deleteProductCategory(QueryDocumentSnapshot data) async {
    Get.defaultDialog(
      title: "Konfirmasi",
      middleText:
          'Ingin menghapus kategori beserta semua barang dengan kategori ini?',
      textCancel: "Hapus semua barang",
      textConfirm: "Hanya hapus kategori",
      confirmTextColor: Colors.white,
      onCancel: () {
        fDb
            .collection('products')
            .where("product_category", isEqualTo: data.get("category"))
            .get()
            .then((value) async {
          for (var element in value.docs) {
            await fDb.collection("products").doc(element.id).delete();
          }
          fDb
              .collection("product_category")
              .doc(data.id)
              .delete()
              .then((value) {
            setSelectedCategory(0);
            Get.snackbar("Success",
                "Product category and its products deleted succesfully",
                backgroundColor: Colors.green,
                colorText: Colors.white,
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 44));
          });
        });
      },
      onConfirm: () {
        setSelectedCategory(0);
        fDb.collection("product_category").doc(data.id).delete().then((value) {
          Get.back();
          Get.snackbar("Success", "Product category deleted succesfully",
              backgroundColor: Colors.green,
              colorText: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 44));
        });
      },
    );
  }
}
