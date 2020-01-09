class BankOTPResponse {
  String eRRORCODE;
  String eRRORMSG;
  OUTPUT oUTPUT;

  BankOTPResponse({this.eRRORCODE, this.eRRORMSG, this.oUTPUT});

  BankOTPResponse.fromJson(Map<String, dynamic> json) {
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
  String bankuniqrefnum;
  String uniqrefnum;

  OUTPUT({this.bankuniqrefnum, this.uniqrefnum});

  OUTPUT.fromJson(Map<String, dynamic> json) {
    bankuniqrefnum = json['bankuniqrefnum'];
    uniqrefnum = json['uniqrefnum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bankuniqrefnum'] = this.bankuniqrefnum;
    data['uniqrefnum'] = this.uniqrefnum;
    return data;
  }
}