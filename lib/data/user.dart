class CurrentUser {
  String name;
  String username;
  String whatsapp;
  String imgUrl;

  CurrentUser(
      {required this.name,
      required this.imgUrl,
      required this.username,
      required this.whatsapp});

  CurrentUser.fromJson(Map<dynamic, dynamic> json)
      : name = json['name'],
        username = json['username'],
        whatsapp = json['whatsapp'],
        imgUrl = json['avatarUrl'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['username'] = username;
    data['whatsapp'] = whatsapp;
    data['avatarUrl'] = imgUrl;
    return data;
  }
}
