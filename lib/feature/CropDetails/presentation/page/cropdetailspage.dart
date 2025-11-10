import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/Utils/shared_preference_utils.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/CropDetails/domain/modal/cropdetailsmodal.dart';
import 'package:newsee/feature/CropDetails/presentation/bloc/cropyieldpage_bloc.dart';
import 'package:newsee/feature/auth/domain/model/user_details.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_event.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/widgets/k_willpopscope.dart';
import 'package:newsee/widgets/options_sheet.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:newsee/widgets/success_bottom_sheet.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:newsee/widgets/radio.dart';
import 'package:newsee/widgets/integer_text_field.dart';

class CropDetailsPage extends StatefulWidget {
  final String title;
  final String proposalnumber;

  const CropDetailsPage({
    super.key,
    required this.title,
    required this.proposalnumber,
  });

  @override
  State<CropDetailsPage> createState() => _CropDetailsPageState();
}

class _CropDetailsPageState extends State<CropDetailsPage> {
  final form = AppForms.buildCropDetailsForm();
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  bool _isResetting = false;
  @override
  void initState() {
    super.initState();

    // Trigger auto-calculation when any dependent control changes
    final controlsToWatch = [
      'culAreaLand',
      'scaOfFin',
      'addSofByRo',
      'season',
      'covOfCrop',
      'cropIns',
      'cropType',
    ];

    for (final controlName in controlsToWatch) {
      form.control(controlName).valueChanges.listen((_) => getAddSofAmount());
    }
  }

  void getAddSofAmount() {
    try {
      final culAreaRaw = form.control('culAreaLand').value?.toString() ?? '0';
      final sofRaw = form.control('scaOfFin').value?.toString() ?? '0';
      final addSofRaw = form.control('addSofByRo').value?.toString() ?? '0';
      final cropIns = form.control('cropIns').value?.toString() ?? '';
      final cropType = form.control('cropType').value?.toString() ?? '';

      // If key inputs are empty or zero — clear calculated fields and return
      if (culAreaRaw.trim().isEmpty ||
          sofRaw.trim().isEmpty ||
          culAreaRaw == '0' ||
          sofRaw == '0') {
        form.control('costOfCul').patchValue('', emitEvent: true);
        form.control('addSofAmount').patchValue('', emitEvent: true);
        form.control('insPre').patchValue('', emitEvent: true);
        form.control('dueDateOfRepay').patchValue('', emitEvent: true);
        return;
      }

      final culArea = double.tryParse(culAreaRaw) ?? 0.0;
      final sof = double.tryParse(sofRaw) ?? 0.0;
      final addSOfPercent = double.tryParse(addSofRaw) ?? 0.0;

      // Base calculations
      final totalCultCost = culArea * sof;
      final addSofValue = totalCultCost * (addSOfPercent / 100);

      // Insurance calculation
      //season: Kharif - 1, rabi - 2
      // coverage crop: food/oil - 1 horticult crop - 2
      if (cropIns == '2') {
        form.control('insPre').patchValue('0', emitEvent: true);
      } else {
        final season = form.control('season').value?.toString() ?? '';
        final covOfCrop = form.control('covOfCrop').value?.toString() ?? '';

        double covPercent = 1.5;
        if (season == '1' && covOfCrop == '1') {
          covPercent = 2.0;
        } else if (covOfCrop == '2') {
          covPercent = 5.0;
        }

        final cov = totalCultCost * (covPercent / 100);
        form
            .control('insPre')
            .patchValue(cov.toStringAsFixed(2), emitEvent: true);
      }

      // Update calculated fields
      form
          .control('costOfCul')
          .patchValue(totalCultCost.toStringAsFixed(2), emitEvent: true);
      form
          .control('addSofAmount')
          .patchValue(addSofValue.toStringAsFixed(2), emitEvent: true);

      // Repayment due date calculation
      // 1- long term, 2 -short term
      final now = DateTime.now();
      final monthsToAdd = cropType == '1' ? 18 : 12;
      final dueDate = DateTime(now.year, now.month + monthsToAdd, now.day);
      final formattedDate =
          '${dueDate.day.toString().padLeft(2, '0')}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.year}';
      form.control('dueDateOfRepay').patchValue(formattedDate, emitEvent: true);

      print('Calculations completed: ${form.value}');
    } catch (e, stack) {
      print('Error in getAddSofAmount: $e');
      print(stack);
    }
  }

  void resetForm() {
    form.reset();
  }

  bool isFormCompletelyEmpty(FormGroup form) {
    return form.rawValue.values.every((value) {
      return value == null || value.toString().trim().isEmpty;
    });
  }

  backHandler(context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Unsaved Changes'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('Cancel'),
              ),

              TextButton(
                onPressed: () {
                  context.goNamed('home');
                },
                child: Text('Yes'),
              ),
            ],
          ),
    );
  }

  void handleSave(BuildContext context, CropyieldpageState state) {
    if (form.valid) {
      print("handleSave =>  ${form.rawValue}");

      final cropFormData = CropDetailsModal.fromForm(form.rawValue);
      context.read<CropyieldpageBloc>().add(
        CropFormSaveEvent(cropData: cropFormData),
      );
    } else {
      form.markAllAsTouched();
    }
  }

  void handleSubmit(BuildContext context) async {
    UserDetails? userDetails = await loadUser();

    context.read<CropyieldpageBloc>().add(
      CropDetailsSubmitEvent(
        proposalNumber: widget.proposalnumber,
        userid: userDetails!.LPuserID,
      ),
    );
  }

  void handleReset(BuildContext context, CropyieldpageState state) {
    context.read<CropyieldpageBloc>().add(CropDetailsResetEvent());
  }

  void handleUpdate(BuildContext context, CropyieldpageState state) {
    if (form.valid) {
      print('handleupdate: ${form.rawValue}');
      final cropFormData = CropDetailsModal.fromForm(form.rawValue);
      context.read<CropyieldpageBloc>().add(
        CropDetailsUpdateEvent(
          cropData: cropFormData,
          index: currentIndex.value,
        ),
      );
    } else {
      form.markAllAsTouched();
    }
  }

  disableFields() {
    form.control('insPre').markAsDisabled();
    form.control('costOfCul').markAsDisabled();
    form.control('addSofAmount').markAsDisabled();
    form.control('dueDateOfRepay').markAsDisabled();
  }

  void showBottomSheet(BuildContext context, CropyieldpageState state) {
    final entries = state.cropData ?? [];
    final lovlist = state.lovlist;
    // final showSubmitButton = state.showSubmit;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        final showSubmitButton = state.showSubmit;
        print("showSubmitButton $showSubmitButton");
        return BlocProvider<CropyieldpageBloc>.value(
          value: context.read<CropyieldpageBloc>(),
          child: SafeArea(
            child: SizedBox(
              height: 400,
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
                                print("full item data $item");
                                final landname = lovlist!.firstWhere(
                                  (v) =>
                                      v.Header == 'CropTypeOfLand' &&
                                      v.optvalue == item.lcdTypeOfLand,
                                );
                                final cropname = lovlist.firstWhere(
                                  (v) =>
                                      v.Header == 'CropName' &&
                                      v.optvalue == item.lcdCropName,
                                );
                                print("cropname $cropname");
                                return Slidable(
                                  key: ValueKey(item.lcdRowId),
                                  endActionPane: ActionPane(
                                    motion: ScrollMotion(),
                                    extentRatio:
                                        0.25, // Controls width of action pane
                                    children: [
                                      SlidableAction(
                                        onPressed: (slidableContext) {
                                          try {
                                            if (item.lcdRowId != null &&
                                                item.lcdRowId != '') {
                                              print(item.lcdRowId);
                                              slidableContext
                                                  .read<CropyieldpageBloc>()
                                                  .add(
                                                    CropDetailsDeleteEvent(
                                                      proposalNumber:
                                                          widget.proposalnumber,
                                                      rowId:
                                                          item.lcdRowId
                                                              .toString(),
                                                      index: index,
                                                    ),
                                                  );
                                            } else {
                                              slidableContext
                                                  .read<CropyieldpageBloc>()
                                                  .add(
                                                    CropDetailsRemoveEvent(
                                                      index: index,
                                                    ),
                                                  );
                                            }
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
                                    icon: Icons.agriculture,
                                    title: 'LandType - ${landname.optDesc}',
                                    details: [cropname.optDesc],
                                    detailsName: ["Name of the Crop"],
                                    onTap: () {
                                      currentIndex.value = index;
                                      Navigator.pop(context);
                                      context.read<CropyieldpageBloc>().add(
                                        CropDetailsSetEvent(cropData: item),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                  ),
                  (entries.isNotEmpty &&
                          context.read<CropyieldpageBloc>().state.showSubmit)
                      ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              handleSubmit(context);
                            },
                            icon: Icon(Icons.send, color: Colors.white),
                            label: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(text: 'Push to '),
                                  TextSpan(
                                    text: 'LEND',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  TextSpan(
                                    text: 'perfect',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                Size(double.infinity, 50),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 75, 33, 83),
                              ),
                            ),
                          ),
                        ),
                      )
                      : SizedBox.shrink(),
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
              // SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () => {backHandler(context)},
                    child: Text(
                      'Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 02),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(8),

                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
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
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              widget.proposalnumber ?? 'N/A',

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
              ),
            ],
          ),
        ),
        body: BlocProvider(
          create:
              (_) =>
                  CropyieldpageBloc()..add(
                    CropPageInitialEvent(proposalNumber: widget.proposalnumber),
                  ),
          // lazy: true,
          child: BlocConsumer<CropyieldpageBloc, CropyieldpageState>(
            listener: (context, state) {
              if (state.status == SaveStatus.loading) {
                globalLoadingBloc.add(ShowLoading(message: 'Please wait...'));
              }

              if (state.status == SaveStatus.delete) {
                globalLoadingBloc.add(HideLoading());
                form.reset();
                showSnack(
                  context,
                  message: 'Crop Details Deleted Successfully',
                );
              }

              if (state.status == SaveStatus.init) {
                globalLoadingBloc.add(HideLoading());
                // if ((state.cropData != null && state.cropData!.isNotEmpty) &&
                //     (state.landDetails != null &&
                //         state.landDetails!.isNotEmpty)) {
                //   irrigatedController.text =
                //       state.landDetails!['lpAgriPcIrrigated'].toString();
                //   rainfedController.text =
                //       state.landDetails!['lpAgriPcRainfed'].toString();
                // }
              } else if (state.status == SaveStatus.mastersucess) {
                // form.reset();
                resetForm();
                disableFields();
              } else if (state.status == SaveStatus.reset) {
                // form.reset();
                resetForm();
                disableFields();
              } else if (state.status == SaveStatus.success) {
                // form.reset();
                resetForm();
                disableFields();
                context.pop();
                globalLoadingBloc.add(HideLoading());
                showSuccessBottomSheet(
                  context: context,
                  headerTxt: ApiConstants.api_response_success,
                  lead: "",
                  message: "Crop details successfully submitted",
                  leftButtonLabel: 'Documents Upload',
                  rightButtonLabel: 'Cancel',
                  onPressedLeftButton: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                      context.pushNamed(
                        'document',
                        extra: widget.proposalnumber,
                      );
                    }
                  },
                  onPressedRightButton: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  }, // OnPressedRightButton,
                );

                // showSnack(
                //   context,
                //   message: 'Crop Details Submitted Successfully',
                // );
              } else if (state.status == SaveStatus.failure &&
                  state.errorMessage != null) {
                globalLoadingBloc.add(HideLoading());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage.toString())),
                );
                showSnack(
                  context,
                  message: 'Crop Details Submitted Successfully',
                );
              }
            },
            builder: (context, state) {
              print("state.showSubmit-builer ${state.showSubmit}");
              if (state.status == SaveStatus.update &&
                  state.selectedCropData != null) {
                print(
                  "currently current selected cropdetails index is ${currentIndex.value}",
                );
                print("state.selectedCropData is => ${state.selectedCropData}");
                form.patchValue(state.selectedCropData!.toForm());

                form.updateValueAndValidity();
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
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    SearchableDropdown<Lov>(
                                      controlName: 'season',
                                      label: 'Season',
                                      items:
                                          state.lovlist!
                                              .where(
                                                (v) => v.Header == 'Season',
                                              )
                                              .toList(),
                                      onChangeListener: (Lov val) {
                                        form.controls['season']?.updateValue(
                                          val.optvalue,
                                        );
                                      },
                                      selItem: () {
                                        final value =
                                            form.control('season').value;
                                        return state.lovlist!
                                            .where((v) => v.Header == 'Season')
                                            .firstWhere(
                                              (lov) => lov.optvalue == value,
                                              orElse:
                                                  () => Lov(
                                                    Header: 'Season',
                                                    optDesc: '',
                                                    optvalue: '',
                                                    optCode: '',
                                                  ),
                                            );
                                      },
                                    ),
                                    SearchableDropdown<Lov>(
                                      controlName: 'cropType',
                                      label: 'Crop Type',
                                      items:
                                          state.lovlist!
                                              .where(
                                                (v) => v.Header == 'CropType',
                                              )
                                              .toList(),
                                      onChangeListener: (Lov val) {
                                        form.controls['cropType']?.updateValue(
                                          val.optvalue,
                                        );
                                      },
                                      selItem: () {
                                        final value =
                                            form.control('cropType').value;
                                        return state.lovlist!
                                            .where(
                                              (v) => v.Header == 'CropType',
                                            )
                                            .firstWhere(
                                              (lov) => lov.optvalue == value,
                                              orElse:
                                                  () => Lov(
                                                    Header: 'CropType',
                                                    optDesc: '',
                                                    optvalue: '',
                                                    optCode: '',
                                                  ),
                                            );
                                      },
                                    ),

                                    SearchableDropdown<Lov>(
                                      controlName: 'cropName',
                                      label: 'Crop Name',
                                      items:
                                          state.lovlist!
                                              .where(
                                                (v) => v.Header == 'CropName',
                                              )
                                              .toList(),
                                      onChangeListener: (Lov val) {
                                        form.controls['cropName']?.updateValue(
                                          val.optvalue,
                                        );
                                      },
                                      selItem: () {
                                        final value =
                                            form.control('cropName').value;
                                        return state.lovlist!
                                            .where(
                                              (v) => v.Header == 'CropName',
                                            )
                                            .firstWhere(
                                              (lov) => lov.optvalue == value,
                                              orElse:
                                                  () => Lov(
                                                    Header: 'CropName',
                                                    optDesc: '',
                                                    optvalue: '',
                                                    optCode: '',
                                                  ),
                                            );
                                      },
                                    ),

                                    SearchableDropdown<Lov>(
                                      controlName: 'covOfCrop',
                                      label: 'Coverage of Crop',
                                      items:
                                          state.lovlist!
                                              .where(
                                                (v) =>
                                                    v.Header ==
                                                    'CoverageOfCorp',
                                              )
                                              .toList(),
                                      onChangeListener: (Lov val) {
                                        form.controls['covOfCrop']?.updateValue(
                                          val.optvalue,
                                        );
                                      },
                                      selItem: () {
                                        final value =
                                            form.control('covOfCrop').value;
                                        return state.lovlist!
                                            .where(
                                              (v) =>
                                                  v.Header == 'CoverageOfCorp',
                                            )
                                            .firstWhere(
                                              (lov) => lov.optvalue == value,
                                              orElse:
                                                  () => Lov(
                                                    Header: 'CoverageOfCorp',
                                                    optDesc: '',
                                                    optvalue: '',
                                                    optCode: '',
                                                  ),
                                            );
                                      },
                                    ),

                                    SearchableDropdown<Lov>(
                                      controlName: 'typeOfLand',
                                      label: 'Type of Land',
                                      items:
                                          state.lovlist!
                                              .where(
                                                (v) =>
                                                    v.Header ==
                                                    'CropTypeOfLand',
                                              )
                                              .toList(),
                                      onChangeListener: (Lov val) {
                                        form.controls['typeOfLand']
                                            ?.updateValue(val.optvalue);
                                      },
                                      selItem: () {
                                        final value =
                                            form.control('typeOfLand').value;
                                        return state.lovlist!
                                            .where(
                                              (v) =>
                                                  v.Header == 'CropTypeOfLand',
                                            )
                                            .firstWhere(
                                              (lov) => lov.optvalue == value,
                                              orElse:
                                                  () => Lov(
                                                    Header: 'CropTypeOfLand',
                                                    optDesc: '',
                                                    optvalue: '',
                                                    optCode: '',
                                                  ),
                                            );
                                      },
                                    ),
                                    IntegerTextField(
                                      controlName: 'culAreaLand',
                                      label: 'Area Of Cultivated (Acre)',
                                      mantatory: true,
                                      maxlength: 5,
                                    ),
                                    IntegerTextField(
                                      controlName: 'scaOfFin',
                                      label: 'Scale of Finance (per Acre)',
                                      mantatory: true,
                                      maxlength: 10,
                                      isRupeeFormat: true,
                                    ),
                                    IntegerTextField(
                                      controlName: 'costOfCul',
                                      label:
                                          'Total Cost Of Cultivation(Acreage*SOF)',
                                      mantatory: true,
                                      isRupeeFormat: true,
                                      maxlength: 10,
                                    ),
                                    IntegerTextField(
                                      controlName: 'addSofByRo',
                                      label: 'Additional SOF %',
                                      mantatory: true,
                                      maxlength: 10,
                                    ),
                                    IntegerTextField(
                                      controlName: 'addSofAmount',
                                      label: 'Additonal SOF Amount',
                                      mantatory: true,
                                      maxlength: 10,
                                      isRupeeFormat: true,
                                    ),
                                    IntegerTextField(
                                      controlName: 'culAreaSize',
                                      label: 'Cultivated Area Size',
                                      mantatory: true,
                                      maxlength: 10,
                                    ),

                                    SearchableDropdown<Lov>(
                                      controlName: 'cropIns',
                                      label: 'Crop Insurance',
                                      items:
                                          state.lovlist!
                                              .where(
                                                (v) =>
                                                    v.Header == 'CorpInsurance',
                                              )
                                              .toList(),
                                      onChangeListener: (Lov val) {
                                        form.controls['cropIns']?.updateValue(
                                          val.optvalue,
                                        );
                                      },
                                      selItem: () {
                                        final value =
                                            form.control('cropIns').value;
                                        return state.lovlist!
                                            .where(
                                              (v) =>
                                                  v.Header == 'CorpInsurance',
                                            )
                                            .firstWhere(
                                              (lov) => lov.optvalue == value,
                                              orElse:
                                                  () => Lov(
                                                    Header: 'CorpInsurance',
                                                    optDesc: '',
                                                    optvalue: '',
                                                    optCode: '',
                                                  ),
                                            );
                                      },
                                    ),
                                    IntegerTextField(
                                      controlName: 'insPre',
                                      label: 'Insurance Premium',
                                      mantatory: true,
                                      maxlength: 10,
                                      isRupeeFormat: true,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: ReactiveTextField<String>(
                                        formControlName: 'dueDateOfRepay',
                                        validationMessages: {
                                          ValidationMessage.required:
                                              (error) =>
                                                  'Due Date Of Repayment is required',
                                        },
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          // labelText: 'Due Date Of Repayment',
                                          label: RichText(
                                            text: TextSpan(
                                              text: 'Due Date Of Repayment',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: ' *',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          suffixIcon: Icon(
                                            Icons.calendar_today,
                                          ),
                                        ),
                                        onTap: (control) async {
                                          final DateTime? pickedDate =
                                              await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime.now(),
                                              );
                                          if (pickedDate != null) {
                                            final formatted =
                                                "${pickedDate.year}-"
                                                "${pickedDate.month.toString().padLeft(2, '0')}-"
                                                "${pickedDate.day.toString().padLeft(2, '0')}";
                                            form
                                                .control('dueDateOfRepay')
                                                .value = formatted;
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 80),
                                    Center(
                                      child:
                                          state.status == SaveStatus.update ||
                                                  state.status ==
                                                      SaveStatus.edit
                                              ? ElevatedButton.icon(
                                                onPressed:
                                                    () => handleUpdate(
                                                      context,
                                                      state,
                                                    ),
                                                icon: const Icon(
                                                  Icons.save,
                                                  color: Colors.white,
                                                ),
                                                label: const Text(
                                                  'Update',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  // backgroundColor: const Color.fromARGB(
                                                  //   212,
                                                  //   5,
                                                  //   8,
                                                  //   205,
                                                  // ),
                                                  backgroundColor: Colors.teal,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 32,
                                                        vertical: 14,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                ),
                                              )
                                              : ElevatedButton.icon(
                                                onPressed:
                                                    () => handleSave(
                                                      context,
                                                      state,
                                                    ),
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
                                                  backgroundColor: Colors.teal,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 32,
                                                        vertical: 14,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
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
                            if (state.cropData != null)
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
                                    '${state.cropData?.length ?? 0}',
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
