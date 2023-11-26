import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/constant/constant.dart';
import 'package:point_of_sales/presentation/history/history_controller.dart';
import 'package:point_of_sales/utils/date_only_comparator.dart';
import 'package:point_of_sales/widget/card/transaction_card.dart';
import 'package:point_of_sales/widget/default_app_bar.dart';
import 'package:grouped_list/grouped_list.dart';

import '../report/report_page.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoryController controller = Get.find();

    controller.onInit();

    return Obx(() => Scaffold(
        appBar: defaultAppBar("Transaksi", actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
                onTap: () {
                  if(controller.filteredTransactionList.isEmpty){
                    Get.snackbar("Warning", "TIdak ada data untuk diunduh, coba gunakan filter lain");
                  }else{
                    Get.to(() => ReportPage(
                      downloadedTransactionList:
                      controller.filteredTransactionList,
                      filterType:
                      "${controller.selectedMonth.value == "semua" ? "Semua Bulan" : "Bulan ${GetUtils.capitalize(controller.selectedMonth.value)}"} "
                          "${controller.selectedYear.value == "semua" ? "Semua Tahun" : controller.selectedYear}",
                    ));
                  }
                },
                child: Icon(
                  FontAwesomeIcons.download,
                  size: 20,
                )),
          )
        ]),
        body: controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  TabBar(
                      indicatorColor: Colors.transparent,
                      controller: controller.tabController,
                      isScrollable: true,
                      labelPadding: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.only(left: 0),
                      tabs: [
                        Tab(
                            child: InkWell(
                          onTap: () {
                            controller.tabController.animateTo(0);
                            controller.setSelectedStatus(0);
                            controller.applyFilter();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: ShapeDecoration(
                              color: 0 == controller.selectedStatus.value
                                  ? CupertinoColors.activeBlue
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 0.50,
                                    color: 0 == controller.selectedStatus.value
                                        ? CupertinoColors.activeBlue
                                        : const Color(0xFFE0E0E0)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Semua",
                                style: TextStyle(
                                  color: 0 == controller.selectedStatus.value
                                      ? Colors.white
                                      : const Color(0xFF757575),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )),
                        Tab(
                            child: InkWell(
                          onTap: () {
                            controller.tabController.animateTo(1);
                            controller.setSelectedStatus(1);
                            controller.applyFilter();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: ShapeDecoration(
                              color: 1 == controller.selectedStatus.value
                                  ? Colors.green
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 0.50,
                                    color: 1 == controller.selectedStatus.value
                                        ? Colors.green
                                        : const Color(0xFFE0E0E0)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Paid",
                                style: TextStyle(
                                  color: 1 == controller.selectedStatus.value
                                      ? Colors.white
                                      : const Color(0xFF757575),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )),
                        Tab(
                            child: InkWell(
                          onTap: () {
                            controller.tabController.animateTo(2);
                            controller.setSelectedStatus(2);
                            controller.applyFilter();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: ShapeDecoration(
                              color: 2 == controller.selectedStatus.value
                                  ? Colors.yellow.shade700
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 0.50,
                                    color: 2 == controller.selectedStatus.value
                                        ? Colors.yellow.shade700
                                        : const Color(0xFFE0E0E0)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Pending",
                                style: TextStyle(
                                  color: 2 == controller.selectedStatus.value
                                      ? Colors.white
                                      : const Color(0xFF757575),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )),
                        Tab(
                            child: InkWell(
                          onTap: () {
                            controller.tabController.animateTo(3);
                            controller.setSelectedStatus(3);
                            controller.applyFilter();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: ShapeDecoration(
                              color: 3 == controller.selectedStatus.value
                                  ? Colors.red
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 0.50,
                                    color: 3 == controller.selectedStatus.value
                                        ? Colors.red
                                        : const Color(0xFFE0E0E0)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: 3 == controller.selectedStatus.value
                                      ? Colors.white
                                      : const Color(0xFF757575),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )),
                      ]),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: MaterialButton(
                      padding: EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: primaryColor, width: 1)),
                      onPressed: () {
                        Get.bottomSheet(
                          Obx(
                            () => IntrinsicHeight(
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Bulan",
                                            style: const TextStyle(
                                                color: primaryColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            width: double.infinity,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: ShapeDecoration(
                                              color: primaryColor,
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    width: 0.50,
                                                    color: Color(0xFFE0E0E0)),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: controller
                                                    .selectedMonth.value,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black87),
                                                isDense: true,
                                                iconEnabledColor: Colors.white,
                                                iconDisabledColor: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                onChanged: (value) {
                                                  controller.setSelectedMonth(
                                                      value ?? "semua");
                                                  controller.applyFilter();
                                                },
                                                selectedItemBuilder: (context) {
                                                  return controller.listOfMonths
                                                      .map<Text>(
                                                          (dynamic value) {
                                                    return Text(
                                                      toBeginningOfSentenceCase(
                                                              value) ??
                                                          value,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    );
                                                  }).toList();
                                                },
                                                items: controller.listOfMonths
                                                    .map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(
                                                      toBeginningOfSentenceCase(
                                                              value) ??
                                                          "",
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Tahun",
                                            style: const TextStyle(
                                                color: primaryColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            width: double.infinity,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: ShapeDecoration(
                                              color: primaryColor,
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    width: 0.50,
                                                    color: Color(0xFFE0E0E0)),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: controller
                                                    .selectedYear.value,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black87),
                                                isDense: true,
                                                iconEnabledColor: Colors.white,
                                                iconDisabledColor: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                onChanged: (value) {
                                                  controller.setSelectedYear(
                                                      value ?? "semua");
                                                  controller.applyFilter();
                                                },
                                                selectedItemBuilder: (context) {
                                                  return controller.listOfYear
                                                      .map<Text>(
                                                          (dynamic value) {
                                                    return Text(
                                                      toBeginningOfSentenceCase(
                                                              value) ??
                                                          value,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    );
                                                  }).toList();
                                                },
                                                items: controller.listOfYear
                                                    .map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(
                                                      toBeginningOfSentenceCase(
                                                              value) ??
                                                          "",
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12)),
                          ),
                          backgroundColor: Colors.white,
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.sliders,
                            color: primaryColor,
                            size: 18,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${controller.selectedMonth.value == "semua" ? "Semua Bulan" : "Bulan ${GetUtils.capitalize(controller.selectedMonth.value)}"} "
                            "${controller.selectedYear.value == "semua" ? "Semua Tahun" : controller.selectedYear}",
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        controller.getTransaction();
                      },
                      child: GroupedListView(
                        elements: controller.filteredTransactionList,
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                            bottom: 42, right: 12, top: 12, left: 12),
                        groupBy: (QueryDocumentSnapshot<Object?> element) {
                          return DateFormat("dd-MM-yyyy").parse(
                              DateFormat("dd-MM-yyyy")
                                  .format(element.get("timestamp").toDate()));
                        },
                        groupSeparatorBuilder: (value) {
                          num transactionAmountByDate = 0;

                          for (QueryDocumentSnapshot element
                              in controller.filteredTransactionList) {
                            if (element.get("status") == "paid") {
                              if ((element.get("timestamp") as Timestamp)
                                  .toDate()
                                  .isSameDate(value)) {
                                transactionAmountByDate =
                                    transactionAmountByDate +
                                        element.get("total_amount");
                              }
                            }
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Center(
                                child: Row(
                              children: [
                                Stack(
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      DateFormat("dd MMM yyyy").format(value),
                                      style: TextStyle(
                                        color: primaryColor,
                                      ),
                                    ),
                                    Positioned(
                                      top: 2,
                                      child: Text(
                                        DateFormat("dd MMM yyyy").format(value),
                                        style: TextStyle(
                                            color: Colors.transparent,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationThickness: 4,
                                            decorationColor: primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Text(
                                  NumberFormat.simpleCurrency(
                                          locale: "id",
                                          name: "Rp. ",
                                          decimalDigits: 0)
                                      .format(transactionAmountByDate),
                                  style: TextStyle(
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            )),
                          );
                        },
                        groupComparator: (value1, value2) {
                          return value1.isBefore(value2) ? 1 : -1;
                        },
                        itemBuilder: (context, element) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TransactionCard(
                              orderData: element,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )));
  }
}
