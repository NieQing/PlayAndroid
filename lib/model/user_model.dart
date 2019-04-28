class UserModel {
  String errorMsg;
  int errorCode;
  UserDataModel data;

  UserModel({this.errorMsg, this.errorCode, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    this.errorMsg = json['errorMsg'];
    this.errorCode = json['errorCode'];
    this.data = json['data'] != null ? UserDataModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorMsg'] = this.errorMsg;
    data['errorCode'] = this.errorCode;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class UserDataModel {
  String email;
  String icon;
  String password;
  String token;
  String username;
  int id;
  int type;
  List<int> chapterTops;
  List<int> collectIds;

  UserDataModel(
      {this.email,
      this.icon,
      this.password,
      this.token,
      this.username,
      this.id,
      this.type,
      this.chapterTops,
      this.collectIds});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    this.email = json['email'];
    this.icon = json['icon'];
    this.password = json['password'];
    this.token = json['token'];
    this.username = json['username'];
    this.id = json['id'];
    this.type = json['type'];

    List<dynamic> chapterTopsList = json['chapterTops'];
    this.chapterTops = new List();
    this
        .chapterTops
        .addAll(chapterTopsList.map((o) => int.parse(o.toString())));

    List<dynamic> collectIdsList = json['collectIds'];
    this.collectIds = new List();
    this.collectIds.addAll(collectIdsList.map((o) => int.parse(o.toString())));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['icon'] = this.icon;
    data['password'] = this.password;
    data['token'] = this.token;
    data['username'] = this.username;
    data['id'] = this.id;
    data['type'] = this.type;
    data['chapterTops'] = this.chapterTops;
    data['collectIds'] = this.collectIds;
    return data;
  }
}
