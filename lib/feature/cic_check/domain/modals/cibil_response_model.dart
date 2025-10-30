class CibilResponse {
  final String status;
  // final ResponseInfo responseInfo;
  // final Authentication authentication;
  final String htmlFileCIR;

  CibilResponse({
    required this.status,
    // required this.responseInfo,
    // required this.authentication,
    required this.htmlFileCIR,
  });

  factory CibilResponse.fromJson(Map<String, dynamic> json) {
    return CibilResponse(
      status: json['Status'] ?? '',
      // responseInfo: ResponseInfo.fromJson(json['ResponseInfo'] ?? {}),
      // authentication: Authentication.fromJson(json['Authentication'] ?? {}),
      htmlFileCIR: json['htmlFileCIR'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'Status': status,
    // 'ResponseInfo': responseInfo.toJson(),
    // 'Authentication': authentication.toJson(),
    'htmlFileCIR': htmlFileCIR,
  };
}

// class ResponseInfo {
//   final int applicationId;
//   final String solutionSetInstanceId;
//   final String currentQueue;

//   ResponseInfo({
//     required this.applicationId,
//     required this.solutionSetInstanceId,
//     required this.currentQueue,
//   });

//   factory ResponseInfo.fromJson(Map<String, dynamic> json) {
//     return ResponseInfo(
//       applicationId: json['ApplicationId'] ?? 0,
//       solutionSetInstanceId: json['SolutionSetInstanceId'] ?? '',
//       currentQueue: json['CurrentQueue'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'ApplicationId': applicationId,
//     'SolutionSetInstanceId': solutionSetInstanceId,
//     'CurrentQueue': currentQueue,
//   };
// }

// class Authentication {
//   final String status;
//   final String token;

//   Authentication({required this.status, required this.token});

//   factory Authentication.fromJson(Map<String, dynamic> json) {
//     return Authentication(
//       status: json['Status'] ?? '',
//       token: json['Token'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() => {'Status': status, 'Token': token};
// }
