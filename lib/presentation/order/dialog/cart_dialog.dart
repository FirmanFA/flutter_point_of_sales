import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/constant/constant.dart';
import 'package:point_of_sales/presentation/order/order_controller.dart';
import 'package:point_of_sales/presentation/product/product_controller.dart';

import '../../../widget/card/product_transaction_card.dart';

Future cartDialog(
    {required ProductController productController,
    required OrderController controller}) {
  return Get.bottomSheet(
      Obx(
        () => controller.selectedItemList.keys.isEmpty
            ? Container(
                height: Get.height / 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/empty_state.svg",height: Get.height/3,),
              SizedBox(height: 12,),
              Text("Add something to cart first",style: TextStyle(
                fontSize: 18,
                color: CupertinoColors.black,
                fontWeight: FontWeight.w600
              ),)
            ],
          ),
              )
            : Container(
                constraints: BoxConstraints(minHeight: Get.height / 2),
                child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      final productDetail = productController.allProductList
                          .firstWhere((element) =>
                              element.id ==
                              controller.selectedItemList.keys.toList()[index]);

                      return ProductTransactionCard(
                        name: productDetail.get("product_name"),
                        stock: productDetail.get("product_stock").toString(),
                        price: NumberFormat.simpleCurrency(
                                locale: "id", name: "Rp. ", decimalDigits: 0)
                            .format(productDetail.get("product_price")),
                        category: productDetail.get("product_category"),
                        id: productDetail.id,
                        data: productDetail,
                        onPlusClick: (data) {
                          final currentCount =
                              controller.getItemOrderCount(data.id);

                          if (currentCount == 0) {
                            controller.addToMenuCart(data.id);
                          } else {
                            controller.setCountMenuCartItem(
                                data.id,
                                currentCount == data.get("product_stock")
                                    ? currentCount
                                    : currentCount + 1);
                          }

                          debugPrint("produk ${controller.selectedItemList}");
                        },
                        onMinusClick: (data) {
                          final currentCount =
                              controller.getItemOrderCount(data.id);

                          if (currentCount == 1) {
                            controller.removeMenuCart(data.id);
                          } else {
                            controller.setCountMenuCartItem(
                                data.id,
                                currentCount == 0
                                    ? currentCount
                                    : currentCount - 1);
                          }
                        },
                        cartCount:
                            controller.getItemOrderCount(productDetail.id),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          height: 12,
                        ),
                    itemCount: controller.selectedItemList.keys.length),
              ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(12), topLeft: Radius.circular(12))),
      backgroundColor: CupertinoColors.white,
      isScrollControlled: true);
}
