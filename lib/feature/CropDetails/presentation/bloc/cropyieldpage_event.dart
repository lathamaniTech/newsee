part of './cropyieldpage_bloc.dart';

class CropyieldpageEvent {}

class CropPageInitialEvent extends CropyieldpageEvent {
  final String proposalNumber;
  CropPageInitialEvent({required this.proposalNumber});
}

class CropFormSaveEvent extends CropyieldpageEvent {
  final CropDetailsModal cropData;
  CropFormSaveEvent({required this.cropData});
}

class CropDetailsSetEvent extends CropyieldpageEvent {
  final CropDetailsModal cropData;
  CropDetailsSetEvent({required this.cropData});
}

class CropDetailsResetEvent extends CropyieldpageEvent {}

class CropDetailsUpdateEvent extends CropyieldpageEvent {
  final CropDetailsModal cropData;
  final int index;
  CropDetailsUpdateEvent({required this.cropData, required this.index});
}

class CropDetailsSubmitEvent extends CropyieldpageEvent {
  final String proposalNumber;
  final String userid;
  CropDetailsSubmitEvent({required this.proposalNumber, required this.userid});
}

class CropDetailsDeleteEvent extends CropyieldpageEvent {
  final String proposalNumber;
  final String rowId;
  final int index;
  CropDetailsDeleteEvent({
    required this.proposalNumber,
    required this.rowId,
    required this.index,
  });
}

class CropDetailsRemoveEvent extends CropyieldpageEvent {
  final int index;
  CropDetailsRemoveEvent({required this.index});
}
