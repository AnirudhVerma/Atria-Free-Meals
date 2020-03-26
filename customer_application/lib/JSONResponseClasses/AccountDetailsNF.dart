class AccountDetailsNF {
  String eRRORCODE;
  String eRRORMSG;
  List<OUTPUT> oUTPUT;

  AccountDetailsNF({this.eRRORCODE, this.eRRORMSG, this.oUTPUT});

  AccountDetailsNF.fromJson(Map<String, dynamic> json) {
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
  List<Accountnumber> accountnumber;

  OUTPUT({this.bankuniqrefnum, this.uniqrefnum, this.accountnumber});

  OUTPUT.fromJson(Map<String, dynamic> json) {
    bankuniqrefnum = json['bankuniqrefnum'];
    uniqrefnum = json['uniqrefnum'];
    if (json['accountnumber'] != null) {
      accountnumber = new List<Accountnumber>();
      json['accountnumber'].forEach((v) {
        accountnumber.add(new Accountnumber.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bankuniqrefnum'] = this.bankuniqrefnum;
    data['uniqrefnum'] = this.uniqrefnum;
    if (this.accountnumber != null) {
      data['accountnumber'] =
          this.accountnumber.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Accountnumber {
  String branchcode;
  String accountnumber;
  String custname;

  Accountnumber({this.branchcode, this.accountnumber, this.custname});

  Accountnumber.fromJson(Map<String, dynamic> json) {
    branchcode = json['branchcode'];
    accountnumber = json['accountnumber'];
    custname = json['custname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branchcode'] = this.branchcode;
    data['accountnumber'] = this.accountnumber;
    data['custname'] = this.custname;
    return data;
  }
}