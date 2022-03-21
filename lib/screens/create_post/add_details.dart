import 'dart:io';
import 'package:bazar/Services/service_video.dart';
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
import 'dart:convert';

class AddDetailsScreen extends StatefulWidget {
  const AddDetailsScreen({Key? key}) : super(key: key);

  @override
  _AddDetailsScreenState createState() => _AddDetailsScreenState();
}

final List<String> Categories = <String>["Repas", "Habillements", "Mobilier"];
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
bool PopCatShow = false;
List<String> catList = <String>[];
late VideoService service;

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  String? _chosenValue;
  List<String> list = <String>[];

  @override
  void initState() {
    service = VideoService();
    setState(() {
      PopCatShow = false;
      price = "0";
      NbrePiece = 01;
      choiceCategory = "Category";
    });
    Cat();
    // TODO: implement initState
    super.initState();
  }

  Cat() async {
    //  list = await service.getCategories();
    (await FirebaseFirestore.instance
        .collection('Categories_Produits')
        .doc('fN0wAauWilUfslhBQGA3')
        .get()
        .then((value) => list = (value as dynamic)['List']));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Palette.colorLight,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Palette.colorLight,
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

                GestureDetector(
                  onTap: () {
                    setState(() {
                      PopCatShow = !PopCatShow;
                    });

                    PopupListCategoris();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    height: 50,
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      color: Palette.colorgray,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              choiceCategory,
                              style: TextStyle(
                                fontFamily: "Prompt_Regular",
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Palette.colorText,
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: (() => PopupListCategoris()),
                              child: SvgPicture.asset('assets/plus.svg')),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 12,
                ),
                Container(
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
                          padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
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
                                price = textPriceController.text;
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

                SizedBox(
                  height: 12,
                ),
                // Prix et Nombre de piece

                //  Prix du produit

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
                    Spacer(),
                    // Nombre de pieces
                    GestureDetector(
                      onTap: () {
                        AddPopup(context);
                      },
                      child: Expanded(
                        child: Container(
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
                    ),
                    Spacer(),
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
                Text(
                  '*Tap to enter amount in stock manually',
                  style: TextStyle(
                      fontFamily: "Prompt_Regular",
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Palette.secondColor),
                ),
              ],
            ),
          ),
        )),
        Container(
            color: details != "" &&
                    price.length != "" &&
                    choiceCategory != "Categories"
                ? Palette.primaryColor
                : Palette.disable,
            width: MediaQuery.of(context).size.width,
            height: 60,
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      details != "" &&
                              price.length != "" &&
                              choiceCategory != "Categories"
                          ? uploadStorage()
                          : null;
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                      child: Center(
                        child: Text(
                          'Publish',
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

// Fonction d'ajout de la video sur firebase et d'ajout de la publication
  Future uploadStorage() async {
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('name');
    try {
      // await storage.ref('$user/$widget.path').putFile(
      //       File(widget.path),
      //     );
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

  // Popup dajout de quantite

  void AddPopup(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Palette.colorgray,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: TextField(
                            controller: nbreController,
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                color: Palette.colorText,
                                fontFamily: "Prompt_Regular",
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                                fontSize: 22),
                            onChanged: (value) {
                              NbrePiece = int.parse(nbreController.text);
                            },
                            decoration: new InputDecoration.collapsed(
                              hintText: 'Enter quantity in stock',
                              hintStyle: TextStyle(
                                fontFamily: "Prompt_Regular",
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color.fromRGBO(117, 117, 117, 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                        child: InkWell(
                          onTap: () async {
                            // Allez a l'onglet 2
                            FocusScope.of(context).unfocus();
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SvgPicture.asset('assets/expand.svg')),
                        ),
                      ),
                      // onPressed: () {},
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        });
  }

// Popup List categories
  void PopupListCategoris() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              height: MediaQuery.of(context).size.height * 2,
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    color: Palette.primaryColor,
                  ),
                  Container(
                    height: 50,
                    color: Palette.primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Icon(
                                  Icons.arrow_back_outlined,
                                  color: Palette.colorLight,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Text(
                                  'Choice Category',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontFamily: 'Prompt_Bold',
                                    color: Palette.colorLight,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(list[index]);
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }
}
