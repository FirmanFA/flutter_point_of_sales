import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/constant/constant.dart';
import 'package:point_of_sales/presentation/product/product_controller.dart';

import '../../../widget/text_input_widget.dart';

Future inputProductDialog(
    {required ProductController controller,
    bool isEdit = false,
    String id = ""}) {
  return Get.bottomSheet(
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12))),
    Obx(() => SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                height: 18,
              ),

              Text(
                "Tambah Barang",
                style: TextStyle(
                  color: Color(0xFF2A3256),
                  fontSize: 16,
                  letterSpacing: 0.4,
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(
                height: 18,
              ),

              Text(
                "Kategori Barang",
                style: TextStyle(
                  color: Color(0xFF2A3256),
                  fontSize: 16,
                  letterSpacing: 0.4,
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          width: 0.50, color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: controller.selectedInputCategory.value,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87),
                      isDense: true,
                      // iconEnabledColor: Colors.white,
                      // iconDisabledColor: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      onChanged: (value) {
                        controller.setSelectedInputCategory(value ?? 0);
                      },
                      items: controller.rawProductCategoryList
                          .map<DropdownMenuItem<int>>((dynamic value) {
                        return DropdownMenuItem<int>(
                          value:
                              controller.rawProductCategoryList.indexOf(value),
                          child: Text(
                            toBeginningOfSentenceCase(value.get("category")) ??
                                "",
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextInput(
                  label: "Nama Barang",
                  hint: "Masukkan nama barang",
                  controller: controller.nameCon),
              SizedBox(
                height: 10,
              ),
              CustomTextInput(
                  label: "Harga Barang",
                  inputType: TextInputType.number,
                  hint: "Masukkan harga barang",
                  controller: controller.priceCon),
              SizedBox(
                height: 10,
              ),
              CustomTextInput(
                  label: "Stok",
                  hint: "Masukkan stok barang",
                  inputType: TextInputType.number,
                  controller: controller.stockCon),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: Get.width,
                child: MaterialButton(
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Text(isEdit ? "Ubah" : "Tambah", style: TextStyle(color: Colors.white, fontSize: 16),),
                  onPressed: () async {
                    if (controller.nameCon.text.isNotEmpty &&
                        controller.priceCon.text.isNotEmpty &&
                        controller.stockCon.text.isNotEmpty) {
                      if (isEdit) {
                        controller.editProduct(
                            id: id,
                            name: controller.nameCon.text,
                            price: int.parse(controller.priceCon.text),
                            stock: int.parse(controller.stockCon.text),
                            category: controller.rawProductCategoryList[
                                    controller.selectedInputCategory.value]
                                .get("category"));
                      } else {
                        await controller.addProduct(
                            name: controller.nameCon.text,
                            price: int.parse(controller.priceCon.text),
                            stock: int.parse(controller.stockCon.text),
                            category: controller.rawProductCategoryList[
                                    controller.selectedInputCategory.value]
                                .get("category"));
                      }

                      Get.focusScope?.unfocus();
                    } else {
                      Get.snackbar("Waring", "All field must be filled",
                          colorText: Colors.white,
                          backgroundColor: Colors.deepOrange,
                          snackPosition: SnackPosition.BOTTOM,
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 44));
                    }
                  },
                ),
              )
            ],
          ),
        )),
  );
}
