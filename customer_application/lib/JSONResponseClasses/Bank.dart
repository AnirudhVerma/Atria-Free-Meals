/*
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
  String icon;
//  String fetchAccparams;

  OUTPUT(
      {this.bankname,
        this.iin,
        this.bankCode,
        this.customerCareNumber,
        this.appid,
        this.ibUrl,
//        this.fetchAccparams,
        this.icon
      });

  OUTPUT.fromJson(Map<String, dynamic> json) {
    bankname = json['bankname'];
    iin = json['iin'];
    bankCode = json['bank_code'];
    customerCareNumber = json['customer_care_number'];
    appid = json['appid'];
    ibUrl = json['ib_url'];
    icon = json['icon'];
//    fetchAccparams = json['fetch_accparams'];
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
*/

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
  String icon;
  List<FetchAccparams> fetchAccparams;

  OUTPUT(
      {this.bankname,
        this.iin,
        this.bankCode,
        this.customerCareNumber,
        this.appid,
        this.ibUrl,
        this.icon,
        this.fetchAccparams});

  OUTPUT.fromJson(Map<String, dynamic> json) {
    bankname = json['bankname'];
    iin = json['iin'];
    bankCode = json['bank_code'];
    customerCareNumber = json['customer_care_number'];
    appid = json['appid'];
    ibUrl = json['ib_url'];
    icon = json['icon'];
    if (json['fetch_accparams'] != null) {
      fetchAccparams = new List<FetchAccparams>();
      json['fetch_accparams'].forEach((v) {
        fetchAccparams.add(new FetchAccparams.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bankname'] = this.bankname;
    data['iin'] = this.iin;
    data['bank_code'] = this.bankCode;
    data['customer_care_number'] = this.customerCareNumber;
    data['appid'] = this.appid;
    data['ib_url'] = this.ibUrl;
    data['icon'] = this.icon;
    if (this.fetchAccparams != null) {
      data['fetch_accparams'] =
          this.fetchAccparams.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FetchAccparams {
  String nAME;
  String rEGEX;
  String sEQUENCE;
  String dATATYPE;
  String mAXLENGTH;
  String mINLENGTH;
  String iSMANDATORY;

  FetchAccparams(
      {this.nAME,
        this.rEGEX,
        this.sEQUENCE,
        this.dATATYPE,
        this.mAXLENGTH,
        this.mINLENGTH,
        this.iSMANDATORY});

  FetchAccparams.fromJson(Map<String, dynamic> json) {
    nAME = json['NAME'];
    rEGEX = json['REGEX'];
    sEQUENCE = json['SEQUENCE'];
    dATATYPE = json['DATA_TYPE'];
    mAXLENGTH = json['MAX_LENGTH'];
    mINLENGTH = json['MIN_LENGTH'];
    iSMANDATORY = json['IS_MANDATORY'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NAME'] = this.nAME;
    data['REGEX'] = this.rEGEX;
    data['SEQUENCE'] = this.sEQUENCE;
    data['DATA_TYPE'] = this.dATATYPE;
    data['MAX_LENGTH'] = this.mAXLENGTH;
    data['MIN_LENGTH'] = this.mINLENGTH;
    data['IS_MANDATORY'] = this.iSMANDATORY;
    return data;
  }
}