class FirstResponse {
  String eRRORCODE;
  String eRRORMSG;
  List<OUTPUT> oUTPUT;

  FirstResponse({this.eRRORCODE, this.eRRORMSG, this.oUTPUT});

  FirstResponse.fromJson(Map<String, dynamic> json) {
    eRRORCODE = json['ERRORCODE'];
    eRRORMSG = json['ERRORMSG'];
    if (json['OUTPUT'] != null) {
      oUTPUT = new List<OUTPUT>();
      json['OUTPUT'].forEach((v) {
        oUTPUT.add(new OUTPUT.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ERRORCODE'] = this.eRRORCODE;
    data['ERRORMSG'] = this.eRRORMSG;
    if (this.oUTPUT != null) {
      data['OUTPUT'] = this.oUTPUT.map((v) => v.toJson()).toList();
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
  String mobilenumber;
  String alternatemobile;

  OUTPUT(
      {this.userid,
        this.username,
        this.firstname,
        this.usertype,
        this.authtype,
        this.mobilenumber,
        this.alternatemobile});

  OUTPUT.fromJson(Map<String, dynamic> json) {
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