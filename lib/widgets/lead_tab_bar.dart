/*
 @created on : May 7,2025
 @author : Akshayaa 
 Description : Custom widget for displaying tabs for Pending and Completed Leads
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/draft/presentation/pages/draft_inbox.dart';
import 'package:newsee/feature/leadInbox/domain/modal/lead_request.dart';
import 'package:newsee/feature/leadInbox/presentation/bloc/lead_bloc.dart';
import 'package:newsee/feature/leadInbox/presentation/page/completed_leads.dart';
import 'package:newsee/feature/proposal_inbox/presentation/bloc/proposal_inbox_bloc.dart';
import 'package:newsee/feature/proposal_inbox/presentation/page/proposal_inbox_leads.dart';
import 'package:newsee/widgets/performance_view.dart';
import 'package:shake/shake.dart';
import 'pending_leads.dart';

class LeadTabBar extends StatefulWidget {
  final String searchQuery;
  final TabController? tabController;
  final bool? initLeads;

  const LeadTabBar({
    super.key,
    required this.searchQuery,
    this.tabController,
    this.initLeads,
  });

  @override
  State<LeadTabBar> createState() => _LeadTabBarState();
}

class _LeadTabBarState extends State<LeadTabBar> {
  ShakeDetector? detector;

  @override
  void initState() {
    super.initState();

    detector = ShakeDetector.autoStart(
      onPhoneShake: (_) => showPerformanceModal(),
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeThresholdGravity: 2.7,
    );
  }

  @override
  void dispose() {
    detector?.stopListening();
    super.dispose();
  }

  void showPerformanceModal() {
    showModalBottomSheet(
      context: context,
      builder: (_) => const PerformanceView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  LeadBloc()..add(
                    SearchLeadEvent(isRefresh: widget.initLeads ?? false),
                  ),
        ),
        BlocProvider(
          create:
              (_) =>
                  ProposalInboxBloc()..add(
                    SearchProposalInboxEvent(
                      request: LeadInboxRequest(userid: '', token: ''),
                      isRefresh: widget.initLeads ?? false,
                    ),
                  ),
        ),
      ],
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              color: Colors.teal,
              child: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: "Leads"),
                  Tab(text: "Draft"),
                  Tab(text: "Applications"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  CompletedLeads(searchQuery: widget.searchQuery),
                  DraftInbox(),
                  ProposalInbox(searchQuery: widget.searchQuery),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
