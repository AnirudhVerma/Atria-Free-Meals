class FetchUserReq {
  AdditionalData additionalData;
  String mobilenumber;
  String type;
  String usertype;

  FetchUserReq(
      {this.additionalData, this.mobilenumber, this.type, this.usertype});

  FetchUserReq.fromJson(Map<String, dynamic> json) {
    additionalData = json['additionalData'] != null
        ? new AdditionalData.fromJson(json['additionalData'])
        : null;
    mobilenumber = json['mobilenumber'];
    type = json['type'];
    usertype = json['usertype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.additionalData != null) {
      data['additionalData'] = this.additionalData.toJson();
    }
    data['mobilenumber'] = this.mobilenumber;
    data['type'] = this.type;
    data['usertype'] = this.usertype;
    return data;
  }
}

class AdditionalData {
  String clientAppVer;
  String clientApptype;
  String platform;
  String vendorid;
  String clientAppName;

  AdditionalData(
      {this.clientAppVer,
        this.clientApptype,
        this.platform,
        this.vendorid,
        this.clientAppName});

  AdditionalData.fromJson(Map<String, dynamic> json) {
    clientAppVer = json['client_app_ver'];
    clientApptype = json['client_apptype'];
    platform = json['platform'];
    vendorid = json['vendorid'];
    clientAppName = json['ClientAppName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['client_app_ver'] = this.clientAppVer;
    data['client_apptype'] = this.clientApptype;
    data['platform'] = this.platform;
    data['vendorid'] = this.vendorid;
    data['ClientAppName'] = this.clientAppName;
    return data;
  }
}