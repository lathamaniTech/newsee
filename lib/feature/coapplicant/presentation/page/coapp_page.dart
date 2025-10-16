import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/coapplicant/domain/modal/coapplicant_data.dart';
import 'package:newsee/feature/coapplicant/presentation/bloc/coapp_details_bloc.dart';
import 'package:newsee/feature/coapplicant/presentation/widgets/co_applicant_form_sheet.dart';
import 'package:newsee/feature/dedupe/presentation/bloc/dedupe_bloc.dart';
import 'package:newsee/widgets/confirmation_delete_alert.dart';

class CoApplicantPage extends StatefulWidget {
  final String title;

  const CoApplicantPage({super.key, required this.title});

  @override
  State<CoApplicantPage> createState() => _CoApplicantPageState();
}

class _CoApplicantPageState extends State<CoApplicantPage> {
  @override
  void initState() {
    super.initState();
    context.read<CoappDetailsBloc>().add(
      IsCoAppOrGurantorAdd(addapplicants: 'N'),
    );
  }

  Future<void> openCoApplicantFormSheet(
    String type,
    CoapplicantData? selectedData,
    int? index,
  ) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DefaultTabController(
          length: 3,
          child: Builder(
            builder: (tabContext) {
              final tabController = DefaultTabController.of(tabContext);
              return MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: context.read<CoappDetailsBloc>()),
                  BlocProvider(create: (_) => DedupeBloc()),
                ],
                child: DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.95,
                  maxChildSize: 0.95,
                  builder:
                      (_, controller) => Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: CoApplicantFormBottomSheet(
                          tabController: tabController,
                          applicantType: type,
                          existingData: selectedData,
                          index: index,
                        ),
                      ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Co-Applicants/Guarantors"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<CoappDetailsBloc, CoappDetailsState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Whether do you want to add Co-Applicant/Guarantor Details?',
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Y',
                      groupValue: state.isApplicantsAdded,
                      onChanged: (value) {
                        context.read<CoappDetailsBloc>().add(
                          IsCoAppOrGurantorAdd(addapplicants: value),
                        );
                      },
                    ),
                    const Text("Yes"),
                    Radio<String>(
                      value: 'N',
                      groupValue: state.isApplicantsAdded,
                      onChanged: (value) {
                        context.read<CoappDetailsBloc>().add(
                          IsCoAppOrGurantorAdd(addapplicants: value),
                        );
                      },
                    ),
                    const Text("No"),
                  ],
                ),

                if (state.isApplicantsAdded == 'Y' &&
                    state.coAppList.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Added Applicants',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ...state.coAppList.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final CoapplicantData data = entry.value;
                    final String? type = data.applicantType;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text("${data.firstName} ${data.lastName}"),
                            ),
                            Text(
                              "(${type == 'C' ? 'Co-Applicant' : 'Guarantor'})",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          "Mobile Number: ${data.primaryMobileNumber}",
                        ),
                        onTap: () {
                          if (data.customertype == '002' &&
                              (data.cifNumber == null ||
                                  data.cifNumber!.isEmpty)) {
                            context.read<CoappDetailsBloc>().add(
                              CifEditManuallyEvent(false),
                            );
                          } else {
                            context.read<CoappDetailsBloc>().add(
                              CifEditManuallyEvent(true),
                            );
                          }
                          openCoApplicantFormSheet(type!, data, index);
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirmed = await confirmAndDeleteImage(
                              context,
                            );
                            if (confirmed == true) {
                              context.read<CoappDetailsBloc>().add(
                                DeleteCoApplicantEvent(data),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ],
                const Spacer(),
                if (state.isApplicantsAdded == 'N')
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // minimumSize: const Size(double.infinity, 48),
                        backgroundColor: Color.fromARGB(255, 3, 9, 110),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        goToNextTab(context: context);
                      },
                      child: const Text('Next'),
                    ),
                  ),
              ],
            );
          },
        ),
      ),

      floatingActionButton: BlocBuilder<CoappDetailsBloc, CoappDetailsState>(
        builder: (context, state) {
          return state.isApplicantsAdded == 'Y'
              ? Material(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.add, size: 20, color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (String value) {
                    openCoApplicantFormSheet(value, null, null);
                  },
                  itemBuilder:
                      (BuildContext context) => const [
                        PopupMenuItem(
                          value: 'C',
                          child: ListTile(
                            leading: Icon(Icons.person_add),
                            title: Text('Co-Applicant'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'G',
                          child: ListTile(
                            leading: Icon(Icons.person_add),
                            title: Text('Guarantor'),
                          ),
                        ),
                      ],
                ),
              )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
