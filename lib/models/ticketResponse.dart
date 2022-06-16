class ticketRespose {
  int? id;
  String? ticketNumber;
  String? status;
  String? windowNumber;
  int? updatedBy;

  ticketRespose(
      {required this.id,
      required this.ticketNumber,
      required this.status,
      required this.windowNumber,
      required this.updatedBy});

  ticketRespose.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ticketNumber = json['ticketNumber'];
    status = json['status'];
    windowNumber = json['windowNumber'];
    updatedBy = json['updatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ticketNumber'] = this.ticketNumber;
    data['status'] = this.status;
    data['windowNumber'] = this.windowNumber;
    data['updatedBy'] = this.updatedBy;
    return data;
  }
}
