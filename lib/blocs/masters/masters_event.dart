abstract class MastersEvent {}

//UpdateMaster: Tells the bloc to fetch and update a master type.

class UpdateMaster extends MastersEvent {
  final String type;
  final bool isChained;

  UpdateMaster(this.type, {this.isChained = false});
}
