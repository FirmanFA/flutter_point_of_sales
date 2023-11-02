import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:point_of_sales/constant/constant.dart';
import 'package:point_of_sales/widget/card/transaction_card.dart';
import 'package:point_of_sales/widget/default_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Color> gradientColors = [
    Colors.green,
    Colors.yellow,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar("Dashboard"),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Grafik Jumlah Transaksi Bulan Ini',
              style: TextStyle(
                color: Color(0xFF2A3256),
                fontSize: 16,
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(12)),
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
                      child: LineChart(
                        mainData(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 22,
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: Colors.yellow, shape: BoxShape.circle),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
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
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 22,
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
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
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 18,
            ),
            Text(
              'Transaksi Bulan Ini',
              style: TextStyle(
                color: Color(0xFF2A3256),
                fontSize: 16,
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
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
                          SizedBox(
                            height: 18,
                          ),
                          AutoSizeText(
                            'Rp. 10.000',
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.yellow.shade900,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
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
                          SizedBox(
                            height: 18,
                          ),
                          AutoSizeText(
                            '40',
                            style: TextStyle(
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
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
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
                          SizedBox(
                            height: 18,
                          ),
                          AutoSizeText(
                            '40',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
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
                                'Barang Terlaris',
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
                          SizedBox(
                            height: 18,
                          ),
                          AutoSizeText(
                            'Minyak Goreng Cap Tiga',
                            maxLines: 1,
                            style: TextStyle(
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
            SizedBox(
              height: 18,
            ),
            Row(
              children: [
                Text(
                  'Transaksi Terakhir',
                  style: TextStyle(
                    color: Color(0xFF2A3256),
                    fontSize: 16,
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
                Spacer(),
                OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Color(0xFF2A3256)),
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8)),
                    child: Row(
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
            SizedBox(
              height: 12,
            ),
            ListView.separated(
              shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  // return TransactionCard();
                  return Container();
                },
                separatorBuilder: (context, index) => SizedBox(
                      height: 12,
                    ),
                itemCount: 5),
            SizedBox(
              height: 32,
            )
          ],
        ),
      ),
    );
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
      return SizedBox.shrink();
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

    if (value.toInt().isEven) {
      text = "${value.toInt()}";
      return Text(text, style: style, textAlign: TextAlign.center);
    } else {
      return SizedBox.shrink();
    }
  }

  LineChartData mainData() {
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
      minX: 0,
      maxX: 31,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(1, 3),
            FlSpot(2, 2),
            FlSpot(3, 2),
            FlSpot(4, 5),
            FlSpot(5, 5),
            FlSpot(6, 3.1),
            FlSpot(7, 3.1),
            FlSpot(8, 4),
            FlSpot(9, 4),
            FlSpot(10, 3),
            FlSpot(11, 3),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
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
