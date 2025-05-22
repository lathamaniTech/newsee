// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Sourcingdetails extends Equatable {
  final String businessdescription;
  final String sourcingchannel;
  final String sourcingid;
  final String sourcingname;
  final String preferredbranch;
  final String? leadID;
  Sourcingdetails({
    required this.businessdescription,
    required this.sourcingchannel,
    required this.sourcingid,
    required this.sourcingname,
    required this.preferredbranch,
    required this.leadID,
  });

  Sourcingdetails copyWith({
    String? businessdescription,
    String? sourcingchannel,
    String? sourcingid,
    String? sourcingname,
    String? preferredbranch,
    String? leadID,
  }) {
    return Sourcingdetails(
      businessdescription: businessdescription ?? this.businessdescription,
      sourcingchannel: sourcingchannel ?? this.sourcingchannel,
      sourcingid: sourcingid ?? this.sourcingid,
      sourcingname: sourcingname ?? this.sourcingname,
      preferredbranch: preferredbranch ?? this.preferredbranch,
      leadID: leadID ?? this.leadID,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'businessdescription': businessdescription,
      'sourcingchannel': sourcingchannel,
      'sourcingid': sourcingid,
      'sourcingname': sourcingname,
      'preferredbranch': preferredbranch,
      'leadID': leadID,
    };
  }

  factory Sourcingdetails.fromMap(Map<String, dynamic> map) {
    return Sourcingdetails(
      businessdescription: map['businessdescription'] as String,
      sourcingchannel: map['sourcingchannel'] as String,
      sourcingid: map['sourcingid'] as String,
      sourcingname: map['sourcingname'] as String,
      preferredbranch: map['preferredbranch'] as String,
      leadID: map['leadID'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Sourcingdetails.fromJson(String source) =>
      Sourcingdetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Sourcingdetails(businessdescription: $businessdescription, sourcingchannel: $sourcingchannel, sourcingid: $sourcingid, sourcingname: $sourcingname, preferredbranch: $preferredbranch, leadID: $leadID)';
  }

  @override
  bool operator ==(covariant Sourcingdetails other) {
    if (identical(this, other)) return true;

    return other.businessdescription == businessdescription &&
        other.sourcingchannel == sourcingchannel &&
        other.sourcingid == sourcingid &&
        other.sourcingname == sourcingname &&
        other.preferredbranch == preferredbranch &&
        other.leadID == leadID;
  }

  @override
  int get hashCode {
    return businessdescription.hashCode ^
        sourcingchannel.hashCode ^
        sourcingid.hashCode ^
        sourcingname.hashCode ^
        preferredbranch.hashCode ^
        leadID.hashCode;
  }

  @override
  List<Object?> get props => [
    businessdescription,
    sourcingchannel,
    sourcingid,
    sourcingname,
    preferredbranch,
    leadID,
  ];
}
