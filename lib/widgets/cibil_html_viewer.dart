import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:newsee/Utils/shared_preference_utils.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/auth/domain/model/user_details.dart';
import 'package:newsee/feature/cic_check/domain/modals/cibil_report_table_model.dart';
import 'package:newsee/feature/cic_check/domain/repository/cibilreports_crud_repo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CibilHtmlViewer extends StatefulWidget {
  final String? htmlFileBase64;
  final String? localFilePath;
  final String? propNo;
  final String? applicantType;
  final String? reportType;
  const CibilHtmlViewer({
    super.key,
    this.htmlFileBase64,
    this.localFilePath,
    this.propNo,
    this.applicantType,
    this.reportType,
  });

  @override
  State<CibilHtmlViewer> createState() => CibilHtmlViewerState();
}

class CibilHtmlViewerState extends State<CibilHtmlViewer> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller =
        WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);
    loadHtml();
  }

  Future<void> loadHtml() async {
    try {
      String htmlContent;

      if (widget.localFilePath != null &&
          await File(widget.localFilePath!).exists()) {
        // load from saved local file
        htmlContent = await File(widget.localFilePath!).readAsString();
      } else if (widget.htmlFileBase64 != null &&
          widget.htmlFileBase64!.isNotEmpty) {
        UserDetails? userDetails = await loadUser();
        // decode and save base64 html content
        htmlContent = utf8.decode(base64.decode(widget.htmlFileBase64!));

        final dir = await getApplicationDocumentsDirectory();
        final filePath =
            '${dir.path}/${widget.applicantType}${widget.reportType}_${widget.propNo}.html';
        final file = File(filePath);
        await file.writeAsString(htmlContent);

        print('cibil html saved at: $filePath');

        await savefilePathInTable({
          'userid': userDetails!.LPuserID,
          'proposalNo': widget.propNo,
          'applicantType': widget.applicantType,
          'reportType': widget.reportType,
          'filepath': filePath,
        });
      } else {
        throw Exception('No html data or file path provided.');
      }
      // load into WebView
      await controller.loadHtmlString(htmlContent);
    } catch (e) {
      print('error loading html: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load CIBIL report')));
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> savefilePathInTable(Map<String, dynamic> data) async {
    Database db = await DBConfig().database;
    CibilreportsCrudRepo cibilCrudRepo = CibilreportsCrudRepo(db);

    final model = CibilReportTableModel(
      userid: data['userid'],
      proposalNo: data['proposalNo'],
      applicantType: data['applicantType'],
      reportType: data['reportType'],
      filepath: data['filepath'],
    );

    await cibilCrudRepo.save(model);

    print('Report saved in DB successfully...');
    List<CibilReportTableModel> p = await cibilCrudRepo.getAll();
    print('cibilCrudRepo.getAll() => ${p.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CIBIL Report'),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
