class ServiceResponseModel {
  int? id;
  String? value;
  String? status;
  String? createdAt;
  String? updatedAt;

  ServiceResponseModel(
      {required this.id,
      required this.value,
      required this.status,
      required this.createdAt,
      required this.updatedAt});

  ServiceResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
