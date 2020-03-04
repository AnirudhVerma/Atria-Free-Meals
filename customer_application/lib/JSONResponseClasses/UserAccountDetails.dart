class UserAccountDetails {
  String eRRORCODE;
  String eRRORMSG;
  List<OUTPUT> oUTPUT;

  UserAccountDetails({this.eRRORCODE, this.eRRORMSG, this.oUTPUT});

  UserAccountDetails.fromJson(Map<String, dynamic> json) {
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
  String bankuniqrefnum;
  String uniqrefnum;
  List<String> accountnumber;

  OUTPUT({this.bankuniqrefnum, this.uniqrefnum, this.accountnumber});

  OUTPUT.fromJson(Map<String, dynamic> json) {
    bankuniqrefnum = json['bankuniqrefnum'];
    uniqrefnum = json['uniqrefnum'];
    if(json['accountnumber']!=null)
      accountnumber = json['accountnumber'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bankuniqrefnum'] = this.bankuniqrefnum;
    data['uniqrefnum'] = this.uniqrefnum;
    data['accountnumber'] = this.accountnumber;
    return data;
  }
}