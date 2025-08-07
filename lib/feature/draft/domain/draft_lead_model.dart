class DraftLead {
  final String leadref;
  final Map<String, dynamic> loan;
  final Map<String, dynamic> dedupe;
  final Map<String, dynamic> personal;
  final Map<String, dynamic> address;
  final List<Map<String, dynamic>> coapplicant;

  DraftLead({
    required this.leadref,
    required this.loan,
    required this.dedupe,
    required this.personal,
    required this.address,
    required this.coapplicant,
  });

  Map<String, dynamic> toJson() => {
    'leadref': leadref,
    'loan': loan,
    'dedupe': dedupe,
    'personal': personal,
    'address': address,
    'coapplicant': coapplicant,
  };

  factory DraftLead.fromJson(Map<String, dynamic> json) => DraftLead(
    leadref: json['leadref'],
    loan: Map<String, dynamic>.from(json['loan'] ?? {}),
    dedupe: Map<String, dynamic>.from(json['dedupe'] ?? {}),
    personal: Map<String, dynamic>.from(json['personal'] ?? {}),
    address: Map<String, dynamic>.from(json['address'] ?? {}),
    coapplicant: List<Map<String, dynamic>>.from(json['coapplicant'] ?? []),
  );
}
