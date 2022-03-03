import 'dart:convert';

import 'package:video_player/video_player.dart';

class Video {
  String numeroVendeur;
  String video_title;
  String prix;
  String Category;
  String quantite;
  String url;
  String likes;
  String details;
  String nom;
  String profile;
  VideoPlayerController? controller;

  Video(
      {required this.numeroVendeur,
      required this.prix,
      required this.nom,
      required this.video_title,
      required this.Category,
      required this.likes,
      required this.details,
      required this.profile,
      required this.quantite,
      required this.url});

  Video.fromJson(Map<dynamic, dynamic> json)
      : numeroVendeur = json['numeroVendeur'],
        nom = json['nom'],
        profile = json['profile'],
        video_title = json['video_title'],
        Category = json['Category'],
        quantite = json['quantite'],
        likes = json['likes'],
        details = json['details'],
        prix = json['prix'],
        url = json['url'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numeroVendeur'] = this.numeroVendeur;
    data['nom'] = this.nom;
    data['profile'] = this.profile;
    data['video_title'] = this.video_title;
    data['Category'] = this.Category;
    data['quantite'] = this.quantite;
    data['likes'] = this.likes;
    data['details'] = this.details;
    data['prix'] = this.prix;
    data['url'] = this.url;
    return data;
  }

  Future<Null> loadController() async {
    controller = VideoPlayerController.network(url);
    await controller?.initialize();
    controller?.setLooping(true);
  }
}
