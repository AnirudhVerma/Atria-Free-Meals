class SelectedService {
  OUTPUT oUTPUT;

  SelectedService({this.oUTPUT});

  SelectedService.fromJson(Map<String, dynamic> json) {
    oUTPUT =
    json['OUTPUT'] != null ? new OUTPUT.fromJson(json['OUTPUT']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.oUTPUT != null) {
      data['OUTPUT'] = this.oUTPUT.toJson();
    }
    return data;
  }
}

class OUTPUT {
  String serviceid;
  String servicename;
  String servicecode;
  String description;
  String serviceCharge;
  String homebranch;
  List<CustomParams> customParams;
  String servicetype;
  String servicecategory;

  OUTPUT(
      {this.serviceid,
        this.servicename,
        this.servicecode,
        this.description,
        this.serviceCharge,
        this.homebranch,
        this.customParams,
        this.servicetype,
        this.servicecategory});

  OUTPUT.fromJson(Map<String, dynamic> json) {
    serviceid = json['serviceid'];
    servicename = json['servicename'];
    servicecode = json['servicecode'];
    description = json['description'];
    serviceCharge = json['service_charge'];
    homebranch = json['homebranch'];
    if (json['custom_params'] != null) {
      customParams = new List<CustomParams>();
      json['custom_params'].forEach((v) {
        customParams.add(new CustomParams.fromJson(v));
      });
    }
    servicetype = json['servicetype'];
    servicecategory = json['servicecategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serviceid'] = this.serviceid;
    data['servicename'] = this.servicename;
    data['servicecode'] = this.servicecode;
    data['description'] = this.description;
    data['service_charge'] = this.serviceCharge;
    data['homebranch'] = this.homebranch;
    if (this.customParams != null) {
      data['custom_params'] = this.customParams.map((v) => v.toJson()).toList();
    }
    data['servicetype'] = this.servicetype;
    data['servicecategory'] = this.servicecategory;
    return data;
  }
}

class CustomParams {
  List<LIST> lIST;
  String nAME;
  String rEGEX;
  String sEQUENCE;
  String dATATYPE;
  String mAXLENGTH;
  String mINLENGTH;
  String iSMANDATORY;

  CustomParams(
      {this.lIST,
        this.nAME,
        this.rEGEX,
        this.sEQUENCE,
        this.dATATYPE,
        this.mAXLENGTH,
        this.mINLENGTH,
        this.iSMANDATORY});

  CustomParams.fromJson(Map<String, dynamic> json) {
    if (json['LIST'] != null) {
      lIST = new List<LIST>();
      json['LIST'].forEach((v) {
        lIST.add(new LIST.fromJson(v));
      });
    }
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
    if (this.lIST != null) {
      data['LIST'] = this.lIST.map((v) => v.toJson()).toList();
    }
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

class LIST {
  String name;
  String value;

  LIST({this.name, this.value});

  LIST.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}