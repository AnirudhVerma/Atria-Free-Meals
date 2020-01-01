class Address {
  String eRRORCODE;
  String eRRORMSG;
  List<OUTPUT> oUTPUT;

  Address({this.eRRORCODE, this.eRRORMSG, this.oUTPUT});

  Address.fromJson(Map<String, dynamic> json) {
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
  int addressid;
  String address;
  String latitude;
  String longitude;
  String pincode;

  OUTPUT(
      {this.addressid,
        this.address,
        this.latitude,
        this.longitude,
        this.pincode});

  OUTPUT.fromJson(Map<String, dynamic> json) {
    addressid = json['addressid'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addressid'] = this.addressid;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['pincode'] = this.pincode;
    return data;
  }
}