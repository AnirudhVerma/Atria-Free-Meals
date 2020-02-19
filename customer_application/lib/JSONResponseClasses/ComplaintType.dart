class ComplaintType {
  String eRRORCODE;
  String eRRORMSG;
  List<OUTPUT1> oUTPUT;

  ComplaintType({this.eRRORCODE, this.eRRORMSG, this.oUTPUT});

  ComplaintType.fromJson(Map<String, dynamic> json) {
    eRRORCODE = json['ERRORCODE'];
    eRRORMSG = json['ERRORMSG'];
    if (json['OUTPUT'] != null) {
      oUTPUT = new List<OUTPUT1>();
      json['OUTPUT'].forEach((v) {
        oUTPUT.add(new OUTPUT1.fromJson(v));
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

class OUTPUT1 {
  String complaintType;

  OUTPUT1({this.complaintType});

  OUTPUT1.fromJson(Map<String, dynamic> json) {
    complaintType = json['Complaint_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Complaint_type'] = this.complaintType;
    return data;
  }
}