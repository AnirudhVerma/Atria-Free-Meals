class GeneratedOTP {
  String eRRORCODE;
  String eRRORMSG;
  OUTPUT oUTPUT;

  GeneratedOTP._privateConstructor();  //Singleton start

  static final GeneratedOTP instance = GeneratedOTP._privateConstructor();

  factory GeneratedOTP({String eRRORCODE,String eRRORMSG,OUTPUT oUTPUT}){
    instance.eRRORMSG = eRRORMSG;
    instance.eRRORCODE = eRRORCODE;
    instance.oUTPUT = oUTPUT;
    return instance;
  }                                     //Singleton End

//  GeneratedOTP({this.eRRORCODE, this.eRRORMSG, this.oUTPUT});      // previous code

  GeneratedOTP.fromJson(Map<String, dynamic> json) {
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
  int userid;
  String username;
  String firstname;
  String usertype;
  String authtype;

  OUTPUT(
      {this.userid,
        this.username,
        this.firstname,
        this.usertype,
        this.authtype});

  OUTPUT.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    username = json['username'];
    firstname = json['firstname'];
    usertype = json['usertype'];
    authtype = json['authtype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['username'] = this.username;
    data['firstname'] = this.firstname;
    data['usertype'] = this.usertype;
    data['authtype'] = this.authtype;
    return data;
  }
}