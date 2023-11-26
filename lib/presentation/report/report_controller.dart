import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:point_of_sales/utils/transaction_pdf_generator.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportController extends GetxController {
  var pdfFile = File("").obs;

  generatePdfFile(List<QueryDocumentSnapshot> downloadedTransactionList, String filterType) async {

    final List<Product> pdfProductList = [];


    for (var element in downloadedTransactionList) {
      final orderedProductMap = element.get('products') as Map;

      bool isFirst = true;

      orderedProductMap.forEach((key, value) {
        pdfProductList.add(Product(isFirst ? "#${element.get("order_id")}" :"", value['product_name'], double.parse("${value['product_price']}"), value['quantity']));
        isFirst = false;
      });


    }

    final invoice = Invoice(
      invoiceNumber: '',
      products: pdfProductList,
      customerName: '',
      customerAddress: '',
      paymentInfo: '',
      tax: 0,
      baseColor: PdfColor.fromInt(0xFF1A72DD),
      accentColor: PdfColors.blueGrey900, filterType: filterType,
    );

    final file = await generateTransactionsPdf(invoice: invoice);
    _setPdfFile(file);
  }

  _setPdfFile(File file) {
    pdfFile.value = file;
  }
}
