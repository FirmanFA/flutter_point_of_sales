import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/constant/constant.dart';
import 'package:point_of_sales/presentation/main/main_controller.dart';
import 'package:point_of_sales/widget/card/transaction_card.dart';
import 'package:point_of_sales/widget/default_app_bar.dart';

import 'home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors = [
      Colors.green,
      Colors.yellow,
    ];

    final HomeController controller = Get.find();

    final MainController mainController = Get.find();

    controller.onInit();

    return Obx(() => Scaffold(
          appBar: defaultAppBar("Dashboard"),
          backgroundColor: Colors.white,
          body: controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
            onRefresh: () async {
              controller.getSmallestStockProduct();
              controller.getThisMonthTransactions();
              controller.getLatest5TransactionData();
            },
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Grafik Jumlah Transaksi Bulan Ini',
                          style: TextStyle(
                            color: Color(0xFF2A3256),
                            fontSize: 16,
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 1.70,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 12,
                                    left: 4,
                                    top: 24,
                                    bottom: 4,
                                  ),
                                  /// code to show the
                                  /// chart of this month transactions data
                                  child: LineChart(
                                    mainData(gradientColors,
                                        transactionCount: controller
                                            .maxTransactionCountThisMonth.value,
                                        formattedTransactionList: controller
                                            .formattedThisMonthTransaction),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 0,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    width: 22,
                                  ),
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                        color: Colors.yellow,
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  const Text(
                                    'Jumlah transaksi',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    width: 22,
                                  ),
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  const Text(
                                    'Tanggal',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const Text(
                          'Transaksi Bulan Ini',
                          style: TextStyle(
                            color: Color(0xFF2A3256),
                            fontSize: 16,
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.dollarSign,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          AutoSizeText(
                                            'Pendapatan',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'Rubik',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      AutoSizeText(
                                        /// show this month income total
                                        NumberFormat.simpleCurrency(
                                                locale: "id",
                                                name: "Rp. ",
                                                decimalDigits: 0)
                                            .format(controller.incomeTotal.value),
                                        maxLines: 1,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: Colors.yellow.shade900,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.fileLines,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          AutoSizeText(
                                            'Transaksi',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'Rubik',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      /// show this month transaction count
                                      AutoSizeText(
                                        controller.transactionCount.string,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.cartFlatbed,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: AutoSizeText(
                                              'Barang Terjual',
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'Rubik',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      AutoSizeText(
                                        /// show this month product sold
                                        controller.productSold.string,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              flex: 7,
                              child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.boxArchive,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          AutoSizeText(
                                            'Stock Menipis',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'Rubik',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      /// show product that need to restock
                                      AutoSizeText(
                                        controller.productWithSmallestStock.value
                                                ?.get("product_name") ??
                                            "Belum ada produk",
                                        maxLines: 1,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Transaksi Terakhir',
                              style: TextStyle(
                                color: Color(0xFF2A3256),
                                fontSize: 16,
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                            const Spacer(),
                            OutlinedButton(
                                onPressed: () {
                                  mainController.setNav(nav: 2);
                                },
                                style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    side: const BorderSide(color: Color(0xFF2A3256)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8)),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Lihat Semua',
                                      style: TextStyle(
                                        color: Color(0xFF2A3256),
                                        fontSize: 12,
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.arrowRight,
                                      size: 14,
                                      color: Color(0xFF2A3256),
                                    )
                                  ],
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        /// show latest 5 transaction data
                        ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return TransactionCard(
                                orderData:
                                    controller.latest5TransactionData[index],
                              );
                            },
                            separatorBuilder: (context, index) => const SizedBox(
                                  height: 12,
                                ),
                            itemCount: controller.latest5TransactionData.length),
                        const SizedBox(
                          height: 32,
                        )
                      ],
                    ),
                  ),
              ),
        ));
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.white,
      fontSize: 14,
    );
    String text;
    if (value.toInt() % 5 == 0) {
      text = "${value.toInt()}";
      return Text(text, style: style, textAlign: TextAlign.center);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.yellow,
      fontFamily: 'rubik',
      fontSize: 15,
    );
    String text;

    text = "${value.toInt()}";

    if(meta.max.toInt() > 10){
      if(value % 5 == 0){
        return Text(text, style: style, textAlign: TextAlign.center);
      }else{
        return SizedBox.shrink();
      }
    }else{
      return Text(text, style: style, textAlign: TextAlign.center);
    }

  }

  LineChartData mainData(List<Color> gradientColors,
      {required int transactionCount,
      required List<FlSpot> formattedTransactionList}) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
              color: Colors.white, strokeWidth: 1, dashArray: [5]);
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
              color: Colors.white, strokeWidth: 1, dashArray: [5]);
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.white),
      ),
      lineTouchData: LineTouchData(touchTooltipData: LineTouchTooltipData(
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((barSpot) {
            return LineTooltipItem(
                "Tanggal: ${barSpot.x.toStringAsFixed(0)}, Transaksi: ${barSpot.y.toStringAsFixed(0)}",
                const TextStyle(color: Colors.white));
          }).toList();
        },
      )),
      minX: 1,
      maxX: 31,
      minY: 0,
      maxY: transactionCount.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: formattedTransactionList,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          preventCurveOverShooting: true,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
