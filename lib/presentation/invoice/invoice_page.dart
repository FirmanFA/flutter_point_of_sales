import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:point_of_sales/presentation/invoice/invoice_controller.dart';

import '../../widget/default_app_bar.dart';

class InvoicePage extends StatelessWidget {
  final DocumentSnapshot transactionData;

  const InvoicePage({Key? key, required this.transactionData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InvoiceController());

    controller.generatePdfFile(transactionData);

    return Obx(() =>
        Scaffold(
          appBar: defaultAppBar("Unduh Invoice", actions: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                  onTap: () async {
                    final params = SaveFileDialogParams(
                        sourceFilePath: controller.pdfFile.value.path);
                    await FlutterFileDialog.saveFile(params: params).then((
                        value) {
                      if (value != null) {
                        Get.snackbar("Success", "File downloaded successfully",
                            backgroundColor: Colors.green, colorText: Colors
                                .white);
                      }
                    });
                  },
                  child: Icon(
                    FontAwesomeIcons.download,
                    size: 20,
                  )),
            )
          ]),
          body: controller.pdfFile.value.path == ""
              ? Center(
            child: CircularProgressIndicator(),
          )
              : PDFView(
            filePath: controller.pdfFile.value.path,
            enableSwipe: true,
            autoSpacing: false,
            pageFling: false,
            onRender: (pages) {
              debugPrint("rendering");
            },
            onError: (error) {
              debugPrint("error ${error.toString()}");
            },
            onPageError: (page, error) {
              debugPrint('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              debugPrint("view created");
            },
            // onPageChanged: (int page, int total) {
            //   // print('page change: $page/$total');
            // },
          ),
        ));
  }
}
