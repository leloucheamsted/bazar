import 'dart:io';

import 'package:bazar/config/palette.dart';
import 'package:bazar/data/video.dart';
import 'package:bazar/widgets/circle_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/svg.dart';
import 'package:expandable/expandable.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddDetailsScreen extends StatefulWidget {
  const AddDetailsScreen({Key? key, required this.path}) : super(key: key);
  final String path;
  @override
  _AddDetailsScreenState createState() => _AddDetailsScreenState();
}

final List<String> Categories = <String>["Repas", "Habillements", "Mobilier"];
bool? isExpand;

TextEditingController detailsController = TextEditingController();
TextEditingController textPriceController =
    TextEditingController(); // Input price
TextEditingController nbreController =
    TextEditingController(); // input quantity
String choiceCategory = "Categories"; // string categoriex of product
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;
String price = "0";
String? details;
int NbrePiece = 01;

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  String? _chosenValue;

  @override
  void initState() {
    setState(() {
      price = "0";
      NbrePiece = 01;
      choiceCategory = "Categories";
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Palette.primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Palette.primaryColor,
        statusBarIconBrightness: Brightness.dark, // dark text for status bar
        statusBarColor: Colors.transparent));

    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Pour empecher le debordemnent de la page a l'affiche du cla
      backgroundColor: Palette.colorLight,
      body: Column(children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.fromLTRB(8, 40, 8, 0),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(30),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.arrow_back_outlined,
                          color: Palette.colorText,
                        ),
                      ),
                      // onPressed: () {},
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 18, 0),
                        child: Text(
                          'Details',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30.0,
                            fontFamily: 'Prompt_Bold',
                            color: Palette.colorText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),

                // Details du produit

                SizedBox(
                  height: 150,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    // height: 200,
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      color: Palette.colorgray,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(children: [
                      TextFormField(
                        controller: detailsController,
                        //  focusNode: focusNode,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        style: TextStyle(
                            color: Palette.colorText,
                            fontFamily: "Prompt_Regular",
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            fontSize: 22),
                        onChanged: (value) {
                          setState(() {
                            details = detailsController.text;
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Détails de l'article",
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Prompt_Regular",
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              fontSize: 22),
                        ),
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),

                /// List de categories
                ExpandableNotifier(
                  // <-- Provides ExpandableController to its children
                  child: Column(
                    children: [
                      Expandable(
                        // controller: controller,
                        // <-- Driven by ExpandableController from ExpandableNotifier
                        collapsed: ExpandableButton(
                          // <-- Expands when tapped on the cover photo
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            height: 50,
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              color: Palette.colorgray,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        choiceCategory,
                                        style: TextStyle(
                                          fontFamily: "Prompt_Regular",
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SvgPicture.asset('assets/drop.svg'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        expanded: Column(children: [
                          Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              height: 200,
                              alignment: Alignment.topLeft,
                              decoration: BoxDecoration(
                                color: Palette.colorgray,
                                borderRadius: BorderRadius.circular(15),
                              ),

                              //  Liste de Categories
                              child: ListView.builder(
                                  itemCount: Categories.length,
                                  itemBuilder: (BuildContext context, index) {
                                    var controller = ExpandableController.of(
                                        context,
                                        required: true);

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          choiceCategory =
                                              Categories[index].toString();
                                        });
                                        controller
                                            ?.toggle(); // fermeture du expandeur apres clique
                                      },
                                      child: Container(
                                        height: 50,
                                        child: ListTile(
                                            title: Text(
                                          Categories[index].toString(),
                                          style: TextStyle(
                                            fontFamily: "Prompt_Regular",
                                            fontSize: 20,
                                            color: Palette.colorText,
                                          ),
                                        )),
                                      ),
                                    );
                                  })),
                          ExpandableButton(
                            // <-- Collapses when tapped on
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.expand_less_sharp,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 12,
                ),

                // Prix et Nombre de piece
                Row(
                  children: [
                    //  Prix du produit
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        height: 50,
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          color: Palette.colorgray,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                                child: TextField(
                                  controller: textPriceController,
                                  autofocus: false,
                                  inputFormatters: <TextInputFormatter>[
                                    // PhoneNumberFormatter(),
                                    LengthLimitingTextInputFormatter(9),
                                    FilteringTextInputFormatter.allow(RegExp(
                                      "[^,.-]",
                                    )),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      price = value;
                                    });
                                  },
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'Prompt_Regular',
                                  ),
                                  decoration: InputDecoration.collapsed(
                                      hintStyle: TextStyle(color: Colors.grey),
                                      hintText: 'Item price'),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                'FCFA',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Prompt_Regular",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),

                    //  Nombres de pieces du produits
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: 50,
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        color: Palette.colorgray,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(children: [
                        // Bouton de soustraction
                        GestureDetector(
                          onTap: () {
                            if (NbrePiece == 1) {
                            } else {
                              setState(() {
                                NbrePiece -= 1;
                              });
                            }
                          },
                          child: Icon(
                            Icons.horizontal_rule,
                            size: 20,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        // Nombre de pieces
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialog(context),
                            );
                          },
                          child: Container(
                            width: 40,
                            child: Center(
                              child: Text(
                                NbrePiece.toString(),
                                style: TextStyle(
                                  color: Palette.colorText,
                                  fontSize: 20.0,
                                  fontFamily: 'Prompt_Regular',
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        // Boutton Pour ajoute
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              NbrePiece += 1;
                            });
                          },
                          child: Icon(Icons.add),
                        ),
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )),
        Container(
            color: Palette.primaryColor,
            width: MediaQuery.of(context).size.width,
            height: 60,
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap:(){
                      uploadStorage();
                      print("assj");
                    },
                child:  Padding(
                    padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                    child: Center(
                      child: Text(
                        'Post',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontFamily: "Prompt_Regular",
                          color: Palette.colorLight,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                ),
                Positioned(
                  child: InkWell(
                    onTap: () {
                      uploadStorage();
                      print("lelocueh");
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset('assets/next.svg'),
                    ),
                    // onPressed: () {},
                  ),
                ),
              ],
            )),
      ]),
    );
  }

// Popup de saisirr du Nombre de piece
  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text(
        'Number of rooms',
        style: TextStyle(
          color: Palette.colorText,
          fontSize: 20.0,
          fontFamily: 'Prompt_Regular',
        ),
      ),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 50,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              // height: 200,
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                color: Palette.colorgray,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(children: [
                TextFormField(
                  controller: nbreController,
                  //  focusNode: focusNode,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  minLines: 1,
                  style: TextStyle(
                      color: Palette.colorText,
                      fontFamily: "Prompt_Regular",
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      fontSize: 22),
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "10",
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Prompt_Regular",
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 22),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            setState(() {
              NbrePiece = int.parse(nbreController.text);
            });
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Valider'),
        ),
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }

// Fonction d'ajout de la video sur firebase et d'ajout de la publication
  Future uploadStorage() async {
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('name');
    try {
      await storage.ref('$user/$widget.path').putFile(
            File(widget.path),
          );
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('$user/$widget.path')
          .getDownloadURL();

      var data = [
        {
          "numeroVendeur": '$prefs.getString("number")',
          "prix": price,
          "nom": "$prefs.getString('name')",
          "video_title": "video_title",
          "Category": choiceCategory,
          "likes": 0,
          "details": details!,
          "profile": '$prefs.getString("photo")',
          "quantite": nbreController.text,
          "url": downloadURL
        }
      ];
      await FirebaseFirestore.instance.collection("Videos").add(data.first);
    } catch (e) {
      print(e);
    }
  }
}
