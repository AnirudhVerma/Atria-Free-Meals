class enReq {
  String ts;
  String username;
  String data;

  enReq({this.ts, this.username, this.data});

  enReq.fromJson(Map<String, dynamic> json) {
    ts = json['ts'];
    username = json['username'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ts'] = this.ts;
    data['username'] = this.username;
    data['data'] = this.data;
    return data;
  }
}