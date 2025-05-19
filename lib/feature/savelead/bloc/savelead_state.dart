import 'package:equatable/equatable.dart';
import 'package:newsee/feature/savelead/repository/model/SourcingDetails.dart';

enum LeadStatus { init, loading, success, failure }

final class LeadSourcingState extends Equatable {
  final LeadStatus status;
  final Sourcingdetails sourcingdetails;

  LeadSourcingState(this.status, this.sourcingdetails);

  @override
  List<Object?> get props => [status, sourcingdetails];
}
