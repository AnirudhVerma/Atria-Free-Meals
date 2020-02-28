class UserName {
  String deviceid;
  String clientAppName;
  String operatorid;
  String username;
  String password;
  String authtype;
  String rdxml;
  String accNum;
  String aadhaarAuthReq;
  String vendorid;
  String platform;
  String clientApptype;
  String usertypeinfo;
  String fcmId;
  String clientAppVer;
  String ts;

  UserName(
      {this.deviceid,
        this.clientAppName,
        this.operatorid,
        this.username,
        this.password,
        this.authtype,
        this.rdxml,
        this.accNum,
        this.aadhaarAuthReq,
        this.vendorid,
        this.platform,
        this.clientApptype,
        this.usertypeinfo,
        this.fcmId,
        this.clientAppVer,
        this.ts});

  UserName.fromJson(Map<String, dynamic> json) {
    deviceid = json['deviceid'];
    clientAppName = json['ClientAppName'];
    operatorid = json['operatorid'];
    username = json['username'];
    password = json['password'];
    authtype = json['authtype'];
    rdxml = json['rdxml'];
    accNum = json['accNum'];
    aadhaarAuthReq = json['AadhaarAuthReq'];
    vendorid = json['vendorid'];
    platform = json['platform'];
    clientApptype = json['client_apptype'];
    usertypeinfo = json['usertypeinfo'];
    fcmId = json['fcm_id'];
    clientAppVer = json['client_app_ver'];
    ts = json['ts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceid'] = this.deviceid;
    data['ClientAppName'] = this.clientAppName;
    data['operatorid'] = this.operatorid;
    data['username'] = this.username;
    data['password'] = this.password;
    data['authtype'] = this.authtype;
    data['rdxml'] = this.rdxml;
    data['accNum'] = this.accNum;
    data['AadhaarAuthReq'] = this.aadhaarAuthReq;
    data['vendorid'] = this.vendorid;
    data['platform'] = this.platform;
    data['client_apptype'] = this.clientApptype;
    data['usertypeinfo'] = this.usertypeinfo;
    data['fcm_id'] = this.fcmId;
    data['client_app_ver'] = this.clientAppVer;
    data['ts'] = this.ts;
    return data;
  }
}