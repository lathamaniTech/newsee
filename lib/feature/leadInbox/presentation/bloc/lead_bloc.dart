/* 
  @author     : gayathri.b 12/06/2025
  @desc       : BLoC class that encapsulates business logic for lead search feature.
                Listens to LeadEvent events and emits updated LeadState based on repository responses.
  @param      : LeadEvent, LeadState
*/

import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Utils/shared_preference_utils.dart';
import 'package:newsee/feature/auth/domain/model/user_details.dart';
import 'package:newsee/feature/leadInbox/data/repository/lead_respository_impl.dart';
import 'package:newsee/feature/leadInbox/domain/modal/get_lead_response.dart';
import 'package:newsee/feature/leadInbox/domain/modal/group_lead_inbox.dart';
import 'package:newsee/feature/leadInbox/domain/modal/lead_request.dart';
import 'package:newsee/feature/leadInbox/domain/repository/lead_repository.dart';
import 'package:newsee/feature/leadInbox/lead_cache_service.dart';
import 'package:newsee/feature/leadsubmit/data/repository/proposal_repo_impl.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/proposal_creation_request.dart';

part 'lead_event.dart';
part 'lead_state.dart';

class LeadBloc extends Bloc<LeadEvent, LeadState> {
  final LeadRepository leadRepository;

  LeadBloc({LeadRepository? repository})
    : leadRepository = repository ?? LeadRepositoryImpl(),
      super(LeadState()) {
    on<SearchLeadEvent>(onSearchLead);
    on<CreateProposalLeadEvent>(onCreateProposalRequest);
    on<GetLeadDataEvent>(onGetLeadData);
  }

  Future<void> onSearchLead(
    SearchLeadEvent event,
    Emitter<LeadState> emit,
  ) async {
    final page = event.pageNo;
    print('pageno: $page, ${state.currentPage}, ${event.isRefresh}');

    // if (state.status == LeadStatus.success &&
    //     state.currentPage == page &&
    //     event.isRefresh != true) {
    //   return;
    // }

    final cachedLeads = LeadCacheService.getPage('lead', page);

    if (cachedLeads != null &&
        cachedLeads.isNotEmpty &&
        event.isRefresh != true) {
      print('cachedLeads $cachedLeads');
      final leadsList =
          (cachedLeads['leads'] as List).map((list) {
            Map<String, dynamic> map;

            if (list is String) {
              map = json.decode(list) as Map<String, dynamic>;
            } else {
              map = Map<String, dynamic>.from(list);
            }

            if (map.containsKey('finalList') && map['finalList'] is Map) {
              map = Map<String, dynamic>.from(map['finalList']);
            }

            return GroupLeadInbox.fromMap(map);
          }).toList();

      emit(
        state.copyWith(
          status: LeadStatus.success,
          leadResponseModel: leadsList,
          currentPage: page,
          totApplication: cachedLeads['total'],
          fromCache: true,
        ),
      );
      return;
    }

    await fetchFromApi(page, event.pageCount, emit);
  }

  Future<void> fetchFromApi(
    int page,
    int pageCount,
    Emitter<LeadState> emit,
  ) async {
    print('searajh');
    try {
      emit(state.copyWith(status: LeadStatus.loading));

      UserDetails? userDetails = await loadUser();
      LeadInboxRequest request = LeadInboxRequest(
        userid: userDetails!.LPuserID,
        pageNo: page,
        pageCount: pageCount,
        token: ApiConstants.api_qa_token,
      );

      final response = await leadRepository.searchLead(request);

      if (response.isRight()) {
        final leads = response.right.listOfApplication;
        print('leads $leads');
        emit(
          state.copyWith(
            status: LeadStatus.success,
            leadResponseModel: leads,
            currentPage: page,
            totApplication: response.right.totalApplication,
            fromCache: false,
          ),
        );
        final leadsList = (leads as List).map((e) => e.toJson()).toList();
        await LeadCacheService.savePage('lead', page, {
          'leads': leadsList,
          'total': response.right.totalApplication,
        });
      } else {
        emit(
          state.copyWith(
            currentPage: page,
            status: LeadStatus.failure,
            errorMessage: response.left.message,
          ),
        );
      }
    } catch (e) {
      print('searchLeads: $e');
    }
  }

  // Future<void> onSearchLead(
  //   SearchLeadEvent event,
  //   Emitter<LeadState> emit,
  // ) async {
  //   emit(state.copyWith(status: LeadStatus.loading));
  //   UserDetails? userDetails = await loadUser();
  //   LeadInboxRequest request = LeadInboxRequest(
  //     userid: userDetails!.LPuserID,
  //     pageNo: event.pageNo,
  //     pageCount: event.pageCount,
  //     token: ApiConstants.api_qa_token,
  //   );

  //   final response = await leadRepository.searchLead(request);
  //   // check if response i success and contains valid data , success status is emitted

  //   if (response.isRight()) {
  //     emit(
  //       state.copyWith(
  //         status: LeadStatus.success,
  //         leadResponseModel: response.right.listOfApplication,
  //         currentPage: event.pageNo,
  //         totApplication: response.right.totalApplication,
  //       ),
  //     );
  //   } else {
  //     print('Lead failure response.left');
  //     emit(
  //       state.copyWith(
  //         currentPage: event.pageNo,
  //         status: LeadStatus.failure,
  //         errorMessage: response.left.message,
  //       ),
  //     );
  //   }
  // }

  Future<void> onCreateProposalRequest(
    CreateProposalLeadEvent event,
    Emitter emit,
  ) async {
    try {
      emit(state.copyWith(proposalSubmitStatus: SaveStatus.loading));
      UserDetails? userdetails = await loadUser();

      ProposalCreationRequest proposalCreationRequest = ProposalCreationRequest(
        leadId: event.leadId,
        userid: userdetails?.LPuserID,
        vertical: '7',
        token: ApiConstants.api_qa_token,
      );
      print('proposalCreationRequest => $proposalCreationRequest');

      final responseHandler = await ProposalRepoImpl().submitProposal(
        request: proposalCreationRequest,
      );
      if (responseHandler.isRight()) {
        final response = responseHandler.right;
        String proposalNumber =
            response[ApiConstants.api_response_proposalNumber];
        emit(
          state.copyWith(
            proposalNo: proposalNumber,
            proposalSubmitStatus: SaveStatus.success,
          ),
        );
      } else {
        emit(state.copyWith(proposalSubmitStatus: SaveStatus.failure));
      }

      Future.delayed(Duration(seconds: 1));
      emit(state.copyWith(proposalSubmitStatus: SaveStatus.reset));
    } on Exception catch (e) {
      print('Proposal Creation Request Error => $e');
      emit(state.copyWith(proposalSubmitStatus: SaveStatus.failure));
    }
  }

  Future<void> onGetLeadData(GetLeadDataEvent event, Emitter emit) async {
    try {
      emit(state.copyWith(getLeaStatus: SaveStatus.loading));
      final req = {'LeadId': event.leadId, 'token': ApiConstants.api_qa_token};
      final response = await leadRepository.getLeadData(req);

      if (response.isRight()) {
        emit(
          state.copyWith(
            getLeaStatus: SaveStatus.success,
            getleadData: response.right,
          ),
        );
      } else {
        emit(
          state.copyWith(
            getLeaStatus: SaveStatus.failure,
            errorMessage: response.left.message,
          ),
        );
      }

      Future.delayed(Duration(seconds: 2));
      emit(state.copyWith(getLeaStatus: SaveStatus.update));
    } catch (error) {
      print('Proposal Creation Request Error => $error');
      emit(
        state.copyWith(
          getLeaStatus: SaveStatus.failure,
          errorMessage: error.toString(),
        ),
      );
      Future.delayed(Duration(seconds: 2));
      emit(state.copyWith(getLeaStatus: SaveStatus.update));
    }
  }
}
