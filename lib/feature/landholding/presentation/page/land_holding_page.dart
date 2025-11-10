import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/landholding/presentation/bloc/land_holding_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_event.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/widgets/google_maps_card.dart';
import 'package:newsee/widgets/k_willpopscope.dart';
import 'package:newsee/widgets/options_sheet.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:newsee/widgets/success_bottom_sheet.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/radio.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LandHoldingPage extends StatelessWidget {
  final String proposalNumber;
  final String applicantName;
  final String title;

  final form = AppForms.buildLandHoldingForm();

  LandHoldingPage({
    super.key,
    required this.title,
    required this.applicantName,
    required this.proposalNumber,
  });

  void handleSubmit(BuildContext context, LandHoldingState state) async {
    if (form.valid) {
      // final globalLoadingBloc = context.read<GlobalLoadingBloc>();
      // globalLoadingBloc.add(ShowLoading(message: "Land Holding Details Submitting..."));
      context.read<LandHoldingBloc>().add(
        LandDetailsSaveEvent(
          landData: form.rawValue,
          proposalNumber: proposalNumber,
        ),
      );
    } else {
      form.markAllAsTouched();
    }
  }

  void showGoogleMapsDailog(
    BuildContext context,
    double latitude,
    double longitude,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => GoogleMapsCard(location: LatLng(latitude, longitude)),
    );
  }

  void showBottomSheet(BuildContext context, LandHoldingState state) {
    final entries = state.landData ?? [];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return BlocProvider<LandHoldingBloc>.value(
          value: context.read<LandHoldingBloc>(),
          child: SafeArea(
            child: SizedBox(
              height: 500,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    "Note: Scroll left or right to delete land detail",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child:
                        entries.isEmpty
                            ? const Center(child: Text('No saved entries.'))
                            : ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: entries.length,
                              separatorBuilder: (_, __) => const Divider(),
                              itemBuilder: (ctx, index) {
                                final item = entries[index];
                                return Slidable(
                                  key: ValueKey(item.lklRowid),
                                  endActionPane: ActionPane(
                                    motion: ScrollMotion(),
                                    extentRatio:
                                        0.25, // Controls width of action pane
                                    children: [
                                      SlidableAction(
                                        onPressed: (slidableContext) {
                                          try {
                                            // await Future.delayed(Duration(seconds: 1));
                                            // final globalLoadingBloc = slidableContext.read<GlobalLoadingBloc>();
                                            // globalLoadingBloc.add(ShowLoading(message: "please Wait..."));
                                            slidableContext
                                                .read<LandHoldingBloc>()
                                                .add(
                                                  LandDetailsDeleteEvent(
                                                    landData: item,
                                                    index: index,
                                                  ),
                                                );
                                          } catch (error) {
                                            print(
                                              "deleteLandData-error $error",
                                            );
                                          }
                                        },
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: OptionsSheet(
                                    icon: Icons.grass,
                                    title:
                                        item.lklApplicantName != null
                                            ? item.lklApplicantName.toString()
                                            : applicantName,
                                    details: [
                                      item.lklSurveyNo.toString(),
                                      item.lklVillage.toString(),
                                      item.lklTotAcre.toString(),
                                    ],
                                    detailsName: [
                                      "Survey No",
                                      "Village",
                                      "Total Acreage",
                                    ],
                                    onTap: () {
                                      Navigator.pop(context);
                                      context.read<LandHoldingBloc>().add(
                                        LandDetailsLoadEvent(landData: item),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final globalLoadingBloc = context.read<GlobalLoadingBloc>();

    return Kwillpopscope(
      routeContext: context,
      form: form,
      widget: Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.15,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(color: Colors.teal),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),

              Center(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  padding: const EdgeInsets.all(8),

                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Proposal Id: ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            proposalNumber ?? 'N/A',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: BlocProvider(
          create:
              (_) =>
                  LandHoldingBloc()
                    ..add(LandHoldingInitEvent(proposalNumber: proposalNumber)),
          child: BlocConsumer<LandHoldingBloc, LandHoldingState>(
            listener: (context, state) {
              if (state.status == SaveStatus.loading) {
                globalLoadingBloc.add(ShowLoading(message: 'Please wait...'));
              }
              if (state.status == SaveStatus.success) {
                globalLoadingBloc.add(HideLoading());
                form.reset();
                form.control('applicantName').updateValue(applicantName);
                form.control('sumOfTotalAcreage').markAsDisabled();
                showSuccessBottomSheet(
                  context: context,
                  headerTxt: ApiConstants.api_response_success,
                  lead: "",
                  message: "Landholding details successfully submitted",
                  leftButtonLabel: 'Go To Crop Details',
                  rightButtonLabel: 'Cancel',
                  onPressedLeftButton: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                      context.pushNamed('cropdetails', extra: proposalNumber);
                    }
                  },
                  onPressedRightButton: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                );
              }
              if (state.selectedLandData != null &&
                  state.status == SaveStatus.update) {
                var selectedFormArrayData = state.selectedLandData!.mapForm();
                print("selectedFormArrayData $selectedFormArrayData");
                selectedFormArrayData['applicantName'] = applicantName;
                form.patchValue(selectedFormArrayData);
              }
              if (state.status == SaveStatus.mastersucess ||
                  state.status == SaveStatus.masterfailure) {
                if (state.status == SaveStatus.masterfailure) {
                  showSnack(context, message: 'Failed to Fetch Masters...');
                }

                print('city list => ${state.cityMaster}');
                globalLoadingBloc.add(HideLoading());
              }
              if (state.status == SaveStatus.delete &&
                  state.errorMessage != null) {
                globalLoadingBloc.add(HideLoading());
                form.reset();

                form.control('applicantName').updateValue(applicantName);
                form.control('sumOfTotalAcreage').markAsDisabled();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage.toString())),
                );
              }
            },
            builder: (context, state) {
              if (state.status == SaveStatus.init) {
                form.control('applicantName').updateValue(applicantName);
              }
              return ReactiveForm(
                formGroup: form,
                child: SafeArea(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Dropdown(
                                      controlName: 'applicantName',
                                      label: 'Applicant Name / Guarantor',
                                      items: [applicantName],
                                    ),
                                    // CustomTextField(
                                    //   controlName: 'applicantName',
                                    //   label: 'Applicant Name / Guarantor',
                                    //   mantatory: true,
                                    // ),
                                    SearchableDropdown(
                                      controlName: 'state',
                                      label: 'State',
                                      items: state.stateCityMaster!,
                                      onChangeListener: (GeographyMaster val) {
                                        form.controls['state']?.updateValue(
                                          val.code,
                                        );

                                        context.read<LandHoldingBloc>().add(
                                          OnStateCityChangeEvent(
                                            stateCode: val.code,
                                          ),
                                        );
                                      },
                                      selItem: () {
                                        final value =
                                            form.control('state').value;
                                        if (value == null ||
                                            value.toString().isEmpty) {
                                          return null;
                                        }
                                        if (state.status == SaveStatus.update &&
                                            state
                                                    .selectedLandData
                                                    ?.lslLandState !=
                                                null) {
                                          String? stateCode =
                                              state
                                                  .selectedLandData
                                                  ?.lslLandState;

                                          GeographyMaster? geographyMaster =
                                              state.stateCityMaster?.firstWhere(
                                                (val) => val.code == stateCode,
                                              );
                                          print(geographyMaster);
                                          if (geographyMaster != null) {
                                            form.controls['state']?.updateValue(
                                              geographyMaster.code,
                                            );
                                            return geographyMaster;
                                          } else {
                                            return <GeographyMaster>[];
                                          }
                                        } else if (state
                                            .stateCityMaster!
                                            .isEmpty) {
                                          form.controls['state']?.updateValue(
                                            "",
                                          );
                                          return <GeographyMaster>[];
                                        }
                                      },
                                    ),
                                    SearchableDropdown(
                                      controlName: 'district',
                                      label: 'District',
                                      items: state.cityMaster!,
                                      onChangeListener: (GeographyMaster val) {
                                        form.controls['district']?.updateValue(
                                          val.code,
                                        );
                                      },
                                      selItem: () {
                                        final value =
                                            form.control('district').value;
                                        if (value == null ||
                                            value.toString().isEmpty) {
                                          return null;
                                        }
                                        if (state.status == SaveStatus.update &&
                                            state
                                                    .selectedLandData
                                                    ?.lslLandState !=
                                                null) {
                                          String? cityCode =
                                              state
                                                  .selectedLandData
                                                  ?.lslLandDistrict;

                                          GeographyMaster? geographyMaster =
                                              state.cityMaster?.firstWhere(
                                                (val) => val.code == cityCode,
                                                orElse:
                                                    () => GeographyMaster(
                                                      stateParentId: '0',
                                                      cityParentId: '0',
                                                      code: '0',
                                                      value: '',
                                                    ),
                                              );
                                          print(geographyMaster);
                                          if (geographyMaster != null) {
                                            form.controls['district']
                                                ?.updateValue(
                                                  geographyMaster.code,
                                                );
                                            return geographyMaster;
                                          } else {
                                            return <GeographyMaster>[];
                                          }
                                        } else if (state
                                            .stateCityMaster!
                                            .isEmpty) {
                                          form.controls['district']
                                              ?.updateValue("");
                                          return <GeographyMaster>[];
                                        }
                                      },
                                    ),
                                    CustomTextField(
                                      controlName: 'village',
                                      label: 'Village',
                                      mantatory: true,
                                    ),
                                    CustomTextField(
                                      controlName: 'taluk',
                                      label: 'Taluk',
                                      mantatory: true,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: IntegerTextField(
                                            controlName: 'farmDistance',
                                            label: 'Farm Distance (km)',
                                            mantatory: true,
                                            maxlength: 3,
                                          ),
                                        ),
                                      ],
                                    ),

                                    IntegerTextField(
                                      controlName: 'surveyNo',
                                      label: 'Survey No.',
                                      mantatory: true,
                                      maxlength: 10,
                                    ),

                                    IntegerTextField(
                                      controlName: 'khasraNo',
                                      label: 'Khasra No',
                                      mantatory: true,
                                      maxlength: 10,
                                    ),
                                    IntegerTextField(
                                      controlName: 'uccCode',
                                      label: 'UCC Code',
                                      mantatory: true,
                                      maxlength: 10,
                                    ),
                                    IntegerTextField(
                                      controlName: 'totAcre',
                                      label: 'Total Acreage (in Acres)',
                                      mantatory: true,
                                      maxlength: 3,
                                      minlength: 1,
                                    ),

                                    SearchableDropdown<Lov>(
                                      controlName: 'landType',
                                      label: 'Land Type',
                                      items:
                                          state.lovlist!
                                              .where(
                                                (v) => v.Header == 'LandType',
                                              )
                                              .toList(),
                                      onChangeListener: (Lov val) {
                                        form.controls['landType']?.updateValue(
                                          val.optvalue,
                                        );
                                        final totAcre =
                                            form.control('totAcre').value;
                                        form.controls['sumOfTotalAcreage']
                                            ?.updateValue(totAcre);
                                      },
                                      selItem: () {
                                        final value =
                                            form.control('landType').value;
                                        if (value == null ||
                                            value.toString().isEmpty) {
                                          return null;
                                        }
                                        return state.lovlist!
                                            .where(
                                              (v) => v.Header == 'LandType',
                                            )
                                            .firstWhere(
                                              (lov) => lov.optvalue == value,
                                              orElse:
                                                  () => Lov(
                                                    Header: 'LandType',
                                                    optDesc: '',
                                                    optvalue: '',
                                                    optCode: '',
                                                  ),
                                            );
                                      },
                                    ),

                                    SearchableDropdown<Lov>(
                                      controlName: 'sourceofIrrig',
                                      label: 'Source of Irrigation',
                                      items:
                                          state.lovlist!
                                              .where(
                                                (v) =>
                                                    v.Header ==
                                                    'NatureOfIrrFac',
                                              )
                                              .toList(),
                                      onChangeListener: (Lov val) {
                                        form.controls['sourceofIrrig']
                                            ?.updateValue(val.optvalue);
                                      },
                                      selItem: () {
                                        final value =
                                            form.control('sourceofIrrig').value;
                                        if (value == null ||
                                            value.toString().isEmpty) {
                                          return null;
                                        }
                                        return state.lovlist!
                                            .where(
                                              (v) =>
                                                  v.Header == 'NatureOfIrrFac',
                                            )
                                            .firstWhere(
                                              (lov) => lov.optvalue == value,
                                              orElse:
                                                  () => Lov(
                                                    Header: 'NatureOfIrrFac',
                                                    optDesc: '',
                                                    optvalue: '',
                                                    optCode: '',
                                                  ),
                                            );
                                      },
                                    ),
                                    SearchableDropdown<Lov>(
                                      controlName: 'particulars',
                                      label: 'Particulars Of Land',
                                      items:
                                          state.lovlist!
                                              .where(
                                                (v) =>
                                                    v.Header ==
                                                    'LandIrrigation',
                                              )
                                              .toList(),
                                      onChangeListener: (Lov val) {
                                        form.controls['particulars']
                                            ?.updateValue(val.optvalue);
                                      },
                                      selItem: () {
                                        final value =
                                            form.control('particulars').value;
                                        if (value == null ||
                                            value.toString().isEmpty) {
                                          return null;
                                        }
                                        return state.lovlist!
                                            .where(
                                              (v) =>
                                                  v.Header == 'LandIrrigation',
                                            )
                                            .firstWhere(
                                              (lov) => lov.optvalue == value,
                                              orElse:
                                                  () => Lov(
                                                    Header: 'LandIrrigation',
                                                    optDesc: '',
                                                    optvalue: '',
                                                    optCode: '',
                                                  ),
                                            );
                                      },
                                    ),
                                    SearchableDropdown<Lov>(
                                      controlName: 'farmercategory',
                                      label: 'Farmer Category',
                                      items:
                                          state.lovlist!
                                              .where(
                                                (v) => v.Header == 'FarmerType',
                                              )
                                              .toList(),
                                      onChangeListener: (Lov val) {
                                        form.controls['farmercategory']
                                            ?.updateValue(val.optvalue);
                                      },
                                      selItem: () {
                                        final value =
                                            form
                                                .control('farmercategory')
                                                .value;
                                        if (value == null ||
                                            value.toString().isEmpty) {
                                          return null;
                                        }
                                        return state.lovlist!
                                            .where(
                                              (v) => v.Header == 'FarmerType',
                                            )
                                            .firstWhere(
                                              (lov) => lov.optvalue == value,
                                              orElse:
                                                  () => Lov(
                                                    Header: 'FarmerType',
                                                    optDesc: '',
                                                    optvalue: '',
                                                    optCode: '',
                                                  ),
                                            );
                                      },
                                    ),

                                    RadioButton(
                                      label: 'Other Banks',
                                      controlName: 'otherbanks',
                                      optionOne: 'Yes',
                                      optionTwo: 'No',
                                    ),

                                    SearchableDropdown<Lov>(
                                      controlName: 'primaryoccupation',
                                      label: 'Primary Occupation',
                                      items:
                                          state.lovlist!
                                              .where(
                                                (v) =>
                                                    v.Header == 'AgricultType',
                                              )
                                              .toList(),
                                      onChangeListener: (Lov val) {
                                        form.controls['primaryoccupation']
                                            ?.updateValue(val.optvalue);
                                      },
                                      selItem: () {
                                        final value =
                                            form
                                                .control('primaryoccupation')
                                                .value;
                                        if (value == null ||
                                            value.toString().isEmpty) {
                                          return null;
                                        }
                                        return state.lovlist!
                                            .where(
                                              (v) => v.Header == 'AgricultType',
                                            )
                                            .firstWhere(
                                              (lov) => lov.optvalue == value,
                                              orElse:
                                                  () => Lov(
                                                    Header: 'AgricultType',
                                                    optDesc: '',
                                                    optvalue: '',
                                                    optCode: '',
                                                  ),
                                            );
                                      },
                                    ),
                                    IntegerTextField(
                                      controlName: 'sumOfTotalAcreage',
                                      label: 'Sum Of Total Acreage',
                                      mantatory: true,
                                    ),
                                    ElevatedButton.icon(
                                      onPressed:
                                          () => handleSubmit(context, state),
                                      icon: const Icon(
                                        Icons.save,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        'Save',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                          212,
                                          5,
                                          8,
                                          205,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // FAB with badge on top
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            FloatingActionButton(
                              heroTag: 'view_button',
                              backgroundColor: Colors.white,
                              tooltip: 'View Saved Data',
                              onPressed: () => showBottomSheet(context, state),
                              child: const Icon(
                                Icons.menu,
                                color: Colors.blue,
                                size: 28,
                              ),
                            ),
                            if (state.landData != null)
                              Positioned(
                                top: -10,
                                right: -4,
                                child: Container(
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${state.landData?.length ?? 0}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
