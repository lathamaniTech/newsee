// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CropModal {
  String? rowId;
  String? season;
  String? cropType;
  String? cropName;
  String? culAreaLand;
  int? culAreaSize;
  String? typeOfLand;
  int? scaOfFin;
  int? addSofByRo;
  int? costOfCul;
  String? covOfCrop;
  String? cropIns;
  int? addSofAmount;
  int? insPre;
  String? dueDateOfRepay;

  CropModal({
    this.rowId,
    this.season,
    this.cropType,
    this.cropName,
    this.culAreaLand,
    this.culAreaSize,
    this.typeOfLand,
    this.scaOfFin,
    this.addSofByRo,
    this.costOfCul,
    this.covOfCrop,
    this.cropIns,
    this.addSofAmount,
    this.insPre,
    this.dueDateOfRepay,
  });

  CropModal copyWith({
    String? rowId,
    String? season,
    String? cropType,
    String? cropName,
    String? culAreaLand,
    int? culAreaSize,
    String? typeOfLand,
    int? scaOfFin,
    int? addSofByRo,
    int? costOfCul,
    String? covOfCrop,
    String? cropIns,
    int? addSofAmount,
    int? insPre,
    String? dueDateOfRepay,
  }) {
    return CropModal(
      rowId: rowId ?? this.rowId,
      season: season ?? this.season,
      cropType: cropType ?? this.cropType,
      cropName: cropName ?? this.cropName,
      culAreaLand: culAreaLand ?? this.culAreaLand,
      culAreaSize: culAreaSize ?? this.culAreaSize,
      typeOfLand: typeOfLand ?? this.typeOfLand,
      scaOfFin: scaOfFin ?? this.scaOfFin,
      addSofByRo: addSofByRo ?? this.addSofByRo,
      costOfCul: costOfCul ?? this.costOfCul,
      covOfCrop: covOfCrop ?? this.covOfCrop,
      cropIns: cropIns ?? this.cropIns,
      addSofAmount: addSofAmount ?? this.addSofAmount,
      insPre: insPre ?? this.insPre,
      dueDateOfRepay: dueDateOfRepay ?? this.dueDateOfRepay,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rowId': rowId ?? '',
      'season': season ?? '',
      'cropType': cropType ?? '',
      'cropName': cropName ?? '',
      'culAreaLand': culAreaLand ?? '',
      'culAreaSize': culAreaSize ?? 0,
      'typeOfLand': typeOfLand ?? '',
      'scaOfFin': scaOfFin ?? 0,
      'addSofByRo': addSofByRo ?? 0,
      'costOfCul': costOfCul ?? 0,
      'covOfCrop': covOfCrop ?? '',
      'cropIns': cropIns ?? '',
      'addSofAmount': addSofAmount ?? 0,
      'insPre': insPre ?? 0,
      'dueDateOfRepay': dueDateOfRepay ?? '',
    };
  }

  factory CropModal.fromMap(Map<String, dynamic> map) {
    return CropModal(
      rowId: map['rowId'] != null ? map['rowId'] as String : null,
      season: map['season'] != null ? map['season'] as String : null,
      cropType: map['cropType'] != null ? map['cropType'] as String : null,
      cropName: map['cropName'] != null ? map['cropName'] as String : null,
      culAreaLand:
          map['culAreaLand'] != null ? map['culAreaLand'] as String : null,
      culAreaSize:
          map['culAreaSize'] != null ? map['culAreaSize'] as int : null,
      typeOfLand:
          map['typeOfLand'] != null ? map['typeOfLand'] as String : null,
      scaOfFin: map['scaOfFin'] != null ? map['scaOfFin'] as int : null,
      addSofByRo: map['addSofByRo'] != null ? map['addSofByRo'] as int : null,
      costOfCul: map['costOfCul'] != null ? map['costOfCul'] as int : null,
      covOfCrop: map['covOfCrop'] != null ? map['covOfCrop'] as String : null,
      cropIns: map['cropIns'] != null ? map['cropIns'] as String : null,
      addSofAmount:
          map['addSofAmount'] != null ? map['addSofAmount'] as int : null,
      insPre: map['insPre'] != null ? map['insPre'] as int : null,
      dueDateOfRepay:
          map['dueDateOfRepay'] != null
              ? map['dueDateOfRepay'] as String
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CropModal.fromJson(String source) =>
      CropModal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CropModal(rowId: $rowId, season: $season, cropType: $cropType, cropName: $cropName, culAreaLand: $culAreaLand, culAreaSize: $culAreaSize, typeOfLand: $typeOfLand, scaOfFin: $scaOfFin, addSofByRo: $addSofByRo, costOfCul: $costOfCul, covOfCrop: $covOfCrop, cropIns: $cropIns, addSofAmount: $addSofAmount, insPre: $insPre, dueDateOfRepay: $dueDateOfRepay)';
  }

  @override
  bool operator ==(covariant CropModal other) {
    if (identical(this, other)) return true;

    return other.rowId == rowId &&
        other.season == season &&
        other.cropType == cropType &&
        other.cropName == cropName &&
        other.culAreaLand == culAreaLand &&
        other.culAreaSize == culAreaSize &&
        other.typeOfLand == typeOfLand &&
        other.scaOfFin == scaOfFin &&
        other.addSofByRo == addSofByRo &&
        other.costOfCul == costOfCul &&
        other.covOfCrop == covOfCrop &&
        other.cropIns == cropIns &&
        other.addSofAmount == addSofAmount &&
        other.insPre == insPre &&
        other.dueDateOfRepay == dueDateOfRepay;
  }

  @override
  int get hashCode {
    return rowId.hashCode ^
        season.hashCode ^
        cropType.hashCode ^
        cropName.hashCode ^
        culAreaLand.hashCode ^
        culAreaSize.hashCode ^
        typeOfLand.hashCode ^
        scaOfFin.hashCode ^
        addSofByRo.hashCode ^
        costOfCul.hashCode ^
        covOfCrop.hashCode ^
        cropIns.hashCode ^
        addSofAmount.hashCode ^
        insPre.hashCode ^
        dueDateOfRepay.hashCode;
  }
}
