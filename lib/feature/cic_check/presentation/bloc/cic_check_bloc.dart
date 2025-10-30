import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/Utils/shared_preference_utils.dart';
import 'package:newsee/feature/auth/domain/model/user_details.dart';
import 'package:newsee/feature/cic_check/data/repository/cic_respository_impl.dart';
import 'package:newsee/feature/cic_check/domain/modals/cic_request.dart';
import 'package:newsee/feature/cic_check/domain/repository/cic_repository.dart';
import 'package:newsee/feature/cic_check/presentation/bloc/cic_check_event.dart';
import 'package:newsee/feature/cic_check/presentation/bloc/cic_check_state.dart';

final class CicCheckBloc extends Bloc<CicCheckEvent, CicCheckState> {
  CicCheckBloc() : super(CicCheckState()) {
    on<CicFetchEvent>(_onSearchCibil);
  }

  Future _onSearchCibil(
    CicFetchEvent event,
    Emitter<CicCheckState> emit,
  ) async {
    emit(state.copyWith(status: CicCheckStatus.loading));
    final req = CICRequest(
      appno: event.proposalData?['propNo'],
      refNo: event.proposalData?['propNo'],
      cbsId: event.proposalData?['cifNo'],
    );
    CicRepository cicRepository = CicRepositoryImpl();
    final response = await cicRepository.searchCibil(req);
    if (response.isRight()) {
      emit(
        state.copyWith(
          status: CicCheckStatus.success,
          cibilResponse: response.right,
          isApplicantCibilCheck: true,
        ),
      );
    } else {
      print('cibil failure response.left ');
      emit(
        state.copyWith(
          status: CicCheckStatus.failure,
          isApplicantCibilCheck: false,
        ),
      );
    }
  }
}
