import 'package:bazar/screens/profile/setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../widgets/button.dart';
import '../../widgets/profile_card.dart';
import 'package:bazar/config/palette.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DocumentReference docs =
      FirebaseFirestore.instance.collection('collectionPath').doc('lelouche');
  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> items;
    return Container(
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
              decoration: BoxDecoration(
                color: Palette.colorInput,
                image: DecorationImage(
                    image: NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/basic-aede4.appspot.com/o/cabraule.jpg?alt=media&token=d43ea864-6f86-4b6f-b2cd-385ffb65b7b5'),
                    fit: BoxFit.cover),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FullName',
                  style: TextStyle(
                    fontFamily: "Prompt_Regular",
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Color.fromRGBO(22, 23, 34, 1),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'username',
                  style: TextStyle(
                    fontFamily: "Prompt_SemiBold",
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Palette.colorText,
                  ),
                ),
              ],
            ),
            Spacer(),
            InkWell(
              onTap: (() {
                print('click');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsProfile()));
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
                    child:
                        Center(child: SvgPicture.asset('assets/settings.svg'))),
              ),
              // onPressed: () {},
            )
          ]),
        ),

        // Dividor
        Divider(),

// Liste de publication
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc('lelouche')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return new Text(
                  'Error in receiving trip list publication: ${snapshot.error}');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return new Text('Not connected to the Stream or null');

              case ConnectionState.waiting:
                return new Text('Awaiting for interaction');

              case ConnectionState.active:
                print("Stream has started but not finished");
                var totalPublishCount = 0;

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
                            new SliverGridDelegateWithFixedCrossAxisCount(
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
            return Container(
              child: new Text("No trip publication found."),
            );
          },
        )
      ]),
    );
  }
}
