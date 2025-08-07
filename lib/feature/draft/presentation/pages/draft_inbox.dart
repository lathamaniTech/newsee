import 'package:flutter/material.dart';
import 'package:newsee/feature/draft/domain/draft_lead_model.dart';
import 'package:newsee/feature/draft/draft_service.dart';
import 'package:newsee/widgets/lead_tile_card.dart';
import 'package:number_paginator/number_paginator.dart';

class DraftInbox extends StatefulWidget {
  const DraftInbox({super.key});

  @override
  State<DraftInbox> createState() => _DraftLeadPageState();
}

class _DraftLeadPageState extends State<DraftInbox> {
  final DraftService draftService = DraftService();
  List<DraftLead> allDrafts = [];
  int currentPage = 0;
  int pageSize = 10;

  @override
  void initState() {
    super.initState();
    loadDrafts();
  }

  Future<void> loadDrafts() async {
    final refs = await draftService.getAllDraftLeadRefs();
    final List<DraftLead> loaded = [];
    print('leads: $refs');
    for (var ref in refs) {
      final draft = await draftService.getDraft(ref);
      if (draft != null) loaded.add(draft);
    }

    setState(() {
      allDrafts = loaded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final paginatedDrafts =
        allDrafts.skip(currentPage * pageSize).take(pageSize).toList();
    final numberOfPages = (allDrafts.length / pageSize).ceil();

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: loadDrafts, // Pull-to-refresh triggers this
            child: ListView.builder(
              itemCount: paginatedDrafts.length,
              itemBuilder: (context, index) {
                final draft = paginatedDrafts[index];

                return LeadTileCard(
                  title: draft.personal['firstName'] ?? 'N/A',
                  subtitle: draft.leadref,
                  icon: Icons.person,
                  color: Colors.teal,
                  type:
                      draft.dedupe['existingCustomer'] == 'N'
                          ? 'New Customer'
                          : 'Existing Customer',
                  product:
                      draft.loan['selectedProductScheme']['optionDesc'] ??
                      'N/A',
                  phone: draft.personal['primaryMobileNumber'] ?? 'N/A',
                  ennablePhoneTap: true,
                  createdon: draft.personal['dob'] ?? 'N/A',
                  location: draft.address['state'] ?? 'N/A',
                  loanamount:
                      draft.personal['loanAmountRequested']?.toString() ?? '',
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      '/resume-lead',
                      arguments: draft.leadref,
                    );
                    loadDrafts(); // Reload when coming back
                  },
                  showarrow: false,
                );
              },
            ),
          ),
        ),
        if (numberOfPages > 1)
          Padding(
            padding: const EdgeInsets.all(5),
            child: NumberPaginator(
              numberPages: numberOfPages,
              initialPage: currentPage,
              onPageChange: (int index) {
                setState(() {
                  currentPage = index;
                });
              },
              child: const SizedBox(
                width: 250,
                height: 35,
                child: Row(
                  children: [
                    PrevButton(),
                    Expanded(child: NumberContent()),
                    NextButton(),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
