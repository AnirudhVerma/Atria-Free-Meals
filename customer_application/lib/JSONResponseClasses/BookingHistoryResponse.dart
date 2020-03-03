class BookingHistoryResponse {
  String eRRORCODE;
  String eRRORMSG;
  List<OUTPUT> oUTPUT;

  BookingHistoryResponse({this.eRRORCODE, this.eRRORMSG, this.oUTPUT});

  BookingHistoryResponse.fromJson(Map<String, dynamic> json) {
    eRRORCODE = json['ERRORCODE'];
    eRRORMSG = json['ERRORMSG'];
    if (json['OUTPUT'] != null) {
      oUTPUT = new List<OUTPUT>();

      try {
        json['OUTPUT'].forEach((v) {
                oUTPUT.add(new OUTPUT.fromJson(v));
              });
      } catch (e) {
        print(e);
      }
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
  String bookingid;
  String bank;
  String branchcode;
  String branchname;
  String deliveryaddress;
  String pincode;
  String serviceName;
  int serviceCharge;
  String requestDate;
  String sTATUS;
  String preferreddate;
  String slottime;
  String remarks;
  List<CustomParams> customParams;

  OUTPUT(
      {this.bookingid,
        this.bank,
        this.branchcode,
        this.branchname,
        this.deliveryaddress,
        this.pincode,
        this.serviceName,
        this.serviceCharge,
        this.requestDate,
        this.sTATUS,
        this.preferreddate,
        this.slottime,
        this.remarks,
        this.customParams});

  OUTPUT.fromJson(Map<String, dynamic> json) {
    bookingid = json['bookingid'];
    bank = json['bank'];
    branchcode = json['branchcode'];
    branchname = json['branchname'];
    deliveryaddress = json['deliveryaddress'];
    pincode = json['pincode'];
    serviceName = json['ServiceName'];
    serviceCharge = json['serviceCharge'];
    requestDate = json['request_date'];
    sTATUS = json['STATUS'];
    preferreddate = json['preferreddate'];
    slottime = json['slottime'];
    remarks = json['remarks'];
    if (json['custom_params'] != null) {
      customParams = new List<CustomParams>();
      json['custom_params'].forEach((v) {
        customParams.add(new CustomParams.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingid'] = this.bookingid;
    data['bank'] = this.bank;
    data['branchcode'] = this.branchcode;
    data['branchname'] = this.branchname;
    data['deliveryaddress'] = this.deliveryaddress;
    data['pincode'] = this.pincode;
    data['ServiceName'] = this.serviceName;
    data['serviceCharge'] = this.serviceCharge;
    data['request_date'] = this.requestDate;
    data['STATUS'] = this.sTATUS;
    data['preferreddate'] = this.preferreddate;
    data['slottime'] = this.slottime;
    data['remarks'] = this.remarks;
    if (this.customParams != null) {
      data['custom_params'] = this.customParams.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomParams {
  String nAME;
  String vALUE;

  CustomParams({this.nAME, this.vALUE});

  CustomParams.fromJson(Map<String, dynamic> json) {
    nAME = json['NAME'];
    vALUE = json['VALUE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NAME'] = this.nAME;
    data['VALUE'] = this.vALUE;
    return data;
  }
}