class FirstResponse {
  String eRRORCODE;
  String eRRORMSG;
  OUTPUTOBJECT oUTPUTOBJECT;

  FirstResponse({this.eRRORCODE, this.eRRORMSG, this.oUTPUTOBJECT});

  FirstResponse.fromJson(Map<String, dynamic> json) {
    eRRORCODE = json['ERRORCODE'];
    eRRORMSG = json['ERRORMSG'];
    oUTPUTOBJECT = json['OUTPUTOBJECT'] != null
        ? new OUTPUTOBJECT.fromJson(json['OUTPUTOBJECT'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ERRORCODE'] = this.eRRORCODE;
    data['ERRORMSG'] = this.eRRORMSG;
    if (this.oUTPUTOBJECT != null) {
      data['OUTPUTOBJECT'] = this.oUTPUTOBJECT.toJson();
    }
    return data;
  }
}

class OUTPUTOBJECT {
  int userid;
  String username;
  String firstname;
  String usertype;
  String authtype;
  String mobilenumber;
  String alternatemobile;

  OUTPUTOBJECT(
      {this.userid,
        this.username,
        this.firstname,
        this.usertype,
        this.authtype,
        this.mobilenumber,
        this.alternatemobile});

  OUTPUTOBJECT.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    username = json['username'];
    firstname = json['firstname'];
    usertype = json['usertype'];
    authtype = json['authtype'];
    mobilenumber = json['mobilenumber'];
    alternatemobile = json['alternatemobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['username'] = this.username;
    data['firstname'] = this.firstname;
    data['usertype'] = this.usertype;
    data['authtype'] = this.authtype;
    data['mobilenumber'] = this.mobilenumber;
    data['alternatemobile'] = this.alternatemobile;
    return data;
  }
}