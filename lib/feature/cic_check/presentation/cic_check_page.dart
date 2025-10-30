import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Utils/cibil_report_utils.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/cic_check/presentation/bloc/cic_check_bloc.dart';
import 'package:newsee/feature/cic_check/presentation/bloc/cic_check_event.dart';
import 'package:newsee/feature/cic_check/presentation/bloc/cic_check_state.dart';
import 'package:newsee/widgets/loader.dart';
import 'package:newsee/widgets/sysmo_alert.dart';

class CicCheckPage extends StatelessWidget {
  final Map<String, dynamic>? selectedProp;
  final bool? isApplicantCibilCheck;
  const CicCheckPage({
    super.key,
    this.selectedProp,
    this.isApplicantCibilCheck,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> applicantCibilCheck = ValueNotifier(
      isApplicantCibilCheck!,
    );
    final ValueNotifier<bool> applicantCrifCheck = ValueNotifier(false);
    // final ValueNotifier<bool> coApplicantCibilCheck = ValueNotifier(false);
    // final ValueNotifier<bool> coApplicantCrifCheck = ValueNotifier(false);

    return BlocProvider(
      create: (_) => CicCheckBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CIC Check'),
          backgroundColor: Colors.teal,
        ),
        body: BlocListener<CicCheckBloc, CicCheckState>(
          listener: (context, state) {
            if (state.status == CicCheckStatus.loading) {
              presentLoading(context, AppConstants.creatingCibil);
            } else if (state.status == CicCheckStatus.success) {
              dismissLoading(context);
              applicantCibilCheck.value = state.isApplicantCibilCheck;
              showSnack(context, message: 'Fetched Cibil Details Successfully');
            } else if (state.status == CicCheckStatus.failure) {
              dismissLoading(context);
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
          },
          child: BlocBuilder<CicCheckBloc, CicCheckState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.teal,
                                  size: 32,
                                ),
                                SizedBox(width: 16),
                                Text(
                                  '${AppConstants.appLabelApplicant} ${selectedProp!['propNo'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ValueListenableBuilder<bool>(
                              valueListenable: applicantCibilCheck,
                              builder: (context, cibilChecked, _) {
                                return ValueListenableBuilder<bool>(
                                  valueListenable: applicantCrifCheck,
                                  builder: (context, crifChecked, _) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (!cibilChecked) {
                                              context.read<CicCheckBloc>().add(
                                                CicFetchEvent(
                                                  proposalData: selectedProp,
                                                ),
                                              );
                                              // applicantCibilCheck.value = true;
                                            } else {
                                              viewCibilHtml(
                                                context,
                                                selectedProp?['propNo'],
                                                'A',
                                                'cibil',
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                  255,
                                                  3,
                                                  9,
                                                  110,
                                                ),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 10,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                cibilChecked
                                                    ? Icons.picture_as_pdf
                                                    : Icons.check,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                cibilChecked
                                                    ? 'View CIBIL'
                                                    : 'Check CIBIL',
                                              ),
                                            ],
                                          ),
                                        ),

                                        // const SizedBox(width: 12),
                                        // ElevatedButton(
                                        //   onPressed: () async {
                                        //     if (!crifChecked) {
                                        //       context.read<CicCheckBloc>().add(
                                        //         CicFetchEvent(
                                        //           proposalData: selectedProp,
                                        //         ),
                                        //       );
                                        //       applicantCrifCheck.value = true;
                                        //     } else {
                                        //       viewCibilHtml(
                                        //         context,
                                        //         selectedProp?['propNo'],
                                        //         'A',
                                        //         'crif',
                                        //       );
                                        //     }
                                        //   },

                                        //   style: ElevatedButton.styleFrom(
                                        //     backgroundColor:
                                        //         const Color.fromARGB(
                                        //           255,
                                        //           3,
                                        //           9,
                                        //           110,
                                        //         ),
                                        //     foregroundColor: Colors.white,
                                        //     padding: const EdgeInsets.symmetric(
                                        //       horizontal: 20,
                                        //       vertical: 10,
                                        //     ),
                                        //     shape: RoundedRectangleBorder(
                                        //       borderRadius:
                                        //           BorderRadius.circular(20),
                                        //     ),
                                        //   ),
                                        //   child: Row(
                                        //     mainAxisSize: MainAxisSize.min,
                                        //     children: [
                                        //       Icon(
                                        //         crifChecked
                                        //             ? Icons.picture_as_pdf
                                        //             : Icons.check,
                                        //       ),
                                        //       const SizedBox(width: 8),
                                        //       Text(
                                        //         crifChecked
                                        //             ? 'View CRIF'
                                        //             : 'Check CRIF',
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Card(
                    //   elevation: 4,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(16),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Row(
                    //           children: const [
                    //             Icon(Icons.group, color: Colors.teal, size: 32),
                    //             SizedBox(width: 16),
                    //             Text(
                    //               AppConstants.appLabelCoApplicant,
                    //               style: TextStyle(
                    //                 fontSize: 18,
                    //                 fontWeight: FontWeight.w500,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         const SizedBox(height: 16),
                    //         ValueListenableBuilder<bool>(
                    //           valueListenable: coApplicantCibilCheck,
                    //           builder: (context, cibilChecked, _) {
                    //             return ValueListenableBuilder<bool>(
                    //               valueListenable: coApplicantCrifCheck,
                    //               builder: (context, crifChecked, _) {
                    //                 return Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.center,
                    //                   children: [
                    //                     ElevatedButton(
                    //                       onPressed: () async {
                    //                         if (!cibilChecked) {
                    //                           context.read<CicCheckBloc>().add(
                    //                             CicFetchEvent(
                    //                               proposalData: selectedProp,
                    //                             ),
                    //                           );
                    //                           coApplicantCibilCheck.value =
                    //                               true;
                    //                         } else {
                    //                           viewCibilHtml(
                    //                             context,
                    //                             selectedProp?['propNo'],
                    //                             'C',
                    //                             'cibil',
                    //                           );
                    //                         }
                    //                       },

                    //                       style: ElevatedButton.styleFrom(
                    //                         backgroundColor:
                    //                             const Color.fromARGB(
                    //                               255,
                    //                               3,
                    //                               9,
                    //                               110,
                    //                             ),
                    //                         foregroundColor: Colors.white,
                    //                         padding: const EdgeInsets.symmetric(
                    //                           horizontal: 20,
                    //                           vertical: 10,
                    //                         ),
                    //                         shape: RoundedRectangleBorder(
                    //                           borderRadius:
                    //                               BorderRadius.circular(20),
                    //                         ),
                    //                       ),
                    //                       child: Row(
                    //                         mainAxisSize: MainAxisSize.min,
                    //                         children: [
                    //                           Icon(
                    //                             cibilChecked
                    //                                 ? Icons.picture_as_pdf
                    //                                 : Icons.check,
                    //                           ),
                    //                           const SizedBox(width: 8),
                    //                           Text(
                    //                             cibilChecked
                    //                                 ? 'View CIBIL'
                    //                                 : 'Check CIBIL',
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                     const SizedBox(width: 12),
                    //                     ElevatedButton(
                    //                       onPressed: () async {
                    //                         if (!crifChecked) {
                    //                           context.read<CicCheckBloc>().add(
                    //                             CicFetchEvent(
                    //                               proposalData: selectedProp,
                    //                             ),
                    //                           );
                    //                           coApplicantCrifCheck.value = true;
                    //                         } else {
                    //                           viewCibilHtml(
                    //                             context,
                    //                             selectedProp?['propNo'],
                    //                             'C',
                    //                             'crif',
                    //                           );
                    //                         }
                    //                       },

                    //                       style: ElevatedButton.styleFrom(
                    //                         backgroundColor:
                    //                             const Color.fromARGB(
                    //                               255,
                    //                               3,
                    //                               9,
                    //                               110,
                    //                             ),
                    //                         foregroundColor: Colors.white,
                    //                         padding: const EdgeInsets.symmetric(
                    //                           horizontal: 20,
                    //                           vertical: 10,
                    //                         ),
                    //                         shape: RoundedRectangleBorder(
                    //                           borderRadius:
                    //                               BorderRadius.circular(20),
                    //                         ),
                    //                       ),
                    //                       child: Row(
                    //                         mainAxisSize: MainAxisSize.min,
                    //                         children: [
                    //                           Icon(
                    //                             crifChecked
                    //                                 ? Icons.picture_as_pdf
                    //                                 : Icons.check,
                    //                           ),
                    //                           const SizedBox(width: 8),
                    //                           Text(
                    //                             crifChecked
                    //                                 ? 'View CRIF'
                    //                                 : 'Check CRIF',
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 );
                    //               },
                    //             );
                    //           },
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      //   },
      // ),
    );
  }
}
