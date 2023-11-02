import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/constant/constant.dart';

class OrderedItemCard extends StatelessWidget {
  final int itemCount;
  final String itemName;
  final int itemPrice;
  final bool isEdit;
  final Function() onPlusClick;
  final Function() onMinusClick;

  const OrderedItemCard(
      {Key? key,
      required this.itemCount,
      required this.itemName,
      required this.itemPrice,
      this.isEdit = false,
      this.onPlusClick = _myDefaultFunc,
      this.onMinusClick = _myDefaultFunc})
      : super(key: key);

  static _myDefaultFunc() {}

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isEdit ? SizedBox.shrink() : Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: primaryColor, borderRadius: BorderRadius.circular(12)),
          child: Text(
            itemCount.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(
          width: 14,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              itemName,
              style: TextStyle(
                color: Color(0xFF2A3256),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              NumberFormat.simpleCurrency(
                      locale: "id", name: "Rp. ", decimalDigits: 0)
                  .format(itemPrice),
              style: TextStyle(
                color: Color(0xFF2A3256),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
        Spacer(),
        isEdit ?Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {

                onMinusClick.call();
              },
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0xFFE0E0E0),
                          width: 1)),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      FontAwesomeIcons.minus,
                      size: 18,
                      color: primaryColor,
                    ),
                  )),
            ),
            const SizedBox(
              width: 4,
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                  "$itemCount"),
            ),
            const SizedBox(
              width: 4,
            ),
            InkWell(
              onTap: () {
                onPlusClick.call();
              },
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0xFFE0E0E0),
                          width: 1)),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      FontAwesomeIcons.plus,
                      size: 18,
                      color: primaryColor,
                    ),
                  )),
            ),
          ],
        ): SizedBox.shrink()
      ],
    );
  }
}
