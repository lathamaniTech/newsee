import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Utils/shared_preference_utils.dart';
import 'package:newsee/feature/auth/domain/model/user_details.dart';
import 'package:newsee/feature/leadInbox/domain/modal/lead_request.dart';
import 'package:newsee/feature/leadInbox/lead_cache_service.dart';
import 'package:newsee/feature/proposal_inbox/data/repository/proposal_inbox_repository_impl.dart';
import 'package:newsee/feature/proposal_inbox/domain/modal/application_status_response.dart';
import 'package:newsee/feature/proposal_inbox/domain/modal/group_proposal_inbox.dart';
import 'package:newsee/feature/proposal_inbox/domain/modal/proposal_inbox_request.dart';
import 'package:newsee/feature/proposal_inbox/domain/modal/proposal_inbox_responce_model.dart';
import 'package:newsee/feature/proposal_inbox/domain/repository/proposal_inbox_repository.dart';

part 'proposal_inbox_event.dart';
part 'proposal_inbox_state.dart';

class ProposalInboxBloc extends Bloc<ProposalInboxEvent, ProposalInboxState> {
  final ProposalInboxRepository proposalInboxRepository;

  ProposalInboxBloc({ProposalInboxRepository? repository})
    : proposalInboxRepository = repository ?? ProposalInboxRepositoryImpl(),
      super(ProposalInboxState()) {
    on<SearchProposalInboxEvent>(onSearchProposalInbox);
    on<ApplicationStatusCheckEvent>(onCheckStatus);
  }

  Future<void> onSearchProposalInbox(
    SearchProposalInboxEvent event,
    Emitter<ProposalInboxState> emit,
  ) async {
    final page = event.request.pageNo;
    // if (state.status == ProposalInboxStatus.success &&
    //     state.currentPage == page &&
    //     event.isRefresh != true) {
    //   return;
    // }

    final cachedProposals = LeadCacheService.getPage('proposal', page);
    if (cachedProposals != null &&
        cachedProposals.isNotEmpty &&
        event.isRefresh != true) {
      final propList =
          (cachedProposals['proposals'] as List).map((list) {
            Map<String, dynamic> map;

            if (list is String) {
              map = json.decode(list) as Map<String, dynamic>;
            } else {
              map = Map<String, dynamic>.from(list);
            }

            if (map.containsKey('finalList') && map['finalList'] is Map) {
              map = Map<String, dynamic>.from(map['finalList']);
            }

            return GroupProposalInbox.fromMap(map);
          }).toList();

      emit(
        state.copyWith(
          status: ProposalInboxStatus.success,
          proposalResponseModel: propList,
          currentPage: page,
          totalProposalApplication: cachedProposals['total'],
        ),
      );
      return;
    }

    await fetchProposalFromApi(event, page, emit);
  }

  Future<void> fetchProposalFromApi(
    SearchProposalInboxEvent event,
    int page,
    Emitter<ProposalInboxState> emit,
  ) async {
    emit(state.copyWith(status: ProposalInboxStatus.loading));

    UserDetails? userDetails = await loadUser();
    LeadInboxRequest request = LeadInboxRequest(
      userid: userDetails!.LPuserID,
      token: ApiConstants.api_qa_token,
      pageNo: event.request.pageNo,
      pageCount: event.request.pageCount,
    );

    final response = await proposalInboxRepository.searchProposalInbox(request);

    if (response.isRight()) {
      final proposals = response.right.proposalDetails;
      emit(
        state.copyWith(
          status: ProposalInboxStatus.success,
          proposalResponseModel: proposals,
          currentPage: page,
          totalProposalApplication: response.right.totalProposals,
        ),
      );
      final propList = (proposals as List).map((e) => e.toJson()).toList();
      await LeadCacheService.savePage('proposal', page, {
        'proposals': propList,
        'total': response.right.totalProposals,
      });
    } else {
      emit(
        state.copyWith(
          status: ProposalInboxStatus.failure,
          errorMessage: response.left.message,
        ),
      );
    }
  }

  // Future<void> onSearchProposalInbox(
  //   SearchProposalInboxEvent event,
  //   Emitter<ProposalInboxState> emit,
  // ) async {
  //   emit(state.copyWith(status: ProposalInboxStatus.loading));
  //   UserDetails? userDetails = await loadUser();
  //   LeadInboxRequest request = LeadInboxRequest(
  //     userid: userDetails!.LPuserID,
  //     token: ApiConstants.api_qa_token,
  //     pageNo: event.request.pageNo,
  //     pageCount: event.request.pageCount,
  //   );

  //   final response = await proposalInboxRepository.searchProposalInbox(request);
  //   // check if response i success and contains valid data , success status is emitted

  //   if (response.isRight()) {
  //     emit(
  //       state.copyWith(
  //         status: ProposalInboxStatus.success,
  //         proposalResponseModel: response.right.proposalDetails,
  //         currentPage: event.request.pageNo,
  //         totalProposalApplication: response.right.totalProposals,
  //       ),
  //     );
  //   } else {
  //     print('Proposal failure response.left');
  //     emit(
  //       state.copyWith(
  //         status: ProposalInboxStatus.failure,
  //         errorMessage: response.left.message,
  //       ),
  //     );
  //   }
  // }

  Future<void> onCheckStatus(
    ApplicationStatusCheckEvent event,
    Emitter emit,
  ) async {
    try {
      emit(state.copyWith(applicationStatus: SaveStatus.loading));
      final req = {
        'proposalNumber': event.currentApplication['propNo'],
        'token': ApiConstants.api_qa_token,
      };
      final response = await proposalInboxRepository.getApplicationStatus(req);
      if (response.isRight()) {
        emit(
          state.copyWith(
            applicationStatus: SaveStatus.success,
            applicationStatusResponse: response.right,
            currentApplication: event.currentApplication,
          ),
        );
        Future.delayed(Duration(seconds: 1));
        emit(state.copyWith(applicationStatus: SaveStatus.update));
      } else {
        print('Proposal failure response.left');
        emit(
          state.copyWith(
            applicationStatus: SaveStatus.failure,
            errorMessage: response.left.message,
            currentApplication: event.currentApplication,
          ),
        );
        Future.delayed(Duration(seconds: 1));
        emit(state.copyWith(applicationStatus: SaveStatus.update));
      }
    } catch (error) {
      print("onCheckStatus-error $error");
      emit(state.copyWith(applicationStatus: SaveStatus.failure));
      Future.delayed(Duration(seconds: 1));
      emit(state.copyWith(applicationStatus: SaveStatus.update));
    }
  }
}
