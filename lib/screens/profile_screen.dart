import 'package:flutter/material.dart';

import '../widgets/button.dart';
import '../widgets/profile_card.dart';
import 'package:bazar/config/palette.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0,40,0,0),
      color:Colors.black,
      child: Column(
        children:[
          Container(
            color: Colors.red,
            padding: const EdgeInsets.all(15.0),
            child:Row(
              children:[
                Container(
                  height:100,
                  width:100,
                  decoration: BoxDecoration(
                      color:Palette.secondColor,
                 image:DecorationImage(image:NetworkImage('https://firebasestorage.googleapis.com/v0/b/basic-aede4.appspot.com/o/cabraule.jpg?alt=media&token=d43ea864-6f86-4b6f-b2cd-385ffb65b7b5') ),
                    shape: BoxShape.circle,
                  ),
                 
                )
              ]
            ),
          ),
        ]
      ),
        );
  }
}
