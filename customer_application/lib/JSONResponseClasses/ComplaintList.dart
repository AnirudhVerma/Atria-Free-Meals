class ComplaintList {
  String eRRORCODE;
  String eRRORMSG;
  List<OUTPUT2> oUTPUT;
  String sERVERDATE;
  String sERVERTIME;

  ComplaintList(
      {this.eRRORCODE,
        this.eRRORMSG,
        this.oUTPUT,
        this.sERVERDATE,
        this.sERVERTIME});

  ComplaintList.fromJson(Map<String, dynamic> json) {
    eRRORCODE = json['ERRORCODE'];
    eRRORMSG = json['ERRORMSG'];
    if (json['OUTPUT'] != null) {
      oUTPUT = new List<OUTPUT2>();
      json['OUTPUT'].forEach((v) {
        oUTPUT.add(new OUTPUT2.fromJson(v));
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

class OUTPUT2 {
  String complaintList;

  OUTPUT2({this.complaintList});

  OUTPUT2.fromJson(Map<String, dynamic> json) {
    complaintList = json['ComplaintList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ComplaintList'] = this.complaintList;
    return data;
  }
}