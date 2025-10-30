// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

/// Model class representing the Land Holding request sent to the API.
class LandHoldingRequest {
  String? rowId;
  String? state;
  String? district;
  String? taluk;
  String? village;
  String? surveyNo;
  String? khasraNo;
  String? uccCode;
  String? totAcre;
  String? landType;
  String? particulars;
  String? sourceofIrrigation;
  String? farmDistance;
  String? otherbanks;
  String? farmercategory;
  String? primaryoccupation;
  String? proposalNumber;
  String? sumOfTotalAcreage;
  String? token;

  LandHoldingRequest({
    this.rowId,
    this.state,
    this.district,
    this.taluk,
    this.village,
    this.surveyNo,
    this.khasraNo,
    this.uccCode,
    this.totAcre,
    this.landType,
    this.particulars,
    this.sourceofIrrigation,
    this.farmDistance,
    this.otherbanks,
    this.farmercategory,
    this.primaryoccupation,
    required this.proposalNumber,
    this.sumOfTotalAcreage,
    this.token,
  });

  /// Convert the object into a map for API serialization.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rowId': rowId,
      'state': state,
      'district': district,
      'taluk': taluk,
      'village': village,
      'surveyNo': surveyNo,
      'khasraNo': khasraNo,
      'uccCode': uccCode,
      'totAcre': totAcre,
      'landType': landType,
      'particulars': particulars,
      'sourceofIrrigation': sourceofIrrigation,
      'farmDistance': farmDistance,
      'otherbanks': otherbanks,
      'farmercategory': farmercategory,
      'primaryoccupation': primaryoccupation,
      'proposalNumber': proposalNumber,
      'sumOfTotalAcreage': sumOfTotalAcreage,
      'token': token,
    };
  }

  /// Create an instance from a map (useful for decoding API response).
  factory LandHoldingRequest.fromMap(Map<String, dynamic> map) {
    return LandHoldingRequest(
      rowId: map['rowId']?.toString(),
      state: map['state']?.toString(),
      district: map['district']?.toString(),
      taluk: map['taluk']?.toString(),
      village: map['village']?.toString(),
      surveyNo: map['surveyNo']?.toString(),
      khasraNo: map['khasraNo']?.toString(),
      uccCode: map['uccCode']?.toString(),
      totAcre: map['totAcre']?.toString(),
      landType: map['landType']?.toString(),
      particulars: map['particulars']?.toString(),
      sourceofIrrigation: map['sourceofIrrigation']?.toString(),
      farmDistance: map['farmDistance']?.toString(),
      otherbanks: map['otherbanks']?.toString(),
      farmercategory: map['farmercategory']?.toString(),
      primaryoccupation: map['primaryoccupation']?.toString(),
      proposalNumber: map['proposalNumber']?.toString(),
      sumOfTotalAcreage: map['sumOfTotalAcreage']?.toString(),
      token: map['token']?.toString(),
    );
  }

  /// Convert object to JSON string.
  String toJson() => json.encode(toMap());

  /// Create instance from JSON string.
  factory LandHoldingRequest.fromJson(String source) =>
      LandHoldingRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  LandHoldingRequest copyWith({
    String? rowId,
    String? state,
    String? district,
    String? taluk,
    String? village,
    String? surveyNo,
    String? khasraNo,
    String? uccCode,
    String? totAcre,
    String? landType,
    String? particulars,
    String? sourceofIrrigation,
    String? farmDistance,
    String? otherbanks,
    String? farmercategory,
    String? primaryoccupation,
    String? proposalNumber,
    String? sumOfTotalAcreage,
    String? token,
  }) {
    return LandHoldingRequest(
      rowId: rowId ?? this.rowId,
      state: state ?? this.state,
      district: district ?? this.district,
      taluk: taluk ?? this.taluk,
      village: village ?? this.village,
      surveyNo: surveyNo ?? this.surveyNo,
      khasraNo: khasraNo ?? this.khasraNo,
      uccCode: uccCode ?? this.uccCode,
      totAcre: totAcre ?? this.totAcre,
      landType: landType ?? this.landType,
      particulars: particulars ?? this.particulars,
      sourceofIrrigation: sourceofIrrigation ?? this.sourceofIrrigation,
      farmDistance: farmDistance ?? this.farmDistance,
      otherbanks: otherbanks ?? this.otherbanks,
      farmercategory: farmercategory ?? this.farmercategory,
      primaryoccupation: primaryoccupation ?? this.primaryoccupation,
      proposalNumber: proposalNumber ?? this.proposalNumber,
      sumOfTotalAcreage: sumOfTotalAcreage ?? this.sumOfTotalAcreage,
      token: token ?? this.token,
    );
  }

  @override
  String toString() {
    return 'LandHoldingRequest(rowId: $rowId, state: $state, district: $district, taluk: $taluk, village: $village, surveyNo: $surveyNo, khasraNo: $khasraNo, uccCode: $uccCode, totAcre: $totAcre, landType: $landType, particulars: $particulars, sourceofIrrigation: $sourceofIrrigation, farmDistance: $farmDistance, otherbanks: $otherbanks, farmercategory: $farmercategory, primaryoccupation: $primaryoccupation, proposalNumber: $proposalNumber, sumOfTotalAcreage: $sumOfTotalAcreage, token: $token)';
  }

  @override
  bool operator ==(covariant LandHoldingRequest other) {
    if (identical(this, other)) return true;

    return other.rowId == rowId &&
        other.state == state &&
        other.district == district &&
        other.taluk == taluk &&
        other.village == village &&
        other.surveyNo == surveyNo &&
        other.khasraNo == khasraNo &&
        other.uccCode == uccCode &&
        other.totAcre == totAcre &&
        other.landType == landType &&
        other.particulars == particulars &&
        other.sourceofIrrigation == sourceofIrrigation &&
        other.farmDistance == farmDistance &&
        other.otherbanks == otherbanks &&
        other.farmercategory == farmercategory &&
        other.primaryoccupation == primaryoccupation &&
        other.proposalNumber == proposalNumber &&
        other.sumOfTotalAcreage == sumOfTotalAcreage &&
        other.token == token;
  }

  @override
  int get hashCode {
    return rowId.hashCode ^
        state.hashCode ^
        district.hashCode ^
        taluk.hashCode ^
        village.hashCode ^
        surveyNo.hashCode ^
        khasraNo.hashCode ^
        uccCode.hashCode ^
        totAcre.hashCode ^
        landType.hashCode ^
        particulars.hashCode ^
        sourceofIrrigation.hashCode ^
        farmDistance.hashCode ^
        otherbanks.hashCode ^
        farmercategory.hashCode ^
        primaryoccupation.hashCode ^
        proposalNumber.hashCode ^
        sumOfTotalAcreage.hashCode ^
        token.hashCode;
  }
}
