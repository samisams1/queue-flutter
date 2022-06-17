class ticketRespose {
  int? id;
  int? ticketNumber;
  String? status;
  String? windowNumber;
  String? updatedBy;
  int? serviceId;

  ticketRespose({
    required this.id,
    required this.ticketNumber,
    required this.status,
    required this.windowNumber,
    required this.updatedBy,
    required this.serviceId,
  });

  ticketRespose.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ticketNumber = json['ticketNumber'];
    status = json['status'];
    windowNumber = json['windowNumber'];
    updatedBy = json['updatedBy'];
    serviceId = json['serviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ticketNumber'] = this.ticketNumber;
    data['status'] = this.status;
    data['windowNumber'] = this.windowNumber;
    data['updatedBy'] = this.updatedBy;
    data['serviceId'] = this.serviceId;
    return data;
  }
}
