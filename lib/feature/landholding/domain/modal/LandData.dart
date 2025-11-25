// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:equatable/equatable.dart';

class LandData extends Equatable {
  final int? lklRowid;
  final int? lslPropNo;
  final String? lklApplicantName;
  final String? lslLandState;
  final String? lslLandDistrict;
  final String? lklTaluk;
  final String? lklVillage;
  final String? lklSurveyNo;
  final String? lklKhasraNo;
  final String? lklUccCode;
  final String? lklTotAcre;
  final String? lklLandType;
  final String? lklParticulars;
  final String? lklSourceofIrrigation;
  final int? lklFarmDistance;
  final String? lklLandIrriFaci;
  final String? lklsumOfTotalAcreage;
  final String? lklfarmercategory;
  final String? lklfarmertype;
  final String? lklprimaryoccupation;
  final String? lklotherbanks;

  const LandData({
    this.lklRowid,
    this.lslPropNo,
    this.lklApplicantName,
    this.lslLandState,
    this.lslLandDistrict,
    this.lklTaluk,
    this.lklVillage,
    this.lklSurveyNo,
    this.lklKhasraNo,
    this.lklUccCode,
    this.lklTotAcre,
    this.lklLandType,
    this.lklParticulars,
    this.lklSourceofIrrigation,
    this.lklFarmDistance,
    this.lklLandIrriFaci,
    this.lklsumOfTotalAcreage,
    this.lklfarmercategory,
    this.lklfarmertype,
    this.lklprimaryoccupation,
    this.lklotherbanks,
  });

  @override
  List<Object?> get props => [
    lklRowid,
    lslPropNo,
    lklApplicantName,
    lslLandState,
    lslLandDistrict,
    lklTaluk,
    lklVillage,
    lklSurveyNo,
    lklKhasraNo,
    lklUccCode,
    lklTotAcre,
    lklLandType,
    lklParticulars,
    lklSourceofIrrigation,
    lklFarmDistance,
    lklLandIrriFaci,
    lklsumOfTotalAcreage,
    lklfarmercategory,
    lklfarmertype,
    lklprimaryoccupation,
    lklotherbanks,
  ];

  LandData copyWith({
    int? lklRowid,
    int? lslPropNo,
    String? lklApplicantName,
    String? lslLandState,
    String? lslLandDistrict,
    String? lklTaluk,
    String? lklVillage,
    String? lklSurveyNo,
    String? lklKhasraNo,
    String? lklUccCode,
    String? lklTotAcre,
    String? lklLandType,
    String? lklParticulars,
    String? lklSourceofIrrigation,
    int? lklFarmDistance,
    String? lklLandIrriFaci,
    String? lklsumOfTotalAcreage,
    String? lklfarmercategory,
    String? lklfarmertype,
    String? lklprimaryoccupation,
    String? lklotherbanks,
  }) {
    return LandData(
      lklRowid: lklRowid ?? this.lklRowid,
      lslPropNo: lslPropNo ?? this.lslPropNo,
      lklApplicantName: lklApplicantName ?? this.lklApplicantName,
      lslLandState: lslLandState ?? this.lslLandState,
      lslLandDistrict: lslLandDistrict ?? this.lslLandDistrict,
      lklTaluk: lklTaluk ?? this.lklTaluk,
      lklVillage: lklVillage ?? this.lklVillage,
      lklSurveyNo: lklSurveyNo ?? this.lklSurveyNo,
      lklKhasraNo: lklKhasraNo ?? this.lklKhasraNo,
      lklUccCode: lklUccCode ?? this.lklUccCode,
      lklTotAcre: lklTotAcre ?? this.lklTotAcre,
      lklLandType: lklLandType ?? this.lklLandType,
      lklParticulars: lklParticulars ?? this.lklParticulars,
      lklSourceofIrrigation:
          lklSourceofIrrigation ?? this.lklSourceofIrrigation,
      lklFarmDistance: lklFarmDistance ?? this.lklFarmDistance,
      lklLandIrriFaci: lklLandIrriFaci ?? this.lklLandIrriFaci,
      lklsumOfTotalAcreage: lklsumOfTotalAcreage ?? this.lklsumOfTotalAcreage,
      lklfarmercategory: lklfarmercategory ?? this.lklfarmercategory,
      lklfarmertype: lklfarmertype ?? this.lklfarmertype,
      lklprimaryoccupation: lklprimaryoccupation ?? this.lklprimaryoccupation,
      lklotherbanks: lklotherbanks ?? this.lklotherbanks,
    );
  }

  Map<String, dynamic> mapForm() {
    return {
      'rowId': lklRowid != null ? lklRowid?.toString() : '',
      'applicantName': lklApplicantName,
      'state': lslLandState,
      'district': lslLandDistrict,
      'taluk': lklTaluk,
      'village': lklVillage,
      'surveyNo': lklSurveyNo,
      'khasraNo': lklKhasraNo,
      'uccCode': lklUccCode,
      'totAcre': lklTotAcre?.toString(),
      'landType': lklLandType,
      'particulars': lklParticulars,
      'sourceofIrrig': lklSourceofIrrigation,
      'farmDistance':
          lklFarmDistance != null ? lklFarmDistance?.toString() : '',
      'farmercategory': lklfarmercategory,
      'primaryoccupation': lklprimaryoccupation,
      'sumOfTotalAcreage': lklsumOfTotalAcreage,
      'otherbanks': lklotherbanks == 'Y' ? true : false,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'lklRowid': lklRowid,
      'lslPropNo': lslPropNo,
      'lklApplicantName': lklApplicantName,
      'lslLandState': lslLandState,
      'lslLandDistrict': lslLandDistrict,
      'lklTaluk': lklTaluk,
      'lklVillage': lklVillage,
      'lklSurveyNo': lklSurveyNo,
      'lklKhasraNo': lklKhasraNo,
      'lklUccCode': lklUccCode,
      'lklTotAcre': lklTotAcre,
      'lklLandType': lklLandType,
      'lklParticulars': lklParticulars,
      'lklSourceofIrrigation': lklSourceofIrrigation,
      'lklFarmDistance': lklFarmDistance,
      'lklLandIrriFaci': lklLandIrriFaci,
      'lklsumOfTotalAcreage': lklsumOfTotalAcreage,
      'lklfarmercategory': lklfarmercategory,
      'lklfarmertype': lklfarmertype,
      'lklprimaryoccupation': lklprimaryoccupation,
      'lklotherbanks': lklotherbanks,
    };
  }

  factory LandData.fromMap(Map<String, dynamic> map) {
    return LandData(
      lklRowid: map['lklRowid'] != null ? map['lklRowid'] as int : null,
      lslPropNo: map['lslPropNo'] != null ? map['lslPropNo'] as int : null,
      lklApplicantName: map['lklApplicantName'] as String?,
      lslLandState: map['lslLandState'] as String?,
      lslLandDistrict: map['lslLandDistrict'] as String?,
      lklTaluk: map['lklTaluk'] as String?,
      lklVillage: map['lklVillage'] as String?,
      lklSurveyNo: map['lklSurveyNo'] as String?,
      lklKhasraNo: map['lklKhasraNo'] as String?,
      lklUccCode: map['lklUccCode'] as String?,
      lklTotAcre:
          map['lklTotAcre'] != null ? map['lklTotAcre'] as String : null,
      lklLandType: map['lklLandType'] as String?,
      lklParticulars: map['lklParticulars'] as String?,
      lklSourceofIrrigation: map['lklSourceofIrrigation'] as String?,
      lklFarmDistance:
          map['lklFarmDistance'] != null ? map['lklFarmDistance'] as int : null,
      lklLandIrriFaci: map['lklLandIrriFaci'] as String?,
      lklsumOfTotalAcreage: map['lklsumOfTotalAcreage'] as String?,
      lklfarmercategory: map['lklfarmercategory'] as String?,
      lklfarmertype: map['lklfarmertype'] as String?,
      lklprimaryoccupation: map['lklprimaryoccupation'] as String?,
      lklotherbanks: map['lklotherbanks'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory LandData.fromJson(String source) =>
      LandData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
