import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/savelead/domain/repository/model/SourcingDetails.dart';
import 'package:equatable/equatable.dart';

part 'savelead_sourcing_event.dart';
part 'savelead_sourcing_state.dart';

class SaveleadBloc extends Bloc<SaveLeadSourcingEvent, LeadSourcingState> {
  SaveleadBloc(super.initialState) {
    on<SaveleadSourcingSave>(onSourcingDetailsSave);
  }

  Future<void> onSourcingDetailsSave(
    SaveleadSourcingSave event,
    Emitter emit,
  ) async {
    print('onSourcingDetailsSave => $event');
    emit(
      LeadSourcingState(
        status: LeadStatus.loading,
        sourcingdetails: Sourcingdetails(
          businessdescription: 'Retail',
          sourcingchannel: 'Online',
          sourcingid: '1234',
          sourcingname: 'Karthick',
          preferredbranch: 'AMTA',
          leadID: '0001',
        ),
      ),
    );
    Sourcingdetails response = await Future.delayed(
      Duration(seconds: 10),
      () => Sourcingdetails(
        businessdescription: 'Retail',
        sourcingchannel: 'Online',
        sourcingid: '1234',
        sourcingname: 'Karthick',
        preferredbranch: 'AMTA',
        leadID: '0001',
      ),
    );

    emit(
      LeadSourcingState(status: LeadStatus.success, sourcingdetails: response),
    );
  }
}
