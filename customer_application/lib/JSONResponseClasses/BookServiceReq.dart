class BookServiceReq {
  AdditionalData additionalData;
  String mobilenumber;
  String customerid;
  String customername;
  String requesttime;
  String dEVICEID;
  String serviceid;
  String servicetype;
  String servicecategory;
  String servicename;
  String servicecharge;
  String bankcode;
  String bankname;
  String branchcode;
  String branchname;
  String addressid;
  String address;
  String lienmarkaccounttype;
  String lienmarkaccount;
  String serviceaccounttype;
  String serviceaccount;
  String prefereddate;
  String slot;
  String channel;
  String ccagentid;
  String authorization;
  String username;
  String ts;
  String latitude;
  String longitude;
  String pincode;
  String servicecode;
  String customParams;

  BookServiceReq(
      {this.additionalData,
        this.mobilenumber,
        this.customerid,
        this.customername,
        this.requesttime,
        this.dEVICEID,
        this.serviceid,
        this.servicetype,
        this.servicecategory,
        this.servicename,
        this.servicecharge,
        this.bankcode,
        this.bankname,
        this.branchcode,
        this.branchname,
        this.addressid,
        this.address,
        this.lienmarkaccounttype,
        this.lienmarkaccount,
        this.serviceaccounttype,
        this.serviceaccount,
        this.prefereddate,
        this.slot,
        this.channel,
        this.ccagentid,
        this.authorization,
        this.username,
        this.ts,
        this.latitude,
        this.longitude,
        this.pincode,
        this.servicecode,
        this.customParams});

  BookServiceReq.fromJson(Map<String, dynamic> json) {
    additionalData = json['additionalData'] != null
        ? new AdditionalData.fromJson(json['additionalData'])
        : null;
    mobilenumber = json['mobilenumber'];
    customerid = json['customerid'];
    customername = json['customername'];
    requesttime = json['requesttime'];
    dEVICEID = json['DEVICEID'];
    serviceid = json['serviceid'];
    servicetype = json['servicetype'];
    servicecategory = json['servicecategory'];
    servicename = json['servicename'];
    servicecharge = json['servicecharge'];
    bankcode = json['bankcode'];
    bankname = json['bankname'];
    branchcode = json['branchcode'];
    branchname = json['branchname'];
    addressid = json['addressid'];
    address = json['address'];
    lienmarkaccounttype = json['lienmarkaccounttype'];
    lienmarkaccount = json['lienmarkaccount'];
    serviceaccounttype = json['serviceaccounttype'];
    serviceaccount = json['serviceaccount'];
    prefereddate = json['prefereddate'];
    slot = json['slot'];
    channel = json['channel'];
    ccagentid = json['ccagentid'];
    authorization = json['authorization'];
    username = json['username'];
    ts = json['ts'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    pincode = json['pincode'];
    servicecode = json['servicecode'];
    customParams = json['custom_params'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.additionalData != null) {
      data['additionalData'] = this.additionalData.toJson();
    }
    data['mobilenumber'] = this.mobilenumber;
    data['customerid'] = this.customerid;
    data['customername'] = this.customername;
    data['requesttime'] = this.requesttime;
    data['DEVICEID'] = this.dEVICEID;
    data['serviceid'] = this.serviceid;
    data['servicetype'] = this.servicetype;
    data['servicecategory'] = this.servicecategory;
    data['servicename'] = this.servicename;
    data['servicecharge'] = this.servicecharge;
    data['bankcode'] = this.bankcode;
    data['bankname'] = this.bankname;
    data['branchcode'] = this.branchcode;
    data['branchname'] = this.branchname;
    data['addressid'] = this.addressid;
    data['address'] = this.address;
    data['lienmarkaccounttype'] = this.lienmarkaccounttype;
    data['lienmarkaccount'] = this.lienmarkaccount;
    data['serviceaccounttype'] = this.serviceaccounttype;
    data['serviceaccount'] = this.serviceaccount;
    data['prefereddate'] = this.prefereddate;
    data['slot'] = this.slot;
    data['channel'] = this.channel;
    data['ccagentid'] = this.ccagentid;
    data['authorization'] = this.authorization;
    data['username'] = this.username;
    data['ts'] = this.ts;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['pincode'] = this.pincode;
    data['servicecode'] = this.servicecode;
    data['custom_params'] = this.customParams;


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

class CustomParams {
  String name;
  String value;

  CustomParams({this.name, this.value});

  CustomParams.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}