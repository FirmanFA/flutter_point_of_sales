import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:point_of_sales/constant/constant.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String category;
  final String price;
  final String stock;
  final String id;

  const ProductCard(
      {Key? key,
      required this.name,
      required this.category,
      required this.price,
      required this.stock,
      required this.id})
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                name,
                style: TextStyle(
                  color: Color(0xFF121212),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
              const Spacer(),
              PopupMenuButton(
                onSelected: (value) async {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.solidPenToSquare,
                          color: Colors.blue,
                          size: 14,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text('Ubah'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.trash,
                          color: Colors.red,
                          size: 14,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text('Hapus'),
                      ],
                    ),
                  ),
                ],
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    FontAwesomeIcons.ellipsisVertical,
                    color: Colors.grey.shade400,
                    size: 18,
                  ),
                ),
              )
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
