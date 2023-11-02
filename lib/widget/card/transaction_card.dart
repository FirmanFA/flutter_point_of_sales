import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/presentation/history_detail/history_detail_page.dart';
import 'package:point_of_sales/widget/card/animated_card_container.dart';

class TransactionCard extends StatelessWidget {
  final QueryDocumentSnapshot orderData;

  const TransactionCard({Key? key, required this.orderData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final time = orderData.get("timestamp") as Timestamp;

    return AnimatedCardContainer(
      onTap: () {
        Get.to(() => HistoryDetailPage(
              orderId: orderData.id,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${orderData.get("order_id")}',
                  style: TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                const Spacer(),
                Text(
                  "${DateFormat("dd MMM yyyy, hh:mm").format(time.toDate())}",
                  style: TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jumlah Barang',
                      style: TextStyle(
                        color: Color(0xFF121212),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      orderData.get("products").keys.length.toString(),
                      style: TextStyle(
                        color: Color(0xFF121212),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      NumberFormat.simpleCurrency(
                              locale: "id", name: "Rp. ", decimalDigits: 0)
                          .format(orderData.get("total_amount")),
                      style: TextStyle(
                        color: Color(0xFF121212),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      decoration: ShapeDecoration(
                        color: orderData.get("status") == 'paid'
                            ? Color(0xFF35CD1D)
                            : orderData.get("status") == 'pending'
                                ? Colors.yellow.shade700
                                : Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            GetUtils.capitalize(
                                    orderData.get("status").toString()) ??
                                "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
