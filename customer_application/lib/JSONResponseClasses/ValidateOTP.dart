class ValidateOTP {
  String eRRORCODE;
  String eRRORMSG;
  String oUTPUT;

  ValidateOTP._privateConstructor();  //Singleton start

  static final ValidateOTP instance = ValidateOTP._privateConstructor();

  factory ValidateOTP({String eRRORCODE,String eRRORMSG,String oUTPUT}){
    instance.eRRORMSG = eRRORMSG;
    instance.eRRORCODE = eRRORCODE;
    instance.oUTPUT = oUTPUT;
    return instance;
  }                                     //Singleton End

//  ValidateOTP({this.eRRORCODE, this.eRRORMSG, this.oUTPUT});

  ValidateOTP get myValidateOTP {
    return instance;
  }

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