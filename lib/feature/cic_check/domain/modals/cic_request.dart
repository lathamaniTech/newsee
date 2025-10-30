// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:newsee/AppData/app_constants.dart';

class CICRequest extends Equatable {
  final String? bankName;
  final String? moduleName;
  final String? apiName;
  final String? refNo;
  final String? appno;
  final String? module;
  final String? cbsId;

  const CICRequest({
    this.bankName = AppConstants.bankName,
    this.moduleName = AppConstants.moduleName,
    this.apiName = AppConstants.cibilApiName,
    this.refNo,
    this.appno,
    this.module = AppConstants.module,
    this.cbsId,
  });

  CICRequest copyWith({
    String? bankName,
    String? moduleName,
    String? apiName,
    String? refNo,
    String? appno,
    String? module,
    String? cbsId,
  }) {
    return CICRequest(
      bankName: bankName ?? this.bankName,
      moduleName: moduleName ?? this.moduleName,
      apiName: apiName ?? this.apiName,
      refNo: refNo ?? this.refNo,
      appno: appno ?? this.appno,
      module: module ?? this.module,
      cbsId: cbsId ?? this.cbsId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'BankName': bankName,
      'ModuleName': moduleName,
      'ApiName': apiName,
      'RefNo': refNo,
      'appno': appno,
      'module': module,
      'cbsId': cbsId,
    };
  }

  factory CICRequest.fromMap(Map<String, dynamic> map) {
    return CICRequest(
      bankName: map['BankName'],
      moduleName: map['ModuleName'],
      apiName: map['ApiName'],
      refNo: map['RefNo'],
      appno: map['appno'],
      module: map['module'],
      cbsId: map['cbsId'],
    );
  }

  String toJson() => json.encode(toMap());
  factory CICRequest.fromJson(String source) =>
      CICRequest.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
    bankName,
    moduleName,
    apiName,
    refNo,
    appno,
    module,
    cbsId,
  ];
}
