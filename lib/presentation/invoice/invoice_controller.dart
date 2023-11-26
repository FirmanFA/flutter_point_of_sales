import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:point_of_sales/utils/transaction_pdf_generator.dart';

class InvoiceController extends GetxController {
  var pdfFile = File("").obs;

  generatePdfFile(DocumentSnapshot transactionData) async {
    final List<Product> pdfProductList = [];

    transactionData.get("products").forEach((key, value) {
      pdfProductList.add(Product("", value['product_name'],
          double.parse("${value['product_price']}"), value['quantity']));
    });

    final invoice = Invoice(
      invoiceNumber: "INV//#${transactionData.get("order_id")}",
      products: pdfProductList,
      customerName: transactionData.get("name"),
      transactionDate: DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
          .format((transactionData.get("timestamp") as Timestamp).toDate()),
      customerAddress: '',
      paymentInfo: transactionData.get("status"),
      tax: 0,
      baseColor: PdfColor.fromInt(0xFF1A72DD),
      accentColor: PdfColors.blueGrey900,
      filterType: "",
    );

    final file = await generateInvoicePdf(invoice: invoice);
    _setPdfFile(file);
  }

  _setPdfFile(File file) {
    pdfFile.value = file;
  }
}
