part of 'savelead_sourcing_bloc.dart';

/* 

@author     : karthick.d  19/05/2025
@desc       : save - sourcing details { LeadSourcingState }
@param      : enum Lead Status for different state and sourcingdetails dataclass object

 */
enum LeadStatus { init, loading, success, failure }

final class LeadSourcingState extends Equatable {
  LeadStatus? status;
  Sourcingdetails? sourcingdetails;

  LeadSourcingState({required this.status, required this.sourcingdetails});

  /*   LeadSourcingState.initial(LeadStatus status, Sourcingdetails sourcingdetails)
    : status = LeadStatus.init,
      sourcingdetails = sourcingdetails;

 */
  @override
  List<Object?> get props => [status, sourcingdetails];
}

final class LeadSourcingInitState extends LeadSourcingState {
  LeadSourcingInitState({
    required super.status,
    required super.sourcingdetails,
  });
}
