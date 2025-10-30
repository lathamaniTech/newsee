// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

class CropDetailsModal {
  int? lcdRowId;
  int? lcdProposalNo;
  String? lcdSeason;
  String? lcdCropType;
  String? lcdCropName;
  String? lcdCulAreaLand;
  int? lcdCulAreaSize;
  String? lcdTypeOfLand;
  int? lcdScaOfFin;
  int? lcdAddSofByRo;
  int? lcdCostOfCul;
  String? lcdCovOfCrop;
  String? lcdCropIns;
  int? lcdAddSofAmount;
  int? lcdInsPre;
  String? lcdDueDateOfRepay;

  CropDetailsModal({
    this.lcdRowId,
    this.lcdProposalNo,
    this.lcdSeason,
    this.lcdCropType,
    this.lcdCropName,
    this.lcdCulAreaLand,
    this.lcdCulAreaSize,
    this.lcdTypeOfLand,
    this.lcdScaOfFin,
    this.lcdAddSofByRo,
    this.lcdCostOfCul,
    this.lcdCovOfCrop,
    this.lcdCropIns,
    this.lcdAddSofAmount,
    this.lcdInsPre,
    this.lcdDueDateOfRepay,
  });

  CropDetailsModal copyWith({
    int? lcdRowId,
    int? lcdProposalNo,
    String? lcdSeason,
    String? lcdCropType,
    String? lcdCropName,
    String? lcdCulAreaLand,
    int? lcdCulAreaSize,
    String? lcdTypeOfLand,
    int? lcdScaOfFin,
    int? lcdAddSofByRo,
    int? lcdCostOfCul,
    String? lcdCovOfCrop,
    String? lcdCropIns,
    int? lcdAddSofAmount,
    int? lcdInsPre,
    String? lcdDueDateOfRepay,
  }) {
    return CropDetailsModal(
      lcdRowId: lcdRowId ?? this.lcdRowId,
      lcdProposalNo: lcdProposalNo ?? this.lcdProposalNo,
      lcdSeason: lcdSeason ?? this.lcdSeason,
      lcdCropType: lcdCropType ?? this.lcdCropType,
      lcdCropName: lcdCropName ?? this.lcdCropName,
      lcdCulAreaLand: lcdCulAreaLand ?? this.lcdCulAreaLand,
      lcdCulAreaSize: lcdCulAreaSize ?? this.lcdCulAreaSize,
      lcdTypeOfLand: lcdTypeOfLand ?? this.lcdTypeOfLand,
      lcdScaOfFin: lcdScaOfFin ?? this.lcdScaOfFin,
      lcdAddSofByRo: lcdAddSofByRo ?? this.lcdAddSofByRo,
      lcdCostOfCul: lcdCostOfCul ?? this.lcdCostOfCul,
      lcdCovOfCrop: lcdCovOfCrop ?? this.lcdCovOfCrop,
      lcdCropIns: lcdCropIns ?? this.lcdCropIns,
      lcdAddSofAmount: lcdAddSofAmount ?? this.lcdAddSofAmount,
      lcdInsPre: lcdInsPre ?? this.lcdInsPre,
      lcdDueDateOfRepay: lcdDueDateOfRepay ?? this.lcdDueDateOfRepay,
    );
  }

  /// Converts this object into a form-friendly Map (string values preferred)
  Map<String, dynamic> toForm() {
    return <String, dynamic>{
      'rowId': lcdRowId?.toString(),
      'season': lcdSeason,
      'cropType': lcdCropType,
      'cropName': lcdCropName,
      'covOfCrop': lcdCovOfCrop,
      'typeOfLand': lcdTypeOfLand,
      'culAreaLand': lcdCulAreaLand,
      'culAreaSize': lcdCulAreaSize?.toString(),
      'scaOfFin': lcdScaOfFin?.toString(),
      'addSofByRo': lcdAddSofByRo?.toString(),
      'addSofAmount': lcdAddSofAmount?.toString(),
      'costOfCul': lcdCostOfCul?.toString(),
      'cropIns': lcdCropIns,
      'insPre': lcdInsPre?.toString(),
      'dueDateOfRepay': lcdDueDateOfRepay,
    };
  }

  /// Creates a modal instance from a form map (all dynamic values)
  factory CropDetailsModal.fromForm(Map<String, dynamic> form) {
    return CropDetailsModal(
      lcdRowId: _toInt(form['rowId']),
      lcdSeason: form['season']?.toString(),
      lcdCropType: form['cropType']?.toString(),
      lcdCropName: form['cropName']?.toString(),
      lcdCovOfCrop: form['covOfCrop']?.toString(),
      lcdTypeOfLand: form['typeOfLand']?.toString(),
      lcdCulAreaLand: form['culAreaLand']?.toString(),
      lcdCulAreaSize: _toInt(form['culAreaSize']),
      lcdScaOfFin: _toInt(form['scaOfFin']),
      lcdAddSofByRo: _toInt(form['addSofByRo']),
      lcdAddSofAmount: _toInt(form['addSofAmount']),
      lcdCostOfCul: _toInt(form['costOfCul']),
      lcdCropIns: form['cropIns']?.toString(),
      lcdInsPre: _toInt(form['insPre']),
      lcdDueDateOfRepay: form['dueDateOfRepay']?.toString(),
    );
  }

  /// Factory for API response mapping
  factory CropDetailsModal.fromGetApi(Map<String, dynamic> map) {
    return CropDetailsModal(
      lcdRowId: _toInt(map['lcdRowId']),
      lcdProposalNo: _toInt(map['lcdProposalNo']),
      lcdSeason: map['lcdSeason']?.toString(),
      lcdCropType: map['lcdCropType']?.toString(),
      lcdCropName: map['lcdCropName']?.toString(),
      lcdTypeOfLand: map['lcdTypeOfLand']?.toString(),
      lcdCulAreaLand: map['lcdCulAreaLand']?.toString(),
      lcdCulAreaSize: _toInt(map['lcdCulAreaSize']),
      lcdAddSofByRo: _toInt(map['lcdAddSofByRo']),
      lcdAddSofAmount: _toInt(map['lcdAddSofAmount']),
      lcdCostOfCul: _toInt(map['lcdCostOfCul']),
      lcdCovOfCrop: map['lcdCovOfCrop']?.toString(),
      lcdCropIns: map['lcdCropIns']?.toString(),
      lcdInsPre: _toInt(map['lcdInsPre']),
      lcdDueDateOfRepay: map['lcdDueDateOfRepay']?.toString(),
      lcdScaOfFin: _toInt(map['lcdScaOfFin']),
    );
  }

  /// Converts this object into a database or JSON-friendly map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lcdRowId': lcdRowId,
      'lcdProposalNo': lcdProposalNo,
      'lcdSeason': lcdSeason,
      'lcdCropType': lcdCropType,
      'lcdCropName': lcdCropName,
      'lcdCulAreaLand': lcdCulAreaLand,
      'lcdCulAreaSize': lcdCulAreaSize,
      'lcdTypeOfLand': lcdTypeOfLand,
      'lcdScaOfFin': lcdScaOfFin,
      'lcdAddSofByRo': lcdAddSofByRo,
      'lcdCostOfCul': lcdCostOfCul,
      'lcdCovOfCrop': lcdCovOfCrop,
      'lcdCropIns': lcdCropIns,
      'lcdAddSofAmount': lcdAddSofAmount,
      'lcdInsPre': lcdInsPre,
      'lcdDueDateOfRepay': lcdDueDateOfRepay,
    };
  }

  factory CropDetailsModal.fromMap(Map<String, dynamic> map) {
    return CropDetailsModal(
      lcdRowId: _toInt(map['lcdRowId']),
      lcdProposalNo: _toInt(map['lcdProposalNo']),
      lcdSeason: map['lcdSeason']?.toString(),
      lcdCropType: map['lcdCropType']?.toString(),
      lcdCropName: map['lcdCropName']?.toString(),
      lcdCulAreaLand: map['lcdCulAreaLand']?.toString(),
      lcdCulAreaSize: _toInt(map['lcdCulAreaSize']),
      lcdTypeOfLand: map['lcdTypeOfLand']?.toString(),
      lcdScaOfFin: _toInt(map['lcdScaOfFin']),
      lcdAddSofByRo: _toInt(map['lcdAddSofByRo']),
      lcdCostOfCul: _toInt(map['lcdCostOfCul']),
      lcdCovOfCrop: map['lcdCovOfCrop']?.toString(),
      lcdCropIns: map['lcdCropIns']?.toString(),
      lcdAddSofAmount: _toInt(map['lcdAddSofAmount']),
      lcdInsPre: _toInt(map['lcdInsPre']),
      lcdDueDateOfRepay: map['lcdDueDateOfRepay']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CropDetailsModal.fromJson(String source) =>
      CropDetailsModal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CropDetailsModal(lcdRowId: $lcdRowId, lcdProposalNo: $lcdProposalNo, lcdSeason: $lcdSeason, lcdCropType: $lcdCropType, lcdCropName: $lcdCropName, lcdCulAreaLand: $lcdCulAreaLand, lcdCulAreaSize: $lcdCulAreaSize, lcdTypeOfLand: $lcdTypeOfLand, lcdScaOfFin: $lcdScaOfFin, lcdAddSofByRo: $lcdAddSofByRo, lcdCostOfCul: $lcdCostOfCul, lcdCovOfCrop: $lcdCovOfCrop, lcdCropIns: $lcdCropIns, lcdAddSofAmount: $lcdAddSofAmount, lcdInsPre: $lcdInsPre, lcdDueDateOfRepay: $lcdDueDateOfRepay)';
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String && value.trim().isNotEmpty) {
      return int.tryParse(value);
    }
    if (value is double) return value.toInt();
    return null;
  }
}
