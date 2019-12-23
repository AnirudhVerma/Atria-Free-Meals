class ValidateOTP {
  String eRRORCODE;
  String eRRORMSG;
  String oUTPUT;

  ValidateOTP({this.eRRORCODE, this.eRRORMSG, this.oUTPUT});

  ValidateOTP.fromJson(Map<String, dynamic> json) {
    eRRORCODE = json['ERRORCODE'];
    eRRORMSG = json['ERRORMSG'];
    oUTPUT = json['OUTPUT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ERRORCODE'] = this.eRRORCODE;
    data['ERRORMSG'] = this.eRRORMSG;
    data['OUTPUT'] = this.oUTPUT;
    return data;
  }
}