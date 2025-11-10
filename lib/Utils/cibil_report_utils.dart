import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Utils/shared_preference_utils.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/auth/domain/model/user_details.dart';
import 'package:newsee/feature/cic_check/domain/repository/cibilreports_crud_repo.dart';
import 'package:newsee/feature/cic_check/presentation/bloc/cic_check_bloc.dart';
import 'package:newsee/widgets/cibil_html_viewer.dart';
import 'package:newsee/widgets/sysmo_alert.dart';

/*
  @author     : Lathamani 04/11/2025
  @desc       : On the first click of view report (when CIBIL is being checked for the first time), the base64 data is passed to the CIBIL report HTML view page.
                When returning to the page later (after the CIBIL check is already completed), clicking the "View Report" button retrieves the report file path from the table and displays the report    
*/

Future<void> viewCibilHtml(
  BuildContext context,
  String? proposalNum,
  String? applicantType,
  String? report,
) async {
  try {
    final bloc = context.read<CicCheckBloc>();
    String htmlBase64 = bloc.state.cibilResponse?.htmlFileCIR ?? '';
    String? localFilePath;

    if (htmlBase64.isEmpty) {
      final data = await fetchReportsFromDB(proposalNum!);
      if (data != null && data.isNotEmpty) {
        final filtered =
            data.where((item) {
              final mapdata = item.toMap();
              return (mapdata['applicantType']?.toString().toLowerCase() ==
                      applicantType?.toLowerCase()) &&
                  (mapdata['reportType']?.toString().toLowerCase() ==
                      report?.toLowerCase());
            }).toList();

        if (filtered.isNotEmpty) {
          final dbdata = filtered.first.toMap();
          localFilePath = dbdata['filepath'] ?? '';
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No matching report found')),
          );
          return;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No report found in database')),
        );
        return;
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => CibilHtmlViewer(
              htmlFileBase64: htmlBase64,
              propNo: proposalNum,
              applicantType: applicantType,
              reportType: report,
              localFilePath: localFilePath,
            ),
      ),
    );
  } catch (e) {
    print('Error loading cibil html: $e');

    showDialog(
      context: context,
      builder:
          (_) => SysmoAlert(
            message: AppConstants.FAILED_TO_LOAD_PDF_MESSAGE,
            icon: Icons.error_outline,
            iconColor: Colors.red,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            buttonText: AppConstants.OK,
            onButtonPressed: () => Navigator.pop(context),
          ),
    );
  }
}

// Fetch report data from table once checked cibil
Future<List<dynamic>?> fetchReportsFromDB(String proposalNum) async {
  UserDetails? userDetails = await loadUser();
  if (userDetails == null) return null;

  final db = await DBConfig().database;
  final cibilCrudRepo = CibilreportsCrudRepo(db);

  final results = await cibilCrudRepo.getByColumnNames(
    columnNames: ['userid', 'proposalNo'],
    columnValues: [userDetails.LPuserID, proposalNum],
  );

  print('cibil reports: ${results.length}');
  return results;
}
