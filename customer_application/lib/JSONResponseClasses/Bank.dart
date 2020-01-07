class Bank {
  String eRRORCODE;
  String eRRORMSG;
  List<OUTPUT> oUTPUT;

  Bank({this.eRRORCODE, this.eRRORMSG, this.oUTPUT});

  Bank.fromJson(Map<String, dynamic> json) {
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
  String bankname;
  String iin;
  String bankCode;
  String customerCareNumber;
  String appid;
  String ibUrl;

  OUTPUT(
      {this.bankname,
        this.iin,
        this.bankCode,
        this.customerCareNumber,
        this.appid,
        this.ibUrl});

  OUTPUT.fromJson(Map<String, dynamic> json) {
    bankname = json['bankname'];
    iin = json['iin'];
    bankCode = json['bank_code'];
    customerCareNumber = json['customer_care_number'];
    appid = json['appid'];
    ibUrl = json['ib_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bankname'] = this.bankname;
    data['iin'] = this.iin;
    data['bank_code'] = this.bankCode;
    data['customer_care_number'] = this.customerCareNumber;
    data['appid'] = this.appid;
    data['ib_url'] = this.ibUrl;
    return data;
  }
}