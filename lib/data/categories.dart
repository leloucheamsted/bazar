// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// //import 'package:video_player/video_player.dart';
// import 'package:cached_video_player/cached_video_player.dart';

// class Categories {
//   String cat_1;
//   String cat_2;
//   String cat_3;
//   String cat_4;
//   String cat_5;
//   String cat_6;
//   String cat_7;
//   String cat_8;
//   String cat_9;
//   String cat_91;

//   Categories(
//       {required this.cat_1,
//       required this.cat_2,
//       required this.cat_3,
//       required this.cat_4,
//       required this.cat_5,
//       required this.cat_6,
//       required this.cat_7,
//       required this.cat_8,
//       required this.cat_9,
//       required this.cat_91,
//     });

//   Categories.fromJson(Map<dynamic, dynamic> json)
//       : cat_1 = json['cat_1'],
//         cat_2 = json['cat_2'],
//         cat_3 = json['cat_3'],
//         cat_4 = json['cat_4'],
//         cat_5 = json['cat_5'],
//         cat_6 = json['cat_6'],
//         cat_7 = json['cat_7'],
//         cat_8 = json['cat_8'],
//         cat_9 = json['cat_9'],
//         cat_91 = json['cat_91'];

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['numeroVendeur'] = this.numeroVendeur;
//     data['nom'] = this.nom;
//     data['username'] = this.username;
//     data['profile'] = this.profile;
//     data['video_title'] = this.video_title;
//     data['Category'] = this.Category;
//     data['quantite'] = this.quantite;
//     data['likes'] = this.likes;
//     data['details'] = this.details;
//     data['prix'] = this.prix;
//     data['url'] = this.url;
//     return data;
//   }

//   static Video fromSnap(DocumentSnapshot snap) {
//     var snapshot = snap.data() as Map<String, dynamic>;

//     return Video(
//       numeroVendeur: snapshot['numeroVendeur'],
//       nom: snapshot['nom'],
//       username: snapshot['username'],
//       profile: snapshot['profile'],
//       likes: snapshot['likes'],
//       video_title: snapshot['video_title'],
//       Category: snapshot['Category'],
//       quantite: snapshot['quantite'],
//       //likes: snapshot['caption'],
//       details: snapshot['details'],
//       prix: snapshot['prix'],
//       url: snapshot['url'],
//     );
//   }

//   Future<Null> loadController() async {
//     controller = VideoPlayerController.network(url);
//     await controller
//         ?.initialize()
//         .then((value) => debugPrint('Controller Initialiszed!!'));
//     controller?.setLooping(true);
//   }
// }
