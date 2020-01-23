class IndividualServiceDetails {
  String eRRORCODE;
  String eRRORMSG;
  List<Serviceinfo> serviceinfo;
  List<Details> details;
  List<AgentInfo> agentInfo;

  IndividualServiceDetails(
      {this.eRRORCODE,
        this.eRRORMSG,
        this.serviceinfo,
        this.details,
        this.agentInfo});

  IndividualServiceDetails.fromJson(Map<String, dynamic> json) {
    eRRORCODE = json['ERRORCODE'];
    eRRORMSG = json['ERRORMSG'];
    if (json['serviceinfo'] != null) {
      serviceinfo = new List<Serviceinfo>();
      json['serviceinfo'].forEach((v) {
        serviceinfo.add(new Serviceinfo.fromJson(v));
      });
    }
    if (json['Details'] != null) {
      details = new List<Details>();
      json['Details'].forEach((v) {
        details.add(new Details.fromJson(v));
      });
    }
    if (json['AgentInfo'] != null) {
      agentInfo = new List<AgentInfo>();
      json['AgentInfo'].forEach((v) {
        agentInfo.add(new AgentInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ERRORCODE'] = this.eRRORCODE;
    data['ERRORMSG'] = this.eRRORMSG;
    if (this.serviceinfo != null) {
      data['serviceinfo'] = this.serviceinfo.map((v) => v.toJson()).toList();
    }
    if (this.details != null) {
      data['Details'] = this.details.map((v) => v.toJson()).toList();
    }
    if (this.agentInfo != null) {
      data['AgentInfo'] = this.agentInfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Serviceinfo {
  String bookingid;
  String bank;
  String branchcode;
  String branchname;
  String deliveryaddress;
  String pincode;
  String serviceName;
  int serviceCharge;
  String lienMarkAccount;
  String serviceAccount;
  String authCodeCustomer;
  String requestDate;
  String sTATUS;
  String preferreddate;
  String slottime;
  String latitude;
  String longitude;
  Null remarks;
  List<CustomParams> customParams;

  Serviceinfo(
      {this.bookingid,
        this.bank,
        this.branchcode,
        this.branchname,
        this.deliveryaddress,
        this.pincode,
        this.serviceName,
        this.serviceCharge,
        this.lienMarkAccount,
        this.serviceAccount,
        this.authCodeCustomer,
        this.requestDate,
        this.sTATUS,
        this.preferreddate,
        this.slottime,
        this.latitude,
        this.longitude,
        this.remarks,
        this.customParams});

  Serviceinfo.fromJson(Map<String, dynamic> json) {
    bookingid = json['bookingid'];
    bank = json['bank'];
    branchcode = json['branchcode'];
    branchname = json['branchname'];
    deliveryaddress = json['deliveryaddress'];
    pincode = json['pincode'];
    serviceName = json['ServiceName'];
    serviceCharge = json['serviceCharge'];
    lienMarkAccount = json['LienMarkAccount'];
    serviceAccount = json['ServiceAccount'];
    authCodeCustomer = json['AuthCodeCustomer'];
    requestDate = json['request_date'];
    sTATUS = json['STATUS'];
    preferreddate = json['preferreddate'];
    slottime = json['slottime'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    remarks = json['remarks'];
    if (json['custom_params'] != null) {
      customParams = new List<CustomParams>();
      json['custom_params'].forEach((v) {
        customParams.add(new CustomParams.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingid'] = this.bookingid;
    data['bank'] = this.bank;
    data['branchcode'] = this.branchcode;
    data['branchname'] = this.branchname;
    data['deliveryaddress'] = this.deliveryaddress;
    data['pincode'] = this.pincode;
    data['ServiceName'] = this.serviceName;
    data['serviceCharge'] = this.serviceCharge;
    data['LienMarkAccount'] = this.lienMarkAccount;
    data['ServiceAccount'] = this.serviceAccount;
    data['AuthCodeCustomer'] = this.authCodeCustomer;
    data['request_date'] = this.requestDate;
    data['STATUS'] = this.sTATUS;
    data['preferreddate'] = this.preferreddate;
    data['slottime'] = this.slottime;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['remarks'] = this.remarks;
    if (this.customParams != null) {
      data['custom_params'] = this.customParams.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomParams {
  String nAME;
  String vALUE;

  CustomParams({this.nAME, this.vALUE});

  CustomParams.fromJson(Map<String, dynamic> json) {
    nAME = json['NAME'];
    vALUE = json['VALUE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NAME'] = this.nAME;
    data['VALUE'] = this.vALUE;
    return data;
  }
}

class Details {
  String sTATUS;
  String modifiedOn;
  String currentstatus;
  int stateorder;
  int stateid;
  String statevalue;

  Details(
      {this.sTATUS,
        this.modifiedOn,
        this.currentstatus,
        this.stateorder,
        this.stateid,
        this.statevalue});

  Details.fromJson(Map<String, dynamic> json) {
    sTATUS = json['STATUS'];
    modifiedOn = json['modified_on'];
    currentstatus = json['currentstatus'];
    stateorder = json['stateorder'];
    stateid = json['stateid'];
    statevalue = json['statevalue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['STATUS'] = this.sTATUS;
    data['modified_on'] = this.modifiedOn;
    data['currentstatus'] = this.currentstatus;
    data['stateorder'] = this.stateorder;
    data['stateid'] = this.stateid;
    data['statevalue'] = this.statevalue;
    return data;
  }
}

class AgentInfo {
  int userid;
  String agentname;
  String agentMobile;

  AgentInfo({this.userid, this.agentname, this.agentMobile});

  AgentInfo.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    agentname = json['agentname'];
    agentMobile = json['agent_mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['agentname'] = this.agentname;
    data['agent_mobile'] = this.agentMobile;
    return data;
  }
}