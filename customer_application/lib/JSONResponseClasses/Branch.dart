class Branch {
  String eRRORCODE;
  String eRRORMSG;
  List<OUTPUT> oUTPUT;

  Branch({this.eRRORCODE, this.eRRORMSG, this.oUTPUT});

  Branch.fromJson(Map<String, dynamic> json) {
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
  String branchcode;
  String branchname;
  String homebranch;
  String pincode;

  OUTPUT({this.branchcode, this.branchname, this.homebranch, this.pincode});

  OUTPUT.fromJson(Map<String, dynamic> json) {
    branchcode = json['branchcode'];
    branchname = json['branchname'];
    homebranch = json['homebranch'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branchcode'] = this.branchcode;
    data['branchname'] = this.branchname;
    data['homebranch'] = this.homebranch;
    data['pincode'] = this.pincode;
    return data;
  }
}