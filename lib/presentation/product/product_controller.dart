import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_of_sales/constant/constant.dart';
import 'package:point_of_sales/widget/text_input_widget.dart';

class ProductController extends GetxController
    with GetTickerProviderStateMixin {
  /// variable to store selected category by user for view data purpose
  /// 0 is the default value of all category
  var selectedCategory = 0.obs;

  /// variable to store selected category by user for input data purpose
  /// 0 is the default value of all category
  var selectedInputCategory = 0.obs;

  /// to store category count, default is 1 for 'all category'
  var categoryCount = 1.obs;

  /// list of string category default is empty
  var productCategoryList = [].obs;

  /// list of firebase data of list of category
  RxList<QueryDocumentSnapshot> rawProductCategoryList = RxList([]);

  /// list of firebase data of list of product
  /// that has been filtered by user input
  RxList<QueryDocumentSnapshot> filteredProductList = RxList([]);

  /// list of all product get from firebase
  RxList<QueryDocumentSnapshot> allProductList = RxList([]);

  /// product count
  var productCount = 0.obs;

  /// controller for search text field
  final searchCon = TextEditingController();

  /// search keyword for filtering
  final searchKeyWord = "".obs;

  /// controller for input name
  final nameCon = TextEditingController();

  /// controller for input price
  final priceCon = TextEditingController();

  /// controller for input stock
  final stockCon = TextEditingController();

  /// controller for input category
  final inputCategoryCon = TextEditingController();

  @override
  onInit() {
    super.onInit();

    getProductCategories();
    getProducts();
  }

  /// function to refresh product data for every change in firebase
  refreshProducts() async {
    /// refer to getProducts() function
    /// for more detail since it is the same logic
    filteredProductList.value =
        await fDb.collection('products').get().then((query) {
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

  /// function to get products
  getProducts() {
    /// set the filtered product to a stream data so the data
    /// could change in real time
    filteredProductList.bindStream(

        /// get 'products' collection from firebase
        fDb.collection('products').snapshots().map((QuerySnapshot query) {
      List<QueryDocumentSnapshot> products = [];
      for (QueryDocumentSnapshot product in query.docs) {
        products.add(product);
      }

      /// set all product list from the data got before
      allProductList.value = products;

      /// filter the product data based on user filter input
      /// where function can filter a list based on condition,
      /// return false to skip a data, true otherwise
      final filteredProductList = products.where((element) {
        final String productName = element.get("product_name").toLowerCase();
        final String productCategory = element.get("product_category");

        /// return true if the product match the search keyword,
        /// and match the selected category, false otherwise
        return productName.contains(searchCon.text.toLowerCase()) &&
            productCategory.contains(selectedCategory.value == 0
                ? ""
                : productCategoryList[selectedCategory.value]);
      }).toList();

      /// set product count from filtered product length
      productCount.value = filteredProductList.length;

      return filteredProductList;
    }));
  }

  /// function to get product categories from firebase
  getProductCategories() {
    /// set the productCategoryList to a stream data so the data
    /// could change in real time
    productCategoryList.bindStream(

        /// get 'product_category' collection from firebase order by name
        fDb
            .collection('product_category')
            .orderBy("category")
            .snapshots()
            .map((QuerySnapshot query) {
      /// add a default category as the first category
      List productCategories = ["Semua Kategori"];

      /// loop through query got from
      /// before and add the data to productCategories
      rawProductCategoryList.clear();
      for (QueryDocumentSnapshot productCategory in query.docs) {
        productCategories.add(productCategory.get("category"));
        rawProductCategoryList.add(productCategory);
      }

      /// set the category count
      categoryCount.value = productCategories.length;

      return productCategories;
    }));
  }

  /// function change the selected category
  setSelectedCategory(int index) {
    selectedCategory.value = index;
  }

  /// function change the selected category for input data
  setSelectedInputCategory(int index) {
    selectedInputCategory.value = index;
  }

  /// function to add new product to firebase
  addProduct(
      {required String name,
      required int price,
      required int stock,
      required String category}) async {
    /// add product data to firebase
    fDb.collection("products").add({
      'product_category': category,
      'product_name': name,
      'product_price': price,
      'product_stock': stock
    }).then((value) {
      /// when done, show a success message and reset input field
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

  /// function to edit a product
  editProduct(
      {required String id,
      required String name,
      required int price,
      required int stock,
      required String category}) async {
    /// [set] edit the product from firebase
    fDb.collection("products").doc(id).set({
      'product_category': category,
      'product_name': name,
      'product_price': price,
      'product_stock': stock
    }).then((value) {
      /// when done, show a success message and reset input field
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

  /// function to delete produdct from firebase
  deleteProduct(QueryDocumentSnapshot data) async {
    /// show a confirmation dialog to
    /// make sure user want to delete the data
    Get.defaultDialog(
      title: "Konfirmasi",
      middleText: 'Ingin menghapus produk ini?',
      textCancel: "Batal",
      textConfirm: "Hapus",
      confirmTextColor: Colors.white,

      /// when user confirm the deletion
      onConfirm: () {
        Get.back();

        /// delete product from firebase
        fDb.collection("products").doc(data.id).delete().then((value) {
          /// when done, show a success message
          Get.snackbar("Success", "Product deleted succesfully",
              backgroundColor: Colors.green,
              colorText: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 44));
        });
      },
    );
  }

  /// function to add new category to firebase
  addProductCategory() async {
    /// validation to make sure the field is not empty
    if (inputCategoryCon.text.isEmpty) {
      Get.snackbar("Error", "Input category name first",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 44));
    } else {
      /// add category to 'product_category' collection
      fDb.collection("product_category").add({
        'category': inputCategoryCon.text,
      }).then((value) {
        /// when done, show a success message and reset input field
        Get.snackbar("Success", "Product category added succesfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 44));
        inputCategoryCon.clear();
      });
    }
  }

  /// function to edit product category
  editProductCategory(QueryDocumentSnapshot data) async {
    inputCategoryCon.text = data.get("category");

    /// show a dialog to set a new category
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
            /// edit product category from firebase
            fDb
                .collection('products')
                .where("product_category", isEqualTo: data.get("category"))
                .get()
                .then((value) async {

              /// update all the product with edited category to new category
              for (var element in value.docs) {
                final newData = element.data();

                newData['product_category'] = inputCategoryCon.text;

                await fDb.collection("products").doc(element.id).set(newData);
              }
              fDb
                  .collection("product_category")
                  .doc(data.id)
                  .set({'category': inputCategoryCon.text}).then((value) {

                /// when done, show a success message
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

  /// function to delete a product category from firebase
  deleteProductCategory(QueryDocumentSnapshot data) async {

    /// show a confirmation dialog to
    /// delete only the category, or with its product
    Get.defaultDialog(
      title: "Konfirmasi",
      middleText:
          'Ingin menghapus kategori beserta semua barang dengan kategori ini?',
      textCancel: "Hapus semua barang",
      textConfirm: "Hanya hapus kategori",
      confirmTextColor: Colors.white,
      /// if the user select to delete with the product
      onCancel: () {

        /// get product with soon to delete category and delete them
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

            /// show a success message when done
            Get.snackbar("Success",
                "Product category and its products deleted succesfully",
                backgroundColor: Colors.green,
                colorText: Colors.white,
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 44));
          });
        });
      },
      /// if user select to delete category only
      onConfirm: () {
        setSelectedCategory(0);

        /// delete category from firebase
        fDb.collection("product_category").doc(data.id).delete().then((value) {
          Get.back();

          ///when done, show a success message
          Get.snackbar("Success", "Product category deleted succesfully",
              backgroundColor: Colors.green,
              colorText: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 44));
        });
      },
    );
  }
}
