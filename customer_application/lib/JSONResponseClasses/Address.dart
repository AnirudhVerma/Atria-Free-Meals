class Address {
  String eRRORCODE;
  String eRRORMSG;

  Address({this.eRRORCODE, this.eRRORMSG});

  Address.fromJson(Map<String, dynamic> json) {
    eRRORCODE = json['ERRORCODE'];
    eRRORMSG = json['ERRORMSG'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ERRORCODE'] = this.eRRORCODE;
    data['ERRORMSG'] = this.eRRORMSG;
    return data;
  }
}