class CurrentUser{
  String name;
  String username;
  String whatsapp;
  String imgUrl;

  CurrentUser({required this.name,required this.imgUrl,required this.username,required this.whatsapp});

  CurrentUser.fromJson(Map<dynamic, dynamic> json)
      : name = json['name'],
        username = json['username'],
        whatsapp = json['whatsapp'],
        imgUrl = json['imgUrl'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['username'] = this.username;
    data['whatsapp'] = this.whatsapp;
    data['imgUrl'] = this.imgUrl;
    return data;
  }

}
