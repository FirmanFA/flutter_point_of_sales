import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:point_of_sales/presentation/report/report_controller.dart';
import 'package:point_of_sales/widget/default_app_bar.dart';

class ReportPage extends StatelessWidget {
  final List<QueryDocumentSnapshot> downloadedTransactionList;
  final String filterType;

  const ReportPage(
      {Key? key,
      required this.downloadedTransactionList,
      required this.filterType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportController());

    controller.generatePdfFile(downloadedTransactionList, filterType);

    return Obx(() => Scaffold(
          appBar: defaultAppBar("Unduh Laporan", actions: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                  onTap: () async {
                    final params = SaveFileDialogParams(
                        sourceFilePath: controller.pdfFile.value.path);
                    await FlutterFileDialog.saveFile(params: params);
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
