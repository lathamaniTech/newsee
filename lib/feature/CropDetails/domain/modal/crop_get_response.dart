// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:newsee/feature/CropDetails/domain/modal/cropdetailsmodal.dart';

class CropGetResponse {
  List<CropDetailsModal>? agriCropDetails;
  // Map<String, dynamic>? agriLandDetails;
  String? ErrorMessage;
  CropGetResponse({
    this.agriCropDetails,
    // this.agriLandDetails,
    this.ErrorMessage,
  });

  CropGetResponse copyWith({
    List<CropDetailsModal>? agriCropDetails,
    Map<String, dynamic>? agriLandDetails,
    String? ErrorMessage,
  }) {
    return CropGetResponse(
      agriCropDetails: agriCropDetails ?? this.agriCropDetails,
      // agriLandDetails: agriLandDetails ?? this.agriLandDetails,
      ErrorMessage: ErrorMessage ?? this.ErrorMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'agriCropDetails': agriCropDetails?.map((x) => x.toMap()).toList(),
      // 'agriLandDetails': agriLandDetails,
      'ErrorMessage': ErrorMessage,
    };
  }

  factory CropGetResponse.fromMap(Map<String, dynamic> map) {
    return CropGetResponse(
      agriCropDetails:
          map['agriCropDetails'] != null
              ? List<CropDetailsModal>.from(
                (map['agriCropDetails'] as List<int>).map<CropDetailsModal?>(
                  (x) => CropDetailsModal.fromMap(x as Map<String, dynamic>),
                ),
              )
              : null,
      // agriLandDetails:
      //     map['agriLandDetails'] != null
      //         ? Map<String, dynamic>.from(
      //           (map['agriLandDetails'] as Map<String, dynamic>),
      //         )
      //         : null,
      ErrorMessage:
          map['ErrorMessage'] != null ? map['ErrorMessage'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CropGetResponse.fromJson(String source) =>
      CropGetResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CropGetResponse(agriCropDetails: $agriCropDetails, ErrorMessage: $ErrorMessage)';

  @override
  bool operator ==(covariant CropGetResponse other) {
    if (identical(this, other)) return true;

    return listEquals(other.agriCropDetails, agriCropDetails) &&
        // mapEquals(other.agriLandDetails, agriLandDetails) &&
        other.ErrorMessage == ErrorMessage;
  }

  @override
  int get hashCode =>
      agriCropDetails.hashCode ^
      // agriLandDetails.hashCode ^
      ErrorMessage.hashCode;
}
