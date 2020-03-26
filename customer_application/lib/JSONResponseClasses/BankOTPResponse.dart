/*
class BankOTPResponse {
  String eRRORCODE;
  String eRRORMSG;
  List<OUTPUT> oUTPUT;

  BankOTPResponse({this.eRRORCODE, this.eRRORMSG, this.oUTPUT});

  BankOTPResponse.fromJson(Map<String, dynamic> json) {
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
}*/

class BankOTPResponse {
  String eRRORCODE;
  String eRRORMSG;
  List<OUTPUT> oUTPUT;
  String sERVERDATE;
  String sERVERTIME;

  BankOTPResponse(
      {this.eRRORCODE,
        this.eRRORMSG,
        this.oUTPUT,
        this.sERVERDATE,
        this.sERVERTIME});

  BankOTPResponse.fromJson(Map<String, dynamic> json) {
    eRRORCODE = json['ERRORCODE'];
    eRRORMSG = json['ERRORMSG'];
    if (json['OUTPUT'] != null) {
      oUTPUT = new List<OUTPUT>();
      json['OUTPUT'].forEach((v) {
        oUTPUT.add(new OUTPUT.fromJson(v));
      });
    }
    sERVERDATE = json['SERVERDATE'];
    sERVERTIME = json['SERVERTIME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ERRORCODE'] = this.eRRORCODE;
    data['ERRORMSG'] = this.eRRORMSG;
    if (this.oUTPUT != null) {
      data['OUTPUT'] = this.oUTPUT.map((v) => v.toJson()).toList();
    }
    data['SERVERDATE'] = this.sERVERDATE;
    data['SERVERTIME'] = this.sERVERTIME;
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