import 'package:equatable/equatable.dart';
import 'package:newsee/feature/cic_check/domain/modals/cibil_response_model.dart';

enum CicCheckStatus { initial, loading, success, failure }

class CicCheckState extends Equatable {
  final CicCheckStatus? status;
  final CibilResponse? cibilResponse;
  final bool isApplicantCibilCheck;
  final bool? isCoAppCibilCheck;

  const CicCheckState({
    this.status,
    this.cibilResponse,
    this.isApplicantCibilCheck = false,
    this.isCoAppCibilCheck = false,
  });

  factory CicCheckState.init() =>
      const CicCheckState(status: CicCheckStatus.initial);

  CicCheckState copyWith({
    CicCheckStatus? status,
    CibilResponse? cibilResponse,
    bool? isApplicantCibilCheck,
    bool? isCoAppCibilCheck,
  }) {
    return CicCheckState(
      status: status ?? this.status,
      cibilResponse: cibilResponse ?? this.cibilResponse,
      isApplicantCibilCheck:
          isApplicantCibilCheck ?? this.isApplicantCibilCheck,
      isCoAppCibilCheck: isCoAppCibilCheck ?? this.isCoAppCibilCheck,
    );
  }

  @override
  List<Object?> get props => [
    status,
    cibilResponse,
    isApplicantCibilCheck,
    isCoAppCibilCheck,
  ];
}
