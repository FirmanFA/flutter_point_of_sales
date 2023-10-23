import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:point_of_sales/constant/constant.dart';

class ProductTransactionCard extends StatelessWidget {
  final String name;
  final String category;
  final String price;
  final String stock;
  final String id;
  final int cartCount;
  final QueryDocumentSnapshot data;
  final Function(QueryDocumentSnapshot) onPlusClick;
  final Function(QueryDocumentSnapshot) onMinusClick;

  const ProductTransactionCard(
      {Key? key,
      required this.name,
      required this.category,
      required this.price,
      required this.stock,
      required this.id,
      required this.onPlusClick,
      required this.onMinusClick,
      required this.data, required this.cartCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AutoSizeText(
                name,
                style: TextStyle(
                  color: Color(0xFF121212),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {

                  onMinusClick.call(data);
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
                    "$cartCount"),
              ),
              const SizedBox(
                width: 4,
              ),
              InkWell(
                onTap: () {
                  onPlusClick.call(data);
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
          ),
          const SizedBox(height: 20),
          AutoSizeText(
            'Jenis: $category',
            style: TextStyle(
              color: Color(0xFF121212),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AutoSizeText(
                price,
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
              const Spacer(),
              Text(
                'Stok Saat Ini',
                style: TextStyle(
                  color: Color(0xFF121212),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
              const SizedBox(width: 10),
              AutoSizeText(
                stock,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ],
      ),
    );
  }
}
