class TimeSlot {
  String eRRORCODE;
  String eRRORMSG;
  List<OUTPUT> oUTPUT;

  TimeSlot({this.eRRORCODE, this.eRRORMSG, this.oUTPUT});

  TimeSlot.fromJson(Map<String, dynamic> json) {
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
  String slotnumber;
  String avalabilityStatus;

  OUTPUT({this.slotnumber, this.avalabilityStatus});

  OUTPUT.fromJson(Map<String, dynamic> json) {
    slotnumber = json['slotnumber'];
    avalabilityStatus = json['AvalabilityStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slotnumber'] = this.slotnumber;
    data['AvalabilityStatus'] = this.avalabilityStatus;
    return data;
  }
}