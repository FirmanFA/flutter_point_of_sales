
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

Future<File> generateTransactionsPdf({required Invoice invoice}) async {



  final pdfFile = await invoice.buildPdf();

  final String dir = (await getTemporaryDirectory()).path;
  final String path = '$dir/laporan.pdf';
  final File file = File(path);
  return await file.writeAsBytes(pdfFile);
}

Future<File> generateInvoicePdf({required Invoice invoice}) async {

  final pdfFile = await invoice.buildInvoicePdf();

  final String dir = (await getTemporaryDirectory()).path;
  final String path = '$dir/laporan.pdf';
  final File file = File(path);
  return await file.writeAsBytes(pdfFile);

}

class Invoice {
  Invoice({
    required this.products,
    required this.customerName,
    required this.customerAddress,
    required this.invoiceNumber,
    required this.filterType,
    required this.tax,
    this.transactionDate = "",
    required this.paymentInfo,
    required this.baseColor,
    required this.accentColor,
  });

  final List<Product> products;
  final String customerName;
  final String customerAddress;
  final String invoiceNumber;
  final String filterType;
  final double tax;
  final String transactionDate;
  final String paymentInfo;
  final PdfColor baseColor;
  final PdfColor accentColor;

  static const _darkColor = PdfColors.blueGrey800;
  static const _lightColor = PdfColors.white;

  PdfColor get _baseTextColor => baseColor.isLight ? _lightColor : _darkColor;

  PdfColor get _accentTextColor => baseColor.isLight ? _lightColor : _darkColor;

  double get _total =>
      products.map<double>((p) => p.total).reduce((a, b) => a + b);

  double get _grandTotal => _total * (1 + tax);

  String? _logo;

  String? _bgShape;

  Future<Uint8List> buildPdf() async {
    // Create a PDF document.
    final doc = pw.Document();

    _logo = await rootBundle.loadString('assets/login_image.svg');
    _bgShape = await rootBundle.loadString('assets/login_image.svg');

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          PdfPageFormat.a4,
          Font.ttf(await rootBundle.load("assets/google_fonts/Poppins-Regular.ttf")),
          Font.ttf(await rootBundle.load("assets/google_fonts/Poppins-Bold.ttf")),
          Font.ttf(await rootBundle.load("assets/google_fonts/Poppins-Regular.ttf")),
        ),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          _contentHeader(context),
          _contentTable(context),
          pw.SizedBox(height: 20),
          _contentFooter(context),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  Future<Uint8List> buildInvoicePdf() async {
    // Create a PDF document.
    final doc = pw.Document();

    _logo = await rootBundle.loadString('assets/login_image.svg');
    _bgShape = await rootBundle.loadString('assets/login_image.svg');

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          PdfPageFormat.a4,
          Font.ttf(await rootBundle.load("assets/google_fonts/Poppins-Regular.ttf")),
          Font.ttf(await rootBundle.load("assets/google_fonts/Poppins-Bold.ttf")),
          Font.ttf(await rootBundle.load("assets/google_fonts/Poppins-Regular.ttf")),
        ),
        header: _buildInvoiceHeader,
        footer: _buildFooter,
        build: (context) => [
          _contentHeader(context,isInvoice: true),
          _contentTable(context),
          pw.SizedBox(height: 20),
          _contentFooter(context),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    height: 50,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'Laporan Transaksi',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  pw.Container(
                    height: 50,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      filterType,
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _buildInvoiceHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 4,
              child: pw.Column(
                children: [
                  pw.Container(
                    height: 50,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(2)),
                      color: baseColor,
                    ),
                    padding: const pw.EdgeInsets.only(
                        left: 12, top: 12, bottom: 12, right: 12),
                    alignment: pw.Alignment.centerLeft,
                    // height: 70,
                    child: pw.DefaultTextStyle(
                      style: pw.TextStyle(
                        color: _accentTextColor,
                        fontSize: 12,
                      ),
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('Invoice #'),
                                pw.Text('Date:'),
                                pw.Text('Name:'),
                                pw.Text('Status:'),
                              ],
                            ),
                          ),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(invoiceNumber),
                              pw.Text(transactionDate),
                              pw.Text(customerName),
                              pw.Text(paymentInfo),
                            ],
                          ),
                        ]
                      )
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              flex: 4,
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    alignment: pw.Alignment.topRight,
                    padding: const pw.EdgeInsets.only(bottom: 8, left: 30),
                    height: 72,
                    child:
                    _logo != null ? pw.SvgImage(svg: _logo!) : pw.PdfLogo(),
                  ),
                  // pw.Container(
                  //   color: baseColor,
                  //   padding: pw.EdgeInsets.only(top: 3),
                  // ),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.white,
          ),
        ),
      ],
    );
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
      // buildBackground: (context) => pw.FullPage(
      //   ignoreMargins: true,
      //   child: pw.SvgImage(svg: _bgShape!),
      // ),
    );
  }

  pw.Widget _contentHeader(pw.Context context,{bool isInvoice = false}) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // pw.Expanded(
        //   child: pw.Container(
        //     margin: const pw.EdgeInsets.symmetric(horizontal: 20),
        //     height: 70,
        //     child: pw.Text(
        //       'Pendapatan: \n${_formatCurrency(_grandTotal)}',
        //       style: pw.TextStyle(
        //         color: baseColor,
        //         fontSize: 22,
        //         fontStyle: pw.FontStyle.italic,
        //       ),
        //     ),
        //   ),
        // ),
        pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _contentFooter(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.DefaultTextStyle(
            style: const pw.TextStyle(
              fontSize: 10,
              color: _darkColor,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [

                pw.Divider(color: accentColor),
                pw.DefaultTextStyle(
                  style: pw.TextStyle(
                    color: baseColor,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total:'),
                      pw.Text(_formatCurrency(_grandTotal)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _termsAndConditions(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border(top: pw.BorderSide(color: accentColor)),
                ),
                padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
                child: pw.Text(
                  'Terms & Conditions',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: baseColor,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                pw.LoremText().paragraph(40),
                textAlign: pw.TextAlign.justify,
                style: const pw.TextStyle(
                  fontSize: 6,
                  lineSpacing: 2,
                  color: _darkColor,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.SizedBox(),
        ),
      ],
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'Order Id',
      'Nama Produk',
      'Harga',
      'Jumlah',
      'Sub Total'
    ];

    return pw.TableHelper.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.centerRight,
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: accentColor,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
            (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        products.length,
            (row) => List<String>.generate(
          tableHeaders.length,
              (col) => products[row].getIndex(col),
        ),
      ),
    );
  }
}

String _formatCurrency(double amount) {
  return NumberFormat.simpleCurrency(
      locale: "id", name: "Rp. ", decimalDigits: 0)
      .format(amount);
}

String _formatDate(DateTime date) {
  final format = DateFormat.yMMMd('en_US');
  return format.format(date);
}

class Product {
  const Product(
      this.sku,
      this.productName,
      this.price,
      this.quantity,
      );

  final String sku;
  final String productName;
  final double price;
  final int quantity;
  double get total => price * quantity;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return sku;
      case 1:
        return productName;
      case 2:
        return _formatCurrency(price);
      case 3:
        return quantity.toString();
      case 4:
        return _formatCurrency(total);
    }
    return '';
  }
}
