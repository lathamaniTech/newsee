abstract class CicCheckEvent {
  const CicCheckEvent();
}

class CicFetchEvent extends CicCheckEvent {
  final Map<String, dynamic>? proposalData;
  const CicFetchEvent({this.proposalData});
}
