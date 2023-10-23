import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sales/constant/constant.dart';

class OrderedItemCard extends StatelessWidget {
  const OrderedItemCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(12)
          ),
          child: Text(
            '5',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(width: 14,),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wagyu Black Paper',
              style: TextStyle(
                color: Color(0xFF2A3256),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 8,),
            Text(
              'Rp. 10.00000',
              style: TextStyle(
                color: Color(0xFF2A3256),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        )

      ],
    );
  }
}
