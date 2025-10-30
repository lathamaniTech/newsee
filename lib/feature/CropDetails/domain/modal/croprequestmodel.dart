// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:newsee/feature/CropDetails/domain/modal/cropmodel.dart';

class CropRequestModel {
  int? proposalNumber;
  String? userid;
  int? totalcostCultivation;
  int? totalSofamt;
  int? totalInsurprem;
  List<CropModal>? cropDetailList;
  String? token;

  CropRequestModel({
    this.proposalNumber,
    this.userid,
    this.totalcostCultivation,
    this.totalSofamt,
    this.totalInsurprem,
    this.cropDetailList,
    this.token,
  });

  CropRequestModel copyWith({
    int? proposalNumber,
    String? userid,
    int? totalcostCultivation,
    int? totalSofamt,
    int? totalInsurprem,
    List<CropModal>? cropDetailList,
    String? token,
  }) {
    return CropRequestModel(
      proposalNumber: proposalNumber ?? this.proposalNumber,
      userid: userid ?? this.userid,
      totalcostCultivation: totalcostCultivation ?? this.totalcostCultivation,
      totalSofamt: totalSofamt ?? this.totalSofamt,
      totalInsurprem: totalInsurprem ?? this.totalInsurprem,
      cropDetailList: cropDetailList ?? this.cropDetailList,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'proposalNumber': proposalNumber,
      'userid': userid,
      'totalcostCultivation': totalcostCultivation,
      'totalSofamt': totalSofamt,
      'totalInsurprem': totalInsurprem,
      'cropDetailList': cropDetailList?.map((x) => x.toMap()).toList(),
      'token': token,
    };
  }

  factory CropRequestModel.fromMap(Map<String, dynamic> map) {
    return CropRequestModel(
      proposalNumber:
          map['proposalNumber'] != null ? map['proposalNumber'] as int : null,
      userid: map['userid'] != null ? map['userid'] as String : null,
      totalcostCultivation:
          map['totalcostCultivation'] != null
              ? map['totalcostCultivation'] as int
              : null,
      totalSofamt:
          map['totalSofamt'] != null ? map['totalSofamt'] as int : null,
      totalInsurprem:
          map['totalInsurprem'] != null ? map['totalInsurprem'] as int : null,
      cropDetailList:
          map['cropDetailList'] != null
              ? List<CropModal>.from(
                (map['cropDetailList'] as List<dynamic>).map(
                  (x) => CropModal.fromMap(x as Map<String, dynamic>),
                ),
              )
              : null,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CropRequestModel.fromJson(String source) =>
      CropRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CropRequestModel(proposalNumber: $proposalNumber, userid: $userid, totalcostCultivation: $totalcostCultivation, totalSofamt: $totalSofamt, totalInsurprem: $totalInsurprem, cropDetailList: $cropDetailList, token: $token)';
  }

  @override
  bool operator ==(covariant CropRequestModel other) {
    if (identical(this, other)) return true;

    return other.proposalNumber == proposalNumber &&
        other.userid == userid &&
        other.totalcostCultivation == totalcostCultivation &&
        other.totalSofamt == totalSofamt &&
        other.totalInsurprem == totalInsurprem &&
        listEquals(other.cropDetailList, cropDetailList) &&
        other.token == token;
  }

  @override
  int get hashCode {
    return proposalNumber.hashCode ^
        userid.hashCode ^
        totalcostCultivation.hashCode ^
        totalSofamt.hashCode ^
        totalInsurprem.hashCode ^
        cropDetailList.hashCode ^
        token.hashCode;
  }
}
