class AdditinalFields {
  List<Additionalfields> additionalfields;

  AdditinalFields({this.additionalfields});

  AdditinalFields.fromJson(Map<String, dynamic> json) {
    if (json['additionalfields'] != null) {
      additionalfields = new List<Additionalfields>();
      json['additionalfields'].forEach((v) {
        additionalfields.add(new Additionalfields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.additionalfields != null) {
      data['additionalfields'] =
          this.additionalfields.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Additionalfields {
  String nAME;
  String vALUE;

  Additionalfields({this.nAME, this.vALUE});

  Additionalfields.fromJson(Map<String, dynamic> json) {
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