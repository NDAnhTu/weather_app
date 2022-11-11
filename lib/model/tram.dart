class Tram {
  var doam;
  var id;
  var mua;
  var name;
  var nhietdo;

  Tram({this.doam, this.id, this.mua, this.name, this.nhietdo});

  Tram.fromJson(Map<String, dynamic> json) {
    doam = json['doam'];
    id = json['id'];
    mua = json['mua'];
    name = json['name'];
    nhietdo = json['nhietdo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['doam'] = doam;
    data['id'] = id;
    data['mua'] = mua;
    data['name'] = name;
    data['nhietdo'] = nhietdo;
    return data;
  }
}
