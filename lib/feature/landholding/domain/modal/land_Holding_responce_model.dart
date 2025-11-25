import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:newsee/feature/landholding/domain/modal/LandData.dart';

class LandHoldingResponceModel {
  final List<LandData> agriLandHoldingsList;

  LandHoldingResponceModel({required this.agriLandHoldingsList});

  LandHoldingResponceModel copyWith({List<LandData>? agriLandHoldingsList}) {
    return LandHoldingResponceModel(
      agriLandHoldingsList: agriLandHoldingsList ?? this.agriLandHoldingsList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'agriLandHoldingsList':
          agriLandHoldingsList.map((e) => e.toMap()).toList(),
    };
  }

  factory LandHoldingResponceModel.fromMap(Map<String, dynamic> map) {
    return LandHoldingResponceModel(
      agriLandHoldingsList: List<LandData>.from(
        (map['agriLandHoldingsList'] ?? []).map(
          (e) {
            final m = Map<String, dynamic>.from(e);

            // Convert mixed numeric/string values safely
            m['lklTotAcre'] = m['lklTotAcre']?.toString();
            m['lklsumOfTotalAcreage'] = m['lklsumOfTotalAcreage']?.toString();

            return LandData.fromMap(m);
          },
          // (e) => {
          //   e['lklTotAcre'] = e['lklTotAcre'].toString(),
          //   e['lklsumOfTotalAcreage'] = e['lklsumOfTotalAcreage'].toString(),
          //   LandData.fromMap(Map<String, dynamic>.from(e)),
          // },
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory LandHoldingResponceModel.fromJson(dynamic source) {
    if (source is String) {
      return LandHoldingResponceModel.fromMap(json.decode(source));
    } else if (source is Map<String, dynamic>) {
      return LandHoldingResponceModel.fromMap(source);
    } else {
      throw Exception("Invalid source type for fromJson");
    }
  }

  @override
  String toString() =>
      'LandHoldingResponceModel(agriLandHoldingsList: $agriLandHoldingsList)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LandHoldingResponceModel &&
        listEquals(other.agriLandHoldingsList, agriLandHoldingsList);
  }

  @override
  int get hashCode => agriLandHoldingsList.hashCode;
}
