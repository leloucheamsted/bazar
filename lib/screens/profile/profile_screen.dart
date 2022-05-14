import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:bazar/Services/user.dart';
import 'package:bazar/screens/profile/setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:stacked_services/stacked_services.dart';
// import '../../widgets/button.dart';
// import '../../widgets/profile_card.dart';
import 'package:bazar/config/palette.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final bool isUser;
  const ProfileScreen({required this.isUser, Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

late String? nom = '', pseudo = '', numero = '';

class _ProfileScreenState extends State<ProfileScreen> {
  //late Stream dataList;
  @override
  void initState() {
    // dataList = FirebaseFirestore.instance
    //     .collection('collection')
    //     .where('name', isEqualTo: 'lelouche')
    //     .orderBy('name')
    //     .snapshots();
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        numero = value.getString('numero');
        nom = value.getString('nom');
        pseudo = value.getString('pseudo');
      });
    });
    //getNumber();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark, // dark text for status bar
        statusBarColor: Colors.white));
    List<DocumentSnapshot> items;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
        color: Colors.white,
        child: Column(children: [
          // Top bar
          Container(
            padding: const EdgeInsets.all(15.0),
            child: Row(children: [
              Container(
                height: 90,
                width: 90,
                decoration:  BoxDecoration(
                  color: Palette.colorInput,
                  image: DecorationImage(
                      image: NetworkImage(
                          context.watch<User>().imgUrl
                      ),
                      fit: BoxFit.cover),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.read<User>().name?? '',
                    style: const TextStyle(
                      fontFamily: "Prompt_Regular",
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Color.fromRGBO(22, 23, 34, 1),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    context.read<User>().username ?? '',
                    style: const TextStyle(
                      fontFamily: "Prompt_SemiBold",
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Palette.colorText,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (widget.isUser)
                InkWell(
                  onTap: (() {
                    print('click');

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsProfile( name: context.watch<User>().name,username: context.watch<User>().username, whatsapp: context.watch<User>().whatsapp,
                            )));
                  }),
                  borderRadius: BorderRadius.circular(30),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          color: Palette.primaryColor,
                        ),
                        child: Center(
                            child: SvgPicture.asset('assets/settings.svg'))),
                  ),
                  // onPressed: () {},
                )
            ]),
          ),

          // Dividor
          const Divider(),

// Liste de publication
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Users").doc("e0CPkvCtazKCgTUAWP1U")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return  Text(
                    'Error in receiving trip list publication: ${snapshot.error}');
              }
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Text('Not connected to the Stream or null');

                case ConnectionState.waiting:
                  return const Text('Awaiting for interaction');

                case ConnectionState.active:
                  if (kDebugMode) {
                    print("Stream has started but not finished");
                  }

                 List<String>? list;
                  if (snapshot.hasData) {
                   list = List<dynamic>.from(snapshot.data!['publication'])
                        .cast<String>();
                  }

                  return Expanded(
                    child: MediaQuery.removeViewPadding(
                      context: context,
                      removeTop: true,
                      child: GridView.builder(
                          itemCount: list!.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          gridDelegate:
                          const  SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 9 / 16,
                            crossAxisCount: 3,
                            mainAxisSpacing: 1.5,
                            crossAxisSpacing: 1.5,
                          ),
                          itemBuilder: (BuildContext, index) {
                            return CardGif(urlGif: list![index]);
                          }),
                    ),
                  );
              }
              return const  SizedBox(
                child:  Text("No trip publication found."),
              );
            },
          )
        ]),

      ),
    );
  }
}

