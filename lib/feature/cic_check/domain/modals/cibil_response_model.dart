class CibilResponse {
  final String status;
  final String htmlFileCIR;

  CibilResponse({required this.status, required this.htmlFileCIR});

  factory CibilResponse.fromJson(Map<String, dynamic> json) {
    return CibilResponse(
      status: json['Status'] ?? '',
      htmlFileCIR: json['htmlFileCIR'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'Status': status,
    'htmlFileCIR': htmlFileCIR,
  };
}
