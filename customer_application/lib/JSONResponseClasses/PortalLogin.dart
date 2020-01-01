class PortalLogin {
  String eRRORCODE;
  String eRRORMSG;
  OUTPUT oUTPUT;

  PortalLogin._privateConstructor();  //Singleton start

  static final PortalLogin instance = PortalLogin._privateConstructor();

  factory PortalLogin({String eRRORCODE,String eRRORMSG,OUTPUT oUTPUT}){
    instance.eRRORMSG = eRRORMSG;
    instance.eRRORCODE = eRRORCODE;
    instance.oUTPUT = oUTPUT;
    return instance;
  }                                     //Singleton End

//  PortalLogin({this.eRRORCODE, this.eRRORMSG, this.oUTPUT});

  PortalLogin.fromJson(Map<String, dynamic> json) {
    eRRORCODE = json['ERRORCODE'];
    eRRORMSG = json['ERRORMSG'];
    oUTPUT =
    json['OUTPUT'] != null ? new OUTPUT.fromJson(json['OUTPUT']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ERRORCODE'] = this.eRRORCODE;
    data['ERRORMSG'] = this.eRRORMSG;
    if (this.oUTPUT != null) {
      data['OUTPUT'] = this.oUTPUT.toJson();
    }
    return data;
  }
}

class OUTPUT {
  Token token;
  User user;
  List<String> userDet;

  OUTPUT({this.token, this.user, this.userDet});

  OUTPUT.fromJson(Map<String, dynamic> json) {
    token = json['token'] != null ? new Token.fromJson(json['token']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    userDet = json['userDet'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.token != null) {
      data['token'] = this.token.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['userDet'] = this.userDet;
    return data;
  }
}

class Token {
  String accessToken;
  String refreshToken;
  UserDet userDet;

  Token({this.accessToken, this.refreshToken, this.userDet});

  Token.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    userDet =
    json['userDet'] != null ? new UserDet.fromJson(json['userDet']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['refreshToken'] = this.refreshToken;
    if (this.userDet != null) {
      data['userDet'] = this.userDet.toJson();
    }
    return data;
  }
}

class UserDet {
  List<String> userDet;
  UserInfo userInfo;

  UserDet({this.userDet, this.userInfo});

  UserDet.fromJson(Map<String, dynamic> json) {
    userDet = json['userDet'].cast<String>();
    userInfo = json['userInfo'] != null
        ? new UserInfo.fromJson(json['userInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userDet'] = this.userDet;
    if (this.userInfo != null) {
      data['userInfo'] = this.userInfo.toJson();
    }
    return data;
  }
}

class UserInfo {
  String aadhaarAuthReq;
  String accNum;
  String authtype;
  String clientAppVer;
  String clientApptype;
  String deviceid;
  String isMerchant;
  String operatorid;
  String password;
  String platform;
  String rdxml;
  String username;
  String vendorid;

  UserInfo(
      {this.aadhaarAuthReq,
        this.accNum,
        this.authtype,
        this.clientAppVer,
        this.clientApptype,
        this.deviceid,
        this.isMerchant,
        this.operatorid,
        this.password,
        this.platform,
        this.rdxml,
        this.username,
        this.vendorid});

  UserInfo.fromJson(Map<String, dynamic> json) {
    aadhaarAuthReq = json['AadhaarAuthReq'];
    accNum = json['accNum'];
    authtype = json['authtype'];
    clientAppVer = json['client_app_ver'];
    clientApptype = json['client_apptype'];
    deviceid = json['deviceid'];
    isMerchant = json['isMerchant'];
    operatorid = json['operatorid'];
    password = json['password'];
    platform = json['platform'];
    rdxml = json['rdxml'];
    username = json['username'];
    vendorid = json['vendorid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AadhaarAuthReq'] = this.aadhaarAuthReq;
    data['accNum'] = this.accNum;
    data['authtype'] = this.authtype;
    data['client_app_ver'] = this.clientAppVer;
    data['client_apptype'] = this.clientApptype;
    data['deviceid'] = this.deviceid;
    data['isMerchant'] = this.isMerchant;
    data['operatorid'] = this.operatorid;
    data['password'] = this.password;
    data['platform'] = this.platform;
    data['rdxml'] = this.rdxml;
    data['username'] = this.username;
    data['vendorid'] = this.vendorid;
    return data;
  }
}

class User {
  String alternatenumber;
  String authtype;
  String email;
  String firstloggedintime;
  int hierarchyid;
  int isapprover;
  String ispasswordchangereq;
  String lastloggedintime;
  int levelid;
  String mobilenumber;
  String name;
  int numberoffailedattempts;
  int overridePermission;
  String securityq;
  int userid;
  String username;
  String usertype;

  User(
      {this.alternatenumber,
        this.authtype,
        this.email,
        this.firstloggedintime,
        this.hierarchyid,
        this.isapprover,
        this.ispasswordchangereq,
        this.lastloggedintime,
        this.levelid,
        this.mobilenumber,
        this.name,
        this.numberoffailedattempts,
        this.overridePermission,
        this.securityq,
        this.userid,
        this.username,
        this.usertype});

  User.fromJson(Map<String, dynamic> json) {
    alternatenumber = json['alternatenumber'];
    authtype = json['authtype'];
    email = json['email'];
    firstloggedintime = json['firstloggedintime'];
    hierarchyid = json['hierarchyid'];
    isapprover = json['isapprover'];
    ispasswordchangereq = json['ispasswordchangereq'];
    lastloggedintime = json['lastloggedintime'];
    levelid = json['levelid'];
    mobilenumber = json['mobilenumber'];
    name = json['name'];
    numberoffailedattempts = json['numberoffailedattempts'];
    overridePermission = json['override_permission'];
    securityq = json['securityq'];
    userid = json['userid'];
    username = json['username'];
    usertype = json['usertype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alternatenumber'] = this.alternatenumber;
    data['authtype'] = this.authtype;
    data['email'] = this.email;
    data['firstloggedintime'] = this.firstloggedintime;
    data['hierarchyid'] = this.hierarchyid;
    data['isapprover'] = this.isapprover;
    data['ispasswordchangereq'] = this.ispasswordchangereq;
    data['lastloggedintime'] = this.lastloggedintime;
    data['levelid'] = this.levelid;
    data['mobilenumber'] = this.mobilenumber;
    data['name'] = this.name;
    data['numberoffailedattempts'] = this.numberoffailedattempts;
    data['override_permission'] = this.overridePermission;
    data['securityq'] = this.securityq;
    data['userid'] = this.userid;
    data['username'] = this.username;
    data['usertype'] = this.usertype;
    return data;
  }
}