class BookService {
  String eRRORCODE;
  String eRRORMSG;
  List<OUTPUT> oUTPUT;

  BookService({this.eRRORCODE, this.eRRORMSG, this.oUTPUT});

  BookService.fromJson(Map<String, dynamic> json) {
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
  String bookingId;
  String response;

  OUTPUT({this.bookingId, this.response});

  OUTPUT.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    response = json['response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['response'] = this.response;
    return data;
  }
}