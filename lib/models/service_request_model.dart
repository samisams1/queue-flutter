class ServiceRequestModel {
  ServiceRequestModel({this.branchId});
  late final String? branchId;

  ServiceRequestModel.fromJson(Map<String, dynamic> json) {
    branchId = json['branchId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['branchId'] = branchId;
    return _data;
  }
}
