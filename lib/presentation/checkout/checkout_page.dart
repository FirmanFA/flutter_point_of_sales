import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:point_of_sales/constant/constant.dart';
import 'package:point_of_sales/widget/card/ordered_item_card.dart';
import 'package:point_of_sales/widget/default_app_bar.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar("Detail Order", hasBack: true,actions: [
        PopupMenuButton(
          onSelected: (value) async {

          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 2,
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.ban,
                    color: Colors.red,
                    size: 18,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text('Batalkan Pesanan'),
                ],
              ),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              FontAwesomeIcons.ellipsisVertical,
              color: primaryColor,
              size: 18,
            ),
          ),
        )
      ]),
      body: ListView.separated(
          padding: EdgeInsets.all(12),
          itemBuilder: (context, index) {
            return OrderedItemCard();
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 24,
              thickness: 1,
              color: Colors.grey.shade200,
            );
          },
          itemCount: 5),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    color: Color(0xFF2A3256),
                    fontSize: 16,
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
                Spacer(),
                AutoSizeText(
                  'Rp 15.0000',
                  style: TextStyle(
                    color: Color(0xFF2A3256),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: MaterialButton(
                  onPressed: () {},
                  padding: EdgeInsets.all(12),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: primaryColor, width: 1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    'Bayar Nanti',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                )),
                SizedBox(width: 12,),
                Expanded(
                    child: MaterialButton(
                      onPressed: () {},
                      padding: EdgeInsets.all(12),
                      color:primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        'Bayar Sekarang',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
