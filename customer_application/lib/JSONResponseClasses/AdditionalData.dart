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